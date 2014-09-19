"""
views.py handles all the controllers for the application.

This file will eventually be separated into various files for each
of the main sections of the application.  Currently it contains views,
for all the features to date.
"""

from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect, Http404, HttpResponseNotFound

# authentication libraries
# base django user system
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm

# we can use this as a pre condition for any method that requires the user to be logged in
# which will probably be all of them.  You can see below that the index method uses this
from django.contrib.auth.decorators import login_required, user_passes_test

# used to make django objects into json
from django.core import serializers
from django.forms.models import model_to_dict
from django.forms.util import ErrorList
import json

#  Imports all the lexers and the formatters currently needed
# to highlight the source code
from pygments import *
from pygments.lexers import *
from pygments.formatters import *
from pygments.styles import *

from review.models import *

from help.models import Post

# imports any helpers we might need to write
from helpers import staffTest, LineException
from helpers import staffTest, isTutor, enrolledTest

# imports the form for assignment creation
from forms import AssignmentForm, UserCreationForm, AssignmentSubmissionForm, uploadFile, annotationForm, annotationRangeForm, AllocateReviewsForm

from django.utils import timezone

# For handling assignments submitted via git repo
from git_handler import *

# For randomly assigning students to review particular submissions.
from assign_reviews import *

import os
import os.path


@login_required(login_url='/review/login_redirect/')
def index(request):

    """
    index(HttpRequest) is the default index view for the application.
    If the user is a student then they are redirected to the student_homepage
    view.

    Attributes:
       request(HttpRequest) -- the http request from the user

    Returns:
        HttpResponse - Renders the http request using the given context and the
        sidebar.html template.
    """
    context = {}
    """
    this is the basic index view, it required login before the user can do any
    as you can see at the moment this shows nothing other than a logout button
    as I haven't added any content to it yet
    """
    # whatever stuff we're goign to show in the index page needs to
    # generated here
    U = User.objects.get(id=request.user.id)
    context['user'] = U
    if U.reviewuser.isStaff:
        try:
            courses = U.reviewuser.courses.all()
            context['courses'] = courses
            return render(request, 'navbar.html', context)
        except Exception as UserExcept:
            print UserExcept.args
    else:  # user is student
        return student_homepage(request)

    return render(request, 'navbar.html', context)


def logout(request):

    """
    logout(request) - Simple logout function to remove the users authentication

    Parameters:
        request (HttpRequest) -- Users http request
    Returns:
        HttpReponse -- the use will be logged out and redirected to a simple
        logout page

    """
    logout(request)
    return HttpResponse("logout")

@login_required(login_url='/review/login_redirect/')
# @user_passes_test(staffTest)
def coursePage(request, course_code):
    """
    coursePage(request, course_code) - redirects the user to
    the course page for their desired course. If the course
    does not exist then they will be redirected to a 404 page.

    Parameters:
        request (HttpRequest) -- users http request object
        course_code (HttpRequest) -- the desired course code embedded in the
        httprequest object.

    Returns:
    HttpResponse -- if the function is successful the user will be redirected
    to the desired course page using render(), with the correct context
    dictionary, otherwise they will redirected toa 404.
    """
    context = {}
    # get the current assignments for the subject

    # grab the user from the http request
    try:
        U = User.objects.get(id=request.user.id)
        context['user'] = U
        
        # grab course code from http reqest and attempt to find course
        # in database
        code = course_code.encode('ascii', 'ignore')
        c = Course.objects.get(course_code=code)

        if not enrolledTest(U.reviewuser, c):
            error_message = "You are not enrolled in " + c.course_code
            print "Not enrolled"
            return error_page(request, error_message)
            # return HttpResponseRedirect('/')

        # get all current assignments for that course
        assignments = c.assignments.all()
        courses = U.reviewuser.courses.all()

        context['tutor'] = isTutor(U, c)
        
        context['assignments'] = assignments
        context['course'] = c

        context['courses'] = courses
        return render(request, 'course_page.html', context)
    except Exception as UserExcept:
        print UserExcept.args
        raise Http404

    return render(request, 'course_page.html', context)


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def create_assignment(request, course_code):
    """
    create_assignment is used by the staff memebers of the system to create
    new assignments for the students.

    Parameters:
    request (HttpRequest) -- Request to create assignment
    course_code (String) -- encoded string of the courses code

    Returns:
    HttpReponse rendering the new_assignment template
    """

    context = {}

    # grab course code from the url and convert to a string from unicode
    code = course_code.encode('ascii', 'ignore')
    # grab the course object for the course
    c = Course.objects.get(course_code=code)

    # generate form for new assignemnt, thing this will get changed
    # to a pre specified form rather than a generated form
    form = AssignmentForm()

    # add all the data to the context dict
    context['form'] = form
    context['course'] = c

    return render(request, 'admin/new_assignment.html', context)


