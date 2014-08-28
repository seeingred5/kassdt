from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect, Http404

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
import json

from pygments import *
from pygments.lexers import *
from pygments.formatters import *

from review.models import *

from helpers import staffTest

# imports the form for assignment creation
from forms import AssignmentForm, UserCreationForm, AssignmentSubmissionForm, uploadFile, annotationForm

from django.utils import timezone

from git_handler import *

import os
import os.path

# this is the basic index view, it required login before the user can do any
# as you can see at the moment this shows nothing other than a logout button
# as I haven't added any content to it yet
@login_required(login_url='/review/login_redirect/')
def index(request):
    context = {}

    # whatever stuff we're goign to show in the index page needs to
    # generated here
    U = User.objects.get(id=request.user.id)
    context['user'] = U
    if U.reviewuser.isStaff:
        try:
            courses = U.reviewuser.courses.all()
            context['courses'] = courses
            return render(request, 'sidebar.html', context)
        except Exception as UserExcept:
            print UserExcept.args
    else:  # user is student
        return student_homepage(request)

    return render(request, 'sidebar.html', context)


def loginUser(request):
    pass


# simply logs the user out
def logout(request):
    logout(request)
    return HttpResponse("logout")
    # return redirect('/review/')

# This will redirect the admin user to the admin panel.
# It will also list all the courses they're currently


@login_required(login_url='/review/login_redirect/')
# @user_passes_test(staffTest)
def coursePage(request, course_code):
    context = {}
    # get the current assignments for the subject, subject choosing
    # will be added later
    U = User.objects.get(id=request.user.id)
    context['user'] = U
    code = course_code.encode('ascii', 'ignore')
    c = Course.objects.get(course_code=code)
    assignments = c.assignments.all()
    context['assignments'] = assignments
    context['course'] = c
    try:
        print "Getting courses"
        courses = U.reviewuser.courses.all()
        context['courses'] = courses
        return render(request, 'course_page.html', context)
    except Exception as UserExcept:
        print UserExcept.args
        raise Http404

    return render(request, 'course_page.html', context)

# gets the course code for the current course being used and
# creates a form for creating a new assignment, redirects to the
# assignment create page


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def create_assignment(request, course_code):

    context = {}

    # grab course code from the url and convert to a string from unicode
    code = course_code.encode('ascii', 'ignore')
    # grab the course object for the course
    c = Course.objects.get(course_code=code)

    # generate form for new assignemnt, thing this will get changed
    # to a pre specified form rather than a generated form
    form = AssignmentForm()

    # add all the data to thte context dict
    context['form'] = form
    context['course'] = c

    return render(request, 'admin/new_assignment.html', context)

# course administration alternative instead of using the django backend


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
    context = {}
    courses = Course.objects.all()
    context['courses'] = courses

    return render(request, 'admin/courseList.html', context)


# user administration alternative instead of using the django backend

@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def userAdmin(request):
    context = {}
    users = User.objects.all()
    context['users'] = users

    return render(request, 'admin/userList.html', context)

# Validates the data from the assignment creation form.
# If the data is valid then it creates the assignment,
# otherwise the user is kicked back to the form to fix the data

@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def validateAssignment(request):
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

                # Just to check the code is working
                print "Creating assignment"
                course = Course.objects.get(id=request.POST['course_code'])
                name = form.cleaned_data['name']
                repository_format = form.cleaned_data['repository_format']
                first_display_date = form.cleaned_data['first_display_date']
                submission_open_date = form.cleaned_data['submission_open_date']
                submission_close_date = form.cleaned_data['submission_close_date']
                review_open_date = form.cleaned_data['review_open_date']
                review_close_date = form.cleaned_data['review_close_date']

                ass = Assignment.objects.create(course_code=course, name=name,
                                                repository_format=repository_format,
                                                first_display_date=first_display_date,
                                                submission_open_date=submission_open_date,
                                                submission_close_date=submission_close_date,
                                                review_open_date=review_open_date,
                                                review_close_date=review_close_date)
                ass.save()
            except Exception as AssError:
                # prints the exception
                print "DREADED EXCEPTION"
                print AssError.args
            return HttpResponseRedirect('/review/course_admin/')

    context['form'] = form
    context['course'] = Course.objects.get(id=request.POST['course_code'])

    return render(request, 'admin/new_assignment.html', context)

