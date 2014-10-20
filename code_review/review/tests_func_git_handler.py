"""
Functional tests for submitting assignments
"""

from django.test import TestCase

from django.contrib.auth.models import User, Group
from django.db.models.base import ObjectDoesNotExist
from review.models import *
from review.helpers import *

from django.test import LiveServerTestCase
from selenium.webdriver.chrome import webdriver
from selenium.common.exceptions import NoSuchElementException

from review.tests import *
from time import sleep

class AssignmentSubmissionTest(LiveServerTestCase):
    server_url = 'http://localhost:8000'
    fixtures = ['assign_reviews']
        
    publicRepo = "https://github.com/avadendas/public_test_repo.git"
    sshRepo = "https://github.com/avadendas/private_test_repo.git"
    privateRepo = "https://kassdt@bitbucket.org/kassdt/private_test_repo.git"

    @classmethod
    def setUpClass(cls):
        cls.selenium = webdriver.WebDriver()
        super(AssignmentSubmissionTest, cls).setUpClass()
        cls.selenium.maximize_window()
        
        print ReviewUser.objects.all()
        print User.objects.all()
        
    @classmethod
    def tearDownClass(cls):
        cls.selenium.quit()
        super(AssignmentSubmissionTest, cls).tearDownClass()
   
    def setUp(self):
        self.student = User.objects.get(pk=86)
        self.admin = User.objects.get(username='tom')
        self.studentRevUser = ReviewUser.objects.get(djangoUser=self.student)

    def login(self, username, password):
        self.selenium.get("%s" % self.server_url)
        username_input = self.selenium.find_element_by_id("id_username")
        password_input = self.selenium.find_element_by_id("id_password")
        username_input.send_keys(username)
        password_input.send_keys(password)
        self.selenium.find_element_by_xpath("//input[@value='Login']").click()
   
    @classmethod
    def loginStudent(self):
        self.login('naoise', 'naoise')

    @classmethod
    def partialLink(self, text):
        return self.selenium.find_element_by_partial_link_text(text)
    
    @classmethod
    def xpath(self,text):
        return self.selenium.find_element_by_xpath(text)
    
    @classmethod
    def assignmentPage(self, course, asmt):
        '''Go to the assignment page of asmt'''
        '''Submit to a single-submission only assignment and attempt to resubmit'''
        self.partialLink("Courses").click()
        self.partialLink(course).click()
        path = "//a[@href='%s/']" %(asmt)
        self.xpath(path).click()
    
    @classmethod 
    def byId(self, text):
        return self.selenium.find_element_by_id(text)
    
    @classmethod 
    def repoUrl(self, url):
        '''Go from assignment page to submitting assignment'''
        self.submit()
        self.byId("id_submission_repository").send_keys(url)
        self.byId("id_submit").click()

    @classmethod 
    def submit(self):
        '''@pre we are on the assignment page'''
        #self.xpath("//div[@class='panel-footer']/form/input").submit()
        self.byId("id_submissionPage").click()

    @classmethod 
    def confirmationPage(self):
        # Check redirected to confirmation page 
        self.assertTrue(self.byId("//h1[text() = 'Submission Confirmed']"))
    
    @classmethod
    def get_latest(self, user, asmt):
        return AssignmentSubmission.objects.filter(by=user, submission_for=asmt).latest()

    """
    def test_00_submit_public(self):
        '''Believe this has already been done by Kieran in tests:MySeleniumTests.'''
        pass
    """
    
    def test_01_submit_single(self):
        self.login('naoise', 'naoise')
        # How many submissions are there already?
        course = Course.objects.get(course_code="ABCD1234")
        asmt = Assignment.objects.get(course_code=course, name='SingleSubmit')
        oldSubs = AssignmentSubmission.objects.filter(submission_for=asmt, by=self.studentRevUser)
        
        self.assignmentPage("ABCD1234", 'SingleSubmit')
        
        self.repoUrl(self.publicRepo)
        # Sleep for a bit so it actually gets submitted. 
        sleep(10)
        # Check assignment has been created 
        newSubs = AssignmentSubmission.objects.filter(submission_for=asmt, by=self.studentRevUser)
        #self.assertEqual(len(oldSubs)+1, len(newSubs))
        #latest = get_latest(self.studentRevUser, asmt)

        # Try to submit again.
        self.repoUrl(self.publicRepo)

    """
    def test_submission_not_open(self):
        pass

    def test_submission_closed(self):
        pass

    def test_multiple_submit(self):
       pass

    def test_bad_transport(self):
        '''Test non-existent protocol httomps://'''
        pass

    def test_ssh(self):
        '''Test private repo submission via ssh'''
        pass

    def test_password_auth(self):
        '''Test submitting private repo with username and password'''
        pass

    def test_bad_password(self):
        '''Test submitting private repo with incorrect password'''
        pass

    def test_junk(self):
        '''Test submitting junk in the URL field, like aldkjadlkfj'''
        pass

    def test_blank(self):
        '''Submit blank URL'''
        pass
    """