#  The following 3 views are simply for use in testing, they return all the
#  current users and courses.

@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def createUser(request):

    context = {}
    userForm = UserCreationForm()
    context['form'] = userForm

    return render(request, 'admin/userCreate.html', context)


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def courseAdmin(request):
    """
    Dummy Course admin for the review admin
    """
    context = {}
    courses = Course.objects.all()
    context['courses'] = courses

    return render(request, 'admin/courseList.html', context)


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def userAdmin(request):
    """
    Dummy User administration for the review admin
    """
    context = {}
    users = User.objects.all()
    context['users'] = users

    return render(request, 'admin/userList.html', context)


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def validateAssignment(request):
    """
    Validates the data from the assignment creation form.
    If the data is valid then it creates the assignment,
    otherwise the user is kicked back to the form to fix the data

    Parameters:
    request (HttpRequest) -- http request from the user to create an assignment

    Returns:
    HttpResponse redirecting the usr to either the course page,
    or back to the assignment creation form to fix any errors.
    """

    form = None
    context = {}
    # gets the data from the post request
    if request.method == "POST":
        print request
        form = AssignmentForm(request.POST)
        print request.POST['course_code']
        if form.is_valid():
            try:
                # gets the cleaned data from the post request
                print "Creating assignment"
                course = Course.objects.get(id=request.POST['course_code'])
                name = form.cleaned_data['name']
                repository_format = form.cleaned_data['repository_format']
                first_display_date = form.cleaned_data['first_display_date']
                submission_open_date = form.cleaned_data['submission_open_date']
                submission_close_date = form.cleaned_data['submission_close_date']
                review_open_date = form.cleaned_data['review_open_date']
                review_close_date = form.cleaned_data['review_close_date']

                # Create the new assignment object and try saving it
                ass = Assignment.objects.create(course_code=course, name=name,
                                                repository_format=repository_format,
                                                first_display_date=first_display_date,
                                                submission_open_date=submission_open_date,
                                                submission_close_date=submission_close_date,
                                                review_open_date=review_open_date,
                                                review_close_date=review_close_date)
                ass.save()
            except Exception as AssError:
                # prints the exception to console
                print AssError.args

            return HttpResponseRedirect('/review/course_admin/')

    # form isn't valid and needs fixing so redirect back with the form data
    context['form'] = form
    context['course'] = Course.objects.get(id=request.POST['course_code'])

    return render(request, 'admin/new_assignment.html', context)


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def validateUser(request):
    """
    validates the data for user creation, pretty much the same as the view above
    but for users.  Also creates a new review user for the user.  The user must
    be a staff member to use this view.

    Parameters:
    request (HttpRequest) -- http request by the user to create a new user

    Returns:
    HttpReponse redirecting the user to either the userList admin or
    back to the user creation form to fix any errors.
    """

    form = None
    context = {}

    if request.method == "POST":
        # grab form from the request
        form = UserCreationForm(request.POST)

        if form.is_valid():
            try:
                # grab the cleaned data from the form and try creating a
                # new user object
                username = form.cleaned_data['username']
                first_name = form.cleaned_data['first_name']
                last_name = form.cleaned_data['last_name']
                email = form.cleaned_data['email']
                password = form.cleaned_data['password']
                is_staff = form.cleaned_data['is_staff']
                newUser = User.objects.create(username=username,
                                              first_name=first_name,
                                              last_name=last_name,
                                              email=email,
                                              password=password,
                                              is_staff=is_staff)

                newRUser = ReviewUser.objects.create(djangoUser=newUser,
                                                     isStaff=is_staff)
                print User.objects.filter(username=username).count()

                try:
                    newUser.save()
                    newRUser.save()
                except Exception as r:
                    print r.args
                    context['error'] = "Opps, Something went wrong."
                    return render(request, 'admin/userCreate.html', context)

                context['users'] = User.objects.all()
                return render(request, 'admin/userList.html', context)
            except Exception as ValidationError:
                print ValidationError.args

    context['form'] = form
    return render(request, 'admin/userCreate.html', context)


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def validateCourse(request):
    """
    validateCourse validates the data from the course creation template
    If the course is valid then it will create a new object.
    The user must be a staff member to use this view.

    Parameters:
    request (HttpRequest) -- request from the user to create a new course

    Returns:
    HttpResponse redirecting the user to the courseList page or back
    to the course creation page to fix any errors.
    """

    form = None
    context = {}

    if request.method == "POST":
        # grab the form from the template
        form = CourseCreationForm(request.POST)
        if form.is_valid():
            try:
                # grab the cleaned data from the form and try
                # creating a new course object
                course_code = form.cleaned_data['course_code']
                course_name = form.cleaned_data['course_name']
                newCourse = Course.objects.reate(course_code=course_code,
                                                 course_name=course_name)
                try:
                    newCourse.save()
                except:
                    return render(request, '/admin/courseCreate.html', context)

                context['courses'] = Course.objects.all()
                return render(request, 'admin/courseList.html', context)

            except Exception as ValidationError:
                print ValidationError.args

    context['form'] = form
    return render(request, '/admin/courseCreate.html', context)

