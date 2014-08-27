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

from review.models import *

from helpers import staffTest

# imports the form for assignment creation
from forms import AssignmentForm, UserCreationForm, AssignmentSubmissionForm

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

            
    