# validates the data for user createion, pretty much the same as the view above
# but for users.  Also creates a new review user for the user


@login_required(login_url='/review/login_redirect/')
@user_passes_test(staffTest)
def validateUser(request):
    form = None
    context = {}

    if request.method == "POST":
        form = UserCreationForm(request.POST)

        if form.is_valid():
            try:
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
                    context['error'] = "Errr Something went wrong, Tom fix this"
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
    form = None
    context = {}

    if request.method == "POST":
        form = CourseCreationForm(request.POST)

        if form.is_valid():
            try:
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
    context = {}
    U = User.objects.get(id=request.user.id)
    context['user'] = U
    context['open_assignments'] = get_open_assignments(U)
    # For the course template which we inherit from
    context['courses'] = U.reviewuser.courses.all()
    context['form'] = annotationForm()
    return render(request, 'student_homepage.html', context)

def get_open_assignments(user):
    '''
    :user User

    return List[(Course, Assignment)]
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

@login_required(login_url='/review/login_redirect/')
def assignment_page(request, course_code, asmt):
    '''
    :course_code Course.course_code
    :asmt Assignment
    '''
    context = {}

    U = User.objects.get(id=request.user.id)
    courseList = U.reviewuser.courses.all()
    courseCode = course_code.encode('ascii', 'ignore')
    course = Course.objects.get(course_code=courseCode)
    asmtName = asmt.encode('ascii', 'ignore')
    assignment = Assignment.objects.get(name=asmtName)

    context['user'] = U
    context['course'] = course
    context['asmt'] = assignment
    context['courses'] = courseList
    context['canSubmit'] = can_submit(assignment)

    return render(request, 'assignment_page.html', context)

def can_submit(asmt):
    '''
        :asmt Assignment

        Return True if allowed to submit asmt now
        False otherwise
    '''
    now = timezone.now()
    return now < asmt.submission_close_date and now > asmt.submission_open_date

@login_required(login_url='/review/login_redirect/')
def submit_assignment(request, course_code, asmt):
    """
    :request the HTTP request object
    :course_code String course code 
    :asmt Assignment the assignment for which we want to submit
    
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

    else: # not POST; show the submission page.
        form = AssignmentSubmissionForm()
        template = 'assignment_submission.html'

    context['form'] = form
    context['course'] = course
    context['asmt'] = assignment
    context['courses'] = courseList

    return render(request, template, context)

@login_required(login_url='/review/login_redirect/')
def create_annotation(request, course_code, asmt):
    """
    Creates an annotation for the user.  Needs to get most of its
    information from the http request sent by the AJAX function.
    Needs a post request to work.

    I'm going to assume that the add annotation is a form, so i'll
    use the django form methods for getting data

    At this point I'm just assuming this works but I can't test it
    """
    context = {}

    # I'm making the assumption that the form has fields for
    # the text, and both the starting and end ranges.
    form = annotationForm(request.POST)
    annotation = None
    annotation_range = None
    if request.method == 'POST' and form.is_valid():
        try:
            # get the user id and the source id
            U = User.objects.get(id=request.user.id)
            S = Source.objects.get(id=request.source.id)
            annotation_text = form.cleaned_data['annotation_text']
            start = form.cleaned_data['start']
            end = form.cleaned_data['end']
            annotation = SourceAnnotation.objects.create(
                user=U,
                source=s,
                text=annotation_text,
                quote=annotation_text[:30]+(annotation_text[30:] and '..')
            )
            annotation.save()
            print "annotation saved"
            annotation_range = SourceAnnotationRange.objects.create(
                annotation_range_annotation=annotation,
                start=start,
                end=end,
                # I'm not sure what they used offsets for but i'll make
                # them the sam as the start and the end
                startOffset=start,
                endoOffset=end
            )
            annotation_range.save()
            print "annotation_range saved"
        except Exception as e:
            print e.message

        # not sure what you'll want to return here because I don't know
        # the format of the template but i'll return the data as a json object
        # with the annotation data and the annotation_range data combined

        context = model_to_dict(annotation).items() + model_to_dict(annotation_range).items()

        print context
        # return a json file with the combied annotation and the annotation_range models
        return HttpResponse(json.dumps(context,
                                       cls=serializers.json.DjangoJSONEncoder))

@login_required(login_url='/review/login_redirect/')
def retrieve_submission(request, submission_uuid):
    """
    Retrieves a submission from the database and returns both it
    and all its annotations to a template
    """
    pass


@login_required(login_url='/review/login_redirect/')
def grabFile(request):
    """ 
    this just grabs the file, pygmetizes it and returns it in,
    this gets sent to the ajax request
    """
    print request.session['_auth_user_id']
    # get current user
    currentUser = User.objects.get(id=request.session['_auth_user_id'])
    print currentUser
    if request.is_ajax():
        try:
            toGrab = request.GET['uuid']
            path = SourceFile.objects.get(file_uuid=toGrab)
            # get root folder
            iter = path.folder
            while iter.parent is not None:
                iter = iter.parent
            # get owner id
            owner = AssignmentSubmission.objects.get(root_folder=iter).by
            # formatted = path.content
            formatted = highlight(path.content, guess_lexer(path.content),
                                  HtmlFormatter(linenos="table"))

            # get all annotations for the current file
            # if user is the owner of the files or super user get all annotations
            if currentUser.is_staff or currentUser == owner:
                annotations = SourceAnnotation.objects.filter(source=path)
            else:
                annotations = Sou
                rceAnnotation.objects.filter(source=path, user=currentUser.reviewuser)
            
            annotationRanges = []
            aDict = [] 

            for a in annotations:
                annotationRanges.append(model_to_dict(SourceAnnotationRange.objects.get(range_annotation=a)))
                aDict.append(model_to_dict(a))

            # create the array to return
            ret = []
            ret.append(formatted)
            # zip up the two annotation lists so they can be called one after each other
            ret.append(zip(aDict, annotationRanges))
            # send the formatted file and the current annotations to the ajax call
            return HttpResponse(json.dumps(ret))
        except SourceFile.doesNotExist:
            print "Source file doesn't not exist"
            return Http404()


def upload(request):
    """
    Test view for uploading files
    """
    print "upload"
    if request.method == "POST":
        form = uploadFile(request.POST, request.FILES)
        if form.is_valid():
            print "valid"
            form.save()
            return HttpResponse("Upload")
    else:
        return HttpResponse("Fail")

# to be deleted #


def annotation_test(request):
    print request.method
    data = None
    if request.method == 'GET' and request.is_ajax():
        print "ajax"
        u = open('/home/tom/urls.py')
        print "opent"
        data = highlight(u.read(), PythonLexer(), HtmlFormatter(linenos=True))
        return HttpResponse(data)

    return HttpResponse("nope")


def review(request, submissionUuid):
    """
    
    """
    uuid = submissionUuid.encode('ascii', 'ignore')
    context = {}
    print uuid

    try:
        folders = []
        sub = AssignmentSubmission.objects.get(submission_uuid=uuid)
        for f in sub.root_folder.files.all():
            folders.append(f)
        for f in sub.root_folder.folders.all():
            folders.append(f)
            for s in f.files.all():
                folders.append(s)
        # root_files = sub.root_folder.files

        for f in folders:
            print f

        form = annotationForm()
        context['form'] = form
        # files = root_files.all()
        context['files'] = folders
        # context['files'] = files
        # context['files'] = get_list(sub.root_folder, [])
        return render(request, 'review.html', context)
        
    except AssignmentSubmission.DoesNotExist:
        return Http404()

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