@login_required(login_url='/review/login_redirect/')
def student_homepage(request):
    """
    Displays all critical information for the current user, including upcoming assignments
    and tasks.

    Arguments:
        request (HttpRequest) -- the http request asking for the homepage.

    Returns:
        A HttpResponse object which is used to render the homepage.
    """
    context = {}
    try:
        U = User.objects.get(id=request.user.id)
        context['user'] = U
        context['open_assignments'] = get_open_assignments(U)
        # For the course template which we inherit from
        context['courses'] = U.reviewuser.courses.all()
        context['form'] = annotationForm()
    except User.DoesNotExist as err:
        print err.args
        return error_page(request, "User does not exist")

    return render(request, 'student_homepage.html', context)

def get_open_assignments(user):
    ''' Returns the list of currently open assignments for the current user

    Here open assignment means that a student is able to make a submission
    for the assignment at the time this method is called. I.e., submissions
    are open and the due date has not passed yet.

    Arguments:
        user (User) -- the user whose open assignments we want to retrieve.

    Returns:
        A list whose entries are a tuple (Course, Assignment)
    '''

    timenow = timezone.now()
    openAsmts = []
    courses = user.reviewuser.courses.all()

    for course in courses:
        # Get assignments in the course
        assignments = Assignment.objects.filter(course_code__course_code=course.course_code)
        for assignment in assignments:
            if(can_submit(assignment)):
                openAsmts.append((course, assignment))

    return openAsmts


def error_page(request, message):
    """Display an error page with Http status 404.

    Arguments:
        request (HttpRequest) -- the request which provoked the error.
        message (String) -- message to display on the 404 page.

    Returns:
        HttpResponse object to display error page.
    """
    context = {'errorMessage': message}
    return render(request, 'error.html', context, status=404)

def reviews_remaining(user, asmtReview):
    """Get the number of reviews this user still has to do for asmt.

    Attributes:
        user (ReviewUser)
        asmtReview (AssignmentReview)
    """

@login_required(login_url='/review/login_redirect/')
def assignment_page(request, course_code, asmt):
    '''Displays the data (due date, review open date etc.) for a specific assignment.

    Arguments:
        request (HttpRequest) -- the HTTP request asking to view the assignment.
        course_code (Course.course_code) -- the course code of the course to which
                                            the assignment we want to display belongs.
        asmt (String) -- the name of the assignment we want to display.

    Returns:
        A HttpResponse object which is used to render the webpage.
    '''

    context = {}

    try:
        # Assingment submission related stuff 
        U = User.objects.get(id=request.user.id)
        reviewUser = U.reviewuser
        courseList = U.reviewuser.courses.all()
        courseCode = course_code.encode('ascii', 'ignore')
        course = Course.objects.get(course_code=courseCode)
        asmtName = asmt.encode('ascii', 'ignore')
        assignment = Assignment.objects.get(name=asmtName)
        submissions = AssignmentSubmission.objects.filter(submission_for=assignment, by=reviewUser)

        # Get the reviews this user has been assigned to complete.
        review = AssignmentReview.objects.filter(assignment=assignment, by=reviewUser)
        if(len(review) > 1):
            raise Exception
        if(review):
            review = review[0]
            submissionsToReview = review.submissions.all()
            context['submissionsToReview'] = submissionsToReview
            context['actualNumReviews'] = len(submissionsToReview)
            print submissionsToReview

            # Find out how many reviews user has remaining.
            context['numRemaining'] = AssignmentReview.numReviewsRemaining(review)

        context['user'] = U
        context['course'] = course
        context['asmt'] = assignment
        context['courses'] = courseList
        context['canSubmit'] = can_submit(assignment)
        context['submissions'] = submissions
        context['canReview'] = can_review(assignment)
        
    except User.DoesNotExist:
        print("User doesn't exist!")
        return error_page(request, 'User does not exist!')

    except Assignment.DoesNotExist:
        msg = "Assignment %s does not exist" %asmtName
        return error_page(request, msg)

    except Course.DoesNotExist:
        msg = "Course %s does not exist" %courseCode
        return error_page(request, msg)

    return render(request, 'assignment_page.html', context)


def can_submit(asmt):
    '''Check whether a student can make a submission to an assignment.

    Checks whether asmt is open for submission; i.e., determine whether or not
    submissions have opened, and whether the due date has passed.

    Arguments:
        asmt (Assignment) -- the assignment for which we want to check whether
        whether or not submission are open. 

    Returns:
        True if allowed to submit asmt now, False otherwise
    '''

    now = timezone.now()
    return now < asmt.submission_close_date and now > asmt.submission_open_date

def can_review(asmt):
    '''Checks whether a student can review other students' submissions. 

    Checks whether an assignment is open for review; i.e., determine whether or not
    reviews have opened and are not yet closed. 

    Arguments:
        asmt (Assignment) -- the assignment we want to check to see if reviews are open.

    Returns:
        True if user can review submissions now, False otherwise.
    '''

    now = timezone.now()
    return now < asmt.review_close_date and now > asmt.review_open_date

def user_can_submit(user, asmt):
    """Return true if this user has not yet made a submission for this asmt or
       if multiple submission are allowed.

    Not to be confused with can_submit, which only checks that the the current
    time is between submission open and close dates.

    Arguments:
        user (ReviewUser) -- we check if user has already submitted.
        asmt (Assignment) -- the assignment for which we want to make the check.

    Returns:
        True if the user can make a submission, i.e., if they have not yet
        made a submission, or if multiple submissions are allowed. Return
        False otherwise.
    """

    # multiple submissions allowed
    if(asmt.multiple_submissions):
        return True
    # user has never submitted anything for asmt
    elif(not AssignmentSubmission.objects.filter(by=user, submission_for=asmt)):
        return True
    else:
        return False

@login_required(login_url='/review/login_redirect/')
def submit_assignment(request, course_code, asmt):
    """Make a submission for an assignment.

    When the user enters the address of their reposistory (e.g., on github)
    into the submission page, this method is called to clone the contents of the
    given repository and populate the database with an AssignmentSubmission and
    SourceFolder and SourceFile objects. If submissions are closed and the user
    somehow landed on the submission URL, displays a page saying that submissions
    are not open.

    Arguments:
        request (HttpRequest) -- the HTTP request object asking to make a submission.
        course_code (String) -- the course code of the course to which
                                the assignment belongs.
        asmt (Assignment) -- the assignment for which the student wants to submit.

    Returns:
        A HttpReponse object which renders a confirmation page if the submission
        is successful (the given repository exists, cloning succeeded), or which
        re-renders the submission page with appropriate error messages
        (e.g., URL entered does not exist) if the submission is unsuccessful.

    TODO - handle multiple submission and single-submission assignments
           differently
    """
    # Duplicated code... not good.
    context = {}
    U = User.objects.get(id=request.user.id)
    courseList = U.reviewuser.courses.all()
    courseCode = course_code.encode('ascii', 'ignore')
    course = Course.objects.get(course_code=courseCode)
    asmtName = asmt.encode('ascii', 'ignore')
    assignment = Assignment.objects.get(name=asmtName)
    submissions = AssignmentSubmission.objects.filter(by=U.reviewuser, submission_for=assignment)

    if request.method == 'POST':
        form = AssignmentSubmissionForm(request.POST)
        if form.is_valid():
            # form.save(commit=True)
            repo = request.POST['submission_repository']
            # Create AssignmentSubmission object
            try:
                sub = AssignmentSubmission.objects.create(by=U.reviewuser, submission_repository=repo,
                                                    submission_for=assignment)
                sub.save()
                # Populate databse.
                relDir = os.path.join(courseCode, asmtName)
                populate_db(sub, relDir)
                # User will be shown confirmation.
                template = 'submission_confirmation.html'

            except GitCommandError as giterr:
                print giterr.args
                sub.delete()
                context['errMsg'] = "Something wrong with the repository URL."
                template = 'assignment_submission.html'

        else:
            print form.errors
            context['errMsg'] = "Something wrong with the values you entered; did you enter a blank URL?"
            template = 'assignment_submission.html'

    else:  # not POST; show the submission page, if assignment submission are open.
        form = AssignmentSubmissionForm()
        if(not can_submit(assignment)):
            template = 'cannot_submit.html'
            context['errorMsg'] = 'Submissions are closed'
        elif(not user_can_submit(U.reviewuser, assignment)):
            template = 'cannot_submit.html'
            context['errorMsg'] = 'You have already submitted.'
        else:
            template = 'assignment_submission.html'

    context['form'] = form
    context['course'] = course
    context['asmt'] = assignment
    context['courses'] = courseList
    context['submissions'] = submissions

    return render(request, template, context)


@login_required(login_url='/review/login_redirect')
def grabFileData(request, submissionUuid, file_uuid):
    """
    Refactored from reviewFile so cut down on code repetition.
    Grabs a dictionary containng all the file information.

    Parameters:
    submission_uuid (string) - identifier for the submission
    file_uuid (string) - identifier for the file

    Returns:
    type
    """
    context = {}
    uuid = submissionUuid
    try:
        currentUser = User.objects.get(id=request.session['_auth_user_id'])
        print currentUser
        file = SourceFile.objects.get(file_uuid=file_uuid)
        print 'get file'
        code = highlight(file.content, guess_lexer(file.content),
                         HtmlFormatter(linenos="table"))
        # print code
        folders = []

        # grab submission and all the associated files and folders

        sub = AssignmentSubmission.objects.get(submission_uuid=uuid)
        for f in sub.root_folder.files.all():
            folders.append(f)
        for f in sub.root_folder.folders.all():
            folders.append(f)
            for s in f.files.all():
                folders.append(s)

        # get root folder
        iter = file.folder
        while iter.parent is not None:
            iter = iter.parent
        # get owner id
        owner = AssignmentSubmission.objects.get(root_folder=iter).by

        # get all annotations for the current file
        # if user is the owner of the files or super user get all annotations
        if currentUser.is_staff or currentUser == owner:
            annotations = SourceAnnotation.objects.filter(source=file)
        else:
            annotations = SourceAnnotation.objects.filter(source=file, user=currentUser.reviewuser)

        annotationRanges = []
        aDict = []

        # get all the ranges for the annotations
        for a in annotations:
            annotationRanges.append(SourceAnnotationRange.objects.get(range_annotation=a))
            aDict.append(a)

        # sort the annotations by starting line
        annotationRanges.sort(key=lambda x: x.start)
        sortedAnnotations = []
        # grab the annotations again based on the sorted order
        for a in annotationRanges:
            sortedAnnotations.append(a.range_annotation)

        context['annotations'] = zip(aDict, annotationRanges)
        context['sub'] = submissionUuid
        context['uuid'] = file_uuid
        context['files'] = folders
        context['code'] = code
        context['file'] = file
        return context
    except AssignmentSubmission.DoesNotExist:
        error_page(request, "Submission does not exit")


@login_required(login_url='/review/login_redirect/')
def createAnnotation(request, submission_uuid, file_uuid):
    """
    Creates an annotation form the currently opened file.
    If it succesfully creates an annotation then the user is returned the current file.

    Parameters:
    submission_uuid (string) -- the uuid of the current submission
    file_uuid (string) -- the uuid of the current file

    Returns:
    returns
    """

    context = {}
    form = None
    rangeForm = None

    try:
        # print request
        # Get the current user and form data
        currentUser = User.objects.get(id=request.session['_auth_user_id'])
        form = annotationForm(request.GET)
        rangeForm = annotationRangeForm(request.GET)
        
        text = form['text'].value()
        start = rangeForm['start'].value()
        end = 0
        # end = rangeForm['end'].value()

        if form.is_valid() and rangeForm.is_valid():

            file = SourceFile.objects.get(file_uuid=file_uuid)
            lineCount = 0
            with open(file.file.path) as f:
                lineCount = sum(1 for _ in f)

            # start is actually a unicode object
            if int(start) > lineCount or int(start) <= 0:
                print "Excepting"
                raise LineException()
            # Create and try saving the new annotation and range
            newAnnotation = SourceAnnotation.objects.create(user=currentUser.reviewuser,
                                                            source=file,
                                                            text=text,
                                                            quote=text)
            # Get the submission
            uuid = submission_uuid.encode('ascii', 'ignore')
            # TODO this could possibly break depending on whether Tom is using this 
            # for help centre or not. We just need to check whether or not this 
            # submission is associated with an assignment.

            sub = AssignmentSubmission.objects.get(submission_uuid=uuid)
            newAnnotation.submission=sub
            newAnnotation.save()

            newRange = SourceAnnotationRange.objects.create(range_annotation=newAnnotation,
                                                            start=start,
                                                            end=end,
                                                            startOffset=start,
                                                            endOffset=end)

            newRange.save()
            # print newAnnotation, newRange
            print newAnnotation, newRange
            try:
                p = Post.objects.get(post_uuid=submission_uuid)
                print p
                return HttpResponseRedirect('/help/file/' + submission_uuid +
                                    '/' + file_uuid + '/')
            except Post.DoesNotExist:
                print "This is a assignment submission"
            return HttpResponseRedirect('/review/file/' + submission_uuid + '/' + file_uuid + '/')

    except User.DoesNotExist:
        print "This user doesn't exist! %r" % currentUser
        return error_page(request, "This user does not exist")
    except SourceFile.DoesNotExist:
        return error_page(request, "This file does not exist")
    except LineException:
        errorMessage = "Please enter a line number between 1 and %s" % lineCount
        context['rangeform'] = rangeForm
        rangeForm._errors['start'] = ErrorList([u"%s" % errorMessage])
    context = grabFileData(request, submission_uuid, file_uuid)
    context['form'] = form
    context['rangeform'] = rangeForm
    return render(request, 'review.html', context)


@login_required(login_url='/review/login_redirect/')
def grabFile(request):
    """
    this just grabs the file, pygmetizes it and returns it in,
    this gets sent to the ajax request

    This was used in the Ajax version of this application but
    it isn't currently used.
    """
    # print request.session['_auth_user_id']
    # # get current user
    # currentUser = User.objects.get(id=request.session['_auth_user_id'])
    # print currentUser
    # if request.is_ajax():
    #     try:
    #         toGrab = request.GET['uuid']
    #         path = SourceFile.objects.get(file_uuid=toGrab)
    #         # get root folder
    #         iter = path.folder
    #         while iter.parent is not None:
    #             iter = iter.parent
    #         # get owner id
    #         owner = AssignmentSubmission.objects.get(root_folder=iter).by
    #         # formatted = path.content
    #         formatted = highlight(path.content, guess_lexer(path.content),
    #                               HtmlFormatter(linenos="table", style="friendly"))

    #         # get all annotations for the current file
    #         # if user is the owner of the files or super user get all annotations
    #         if currentUser.is_staff or currentUser == owner:
    #             annotations = SourceAnnotation.objects.filter(source=path)
    #         else:
    #             annotations = Sou
    #             rceAnnotation.objects.filter(source=path, user=currentUser.reviewuser)

    #         annotationRanges = []
    #         aDict = []

    #         for a in annotations:
    #             annotationRanges.append(model_to_dict(SourceAnnotationRange.objects.get(range_annotation=a)))
    #             aDict.append(model_to_dict(a))

    #         # create the array to return
    #         ret = []
    #         ret.append(formatted)
    #         # zip up the two annotation lists so they can be called one after each other
    #         ret.append(zip(aDict, annotationRanges))
    #         # send the formatted file and the current annotations to the ajax call
    #         return HttpResponse(json.dumps(ret))
    #     except SourceFile.doesNotExist:
    #         print "Source file doesn't not exist"
    #         raise Http404

# This is just a test view for uploading files, will be deleted
def upload(request):
    """
    Test view for uploading files, not needed in the final version
    """
    # print "upload"
    # if request.method == "POST":
    #     form = uploadFile(request.POST, request.FILES)
    #     if form.is_valid():
    #         print "valid"
    #         form.save()
    #         return HttpResponse("Upload")
    # else:
    #     return HttpResponse("Fail")


@login_required(login_url='/review/login_redirect/')
def reviewFile(request, submissionUuid, file_uuid):
    """
    Grabs all the files for the current submission, but it also
    grabs and pygmentizes the current file and displays it to the user.

    Parameters:
    submissionUuid (string) - submission identifer for the current sub.
    file_uuid (String) -- file identifier

    Returns:
    HttpReponse redirecting the user to the review.html template
    showing the selected file or else redirects to a 404.
    """

    uuid = submissionUuid.encode('ascii', 'ignore')
    file_uuid = file_uuid.encode('ascii', 'ignore')
    context = {}
    currentUser = User.objects.get(id=request.session['_auth_user_id'])
    print currentUser

    try:

        # create the forms for annotation creation
        form = annotationForm()
        rangeForm = annotationRangeForm()

        # grab dictionary contatining all the pertinant information
        context = grabFileData(request, uuid, file_uuid)
        context['form'] = form
        context['rangeform'] = rangeForm
        return render(request, 'review.html', context)

    except AssignmentSubmission.DoesNotExist:
        raise Http404


@login_required(login_url='/review/login_redirect/')
def review(request, submissionUuid, **kwargs):
    """
    Grabs all the files for the current submission, and shows them
    as a list to the user

    Parameters:
    submissionUuid (string) - submission identifer for the current sub.

    Returns:
    HttpReponse redirecting the user to the review.html template or else
    redirects to a 404.
    """
    uuid = submissionUuid.encode('ascii', 'ignore')
    context = {}

    print "normal review"
    try:
        file= None
        code = None
        # if 'uuid' in kwargs.keys():
        #     print "get file"

        #     file = SourceFile.objects.get(file_uuid=uuid)
        #     code = highlight(file.content, guess_lexer(file.content),
        #                      HtmlFormatter(linoes="table"))

        folders = []

        # grab the submission and the associated files and folders

        sub = AssignmentSubmission.objects.get(submission_uuid=uuid)
        for f in sub.root_folder.files.all():
            folders.append(f)
        for f in sub.root_folder.folders.all():
            folders.append(f)
            for s in f.files.all():
                folders.append(s)
        # root_files = sub.root_folder.files

        # return all the data for the submission to the context
        context['sub'] = submissionUuid
        # files = root_files.all()
        context['files'] = folders
        context['code'] = code
        # context['files'] = files
        # context['files'] = get_list(sub.root_folder, [])
        return render(request, 'review.html', context)

    except AssignmentSubmission.DoesNotExist:
        raise Http404

def get_list(root_folder, theList):
    """
    Gets all the folders and files underneath root_folder
    as a list of lists (of lists etc.)
    Format like this:
    [root_folder, Folder1, Folder2, [Folder1, sub-folder-of-folder1, file1..], [Folder2, ...]]

    :root_folder SourceFolder
    """

    theList.append(root_folder)

    # Files directly under root_folder
    files = root_folder.files.all()

    # Folders directly under root_folder
    folders = root_folder.folders.all()
    for folder in folders:
        theList.append(folder)

    for file in files:
        theList.append(file)

    # Now get everything underneath the folders in root_folder
    for folder in folders:
        theList.append(get_list(folder, []))

    return theList

@login_required
@user_passes_test(staffTest)
def assign_reviews(request, course_code, asmt):
    asmtName = asmt.encode('ascii', 'ignore')
    assignment = Assignment.objects.get(name=asmtName)
    courseCode = course_code.encode('ascii', 'ignore')
    course = Course.objects.get(course_code=courseCode)

    context = {}

    if request.method == 'POST':
        form = AllocateReviewsForm(request.POST)
        if form.is_valid():
            numReviews = form.cleaned_data['reviews_per_student']
            distribute_reviews(assignment, numReviews)
            print "Reviews assigned!"

            numAnnotations = form.cleaned_data['min_annotations']
            assignment.min_annotations = numAnnotations
            assignment.reviews_per_student = numReviews
            template = "confirm_reviews_assigned.html"
        else:
            print form.errors
    else:
        form = AllocateReviewsForm()
        template = "assign_reviews.html"
    
    context['form'] = form
    context['asmt'] = assignment
    context['course'] = course

    return render(request, template,  context)
