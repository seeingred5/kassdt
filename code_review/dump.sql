-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: code_review
-- ------------------------------------------------------
-- Server version	5.5.37-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'staff'),(2,'student');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_5f412f9a` (`group_id`),
  KEY `auth_group_permissions_83d7f98b` (`permission_id`),
  CONSTRAINT `group_id_refs_id_f4b32aac` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `permission_id_refs_id_6ba0f519` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,1,15),(16,1,16),(17,1,17),(18,1,18),(19,1,19),(20,1,20),(21,1,21),(22,1,22),(23,1,23),(24,1,24),(25,1,25),(26,1,26),(27,1,27),(28,1,28),(29,1,29),(30,1,30),(31,1,31),(32,1,32),(33,1,33),(34,1,34),(35,1,35),(36,1,36),(37,1,37),(38,1,38),(39,1,39),(40,1,40),(41,1,41),(42,1,42),(43,1,43),(44,1,44),(45,1,45),(46,1,46),(47,1,47),(48,1,48),(49,1,49),(50,1,50),(51,1,51),(52,1,52),(53,1,53),(54,1,54),(55,2,16),(56,2,17),(57,2,18),(58,2,19),(59,2,20),(60,2,21),(61,2,28),(62,2,29),(63,2,30),(64,2,31),(65,2,32),(66,2,33),(67,2,34),(68,2,35),(69,2,36),(70,2,37),(71,2,38),(72,2,39),(73,2,43),(74,2,44),(75,2,45),(76,2,46),(77,2,47),(78,2,48),(79,2,49),(80,2,50),(81,2,51),(82,2,52),(83,2,53),(84,2,54);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_37ef4eb4` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_d043b34a` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can add permission',2,'add_permission'),(5,'Can change permission',2,'change_permission'),(6,'Can delete permission',2,'delete_permission'),(7,'Can add group',3,'add_group'),(8,'Can change group',3,'change_group'),(9,'Can delete group',3,'delete_group'),(10,'Can add user',4,'add_user'),(11,'Can change user',4,'change_user'),(12,'Can delete user',4,'delete_user'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session'),(19,'Can add migration history',7,'add_migrationhistory'),(20,'Can change migration history',7,'change_migrationhistory'),(21,'Can delete migration history',7,'delete_migrationhistory'),(22,'Can add review user',8,'add_reviewuser'),(23,'Can change review user',8,'change_reviewuser'),(24,'Can delete review user',8,'delete_reviewuser'),(25,'Can add course',9,'add_course'),(26,'Can change course',9,'change_course'),(27,'Can delete course',9,'delete_course'),(28,'Can add source folder',10,'add_sourcefolder'),(29,'Can change source folder',10,'change_sourcefolder'),(30,'Can delete source folder',10,'delete_sourcefolder'),(31,'Can add source file',11,'add_sourcefile'),(32,'Can change source file',11,'change_sourcefile'),(33,'Can delete source file',11,'delete_sourcefile'),(34,'Can add submission test results',12,'add_submissiontestresults'),(35,'Can change submission test results',12,'change_submissiontestresults'),(36,'Can delete submission test results',12,'delete_submissiontestresults'),(37,'Can add submission test',13,'add_submissiontest'),(38,'Can change submission test',13,'change_submissiontest'),(39,'Can delete submission test',13,'delete_submissiontest'),(40,'Can add assignment',14,'add_assignment'),(41,'Can change assignment',14,'change_assignment'),(42,'Can delete assignment',14,'delete_assignment'),(43,'Can add assignment submission',15,'add_assignmentsubmission'),(44,'Can change assignment submission',15,'change_assignmentsubmission'),(45,'Can delete assignment submission',15,'delete_assignmentsubmission'),(46,'Can add source annotation',16,'add_sourceannotation'),(47,'Can change source annotation',16,'change_sourceannotation'),(48,'Can delete source annotation',16,'delete_sourceannotation'),(49,'Can add source annotation range',17,'add_sourceannotationrange'),(50,'Can change source annotation range',17,'change_sourceannotationrange'),(51,'Can delete source annotation range',17,'delete_sourceannotationrange'),(52,'Can add source annotation tag',18,'add_sourceannotationtag'),(53,'Can change source annotation tag',18,'change_sourceannotationtag'),(54,'Can delete source annotation tag',18,'delete_sourceannotationtag');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'bcrypt_sha256$$2a$12$Z42bKp5itRLUfUvAiOc2OeJkYm7/hBKetLDmTUucNvEDg03GDerqa','2014-08-11 03:41:24',1,'admin','','','',1,1,'2014-08-09 12:38:53'),(2,'bcrypt_sha256$$2a$12$NtHocstPzDmz8LIIpzuaBeywRhj3v5tBdYMIAQnONRECY7ukH0yZK','2014-08-10 10:45:45',0,'tom','Tom','Midson','',0,1,'2014-08-09 12:44:45');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_6340c63c` (`user_id`),
  KEY `auth_user_groups_5f412f9a` (`group_id`),
  CONSTRAINT `user_id_refs_id_40c41112` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `group_id_refs_id_274b862c` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (1,2,2);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_6340c63c` (`user_id`),
  KEY `auth_user_user_permissions_83d7f98b` (`permission_id`),
  CONSTRAINT `user_id_refs_id_4dc23c39` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `permission_id_refs_id_35d9ac25` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_6340c63c` (`user_id`),
  KEY `django_admin_log_37ef4eb4` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_93d2d1f8` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `user_id_refs_id_c0d12874` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2014-08-09 12:45:38',1,3,'1','staff',1,''),(2,'2014-08-09 12:46:21',1,3,'2','student',1,''),(3,'2014-08-09 12:46:36',1,4,'2','tom',1,''),(4,'2014-08-10 02:44:38',1,14,'1','(cfafd9e3-8555-416e-a42e-583b9a405d61)Learning 1',1,''),(5,'2014-08-10 10:24:17',1,14,'3','(dd48420a-cfc9-4007-9c3e-9ae68552c488)fdsa',3,''),(6,'2014-08-10 10:24:17',1,14,'2','(2fbf28d6-c2eb-43ad-9115-0fe053d02f37)fdsa',3,'');
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'log entry','admin','logentry'),(2,'permission','auth','permission'),(3,'group','auth','group'),(4,'user','auth','user'),(5,'content type','contenttypes','contenttype'),(6,'session','sessions','session'),(7,'migration history','south','migrationhistory'),(8,'review user','review','reviewuser'),(9,'course','review','course'),(10,'source folder','review','sourcefolder'),(11,'source file','review','sourcefile'),(12,'submission test results','review','submissiontestresults'),(13,'submission test','review','submissiontest'),(14,'assignment','review','assignment'),(15,'assignment submission','review','assignmentsubmission'),(16,'source annotation','review','sourceannotation'),(17,'source annotation range','review','sourceannotationrange'),(18,'source annotation tag','review','sourceannotationtag');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_b7b81f0c` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('19ainqebemzqt2led6o8413rphwu7hsr','MzI0OGYzZGYxMDA1MGRmY2M5YjM5MTE5ZjJhYjY2MTVmMzQwYTY5MDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=','2014-08-24 02:43:03'),('6e674mu8w0mtr20hfouss75leyzy819n','YWQ4MWU2MDRjZmJhYWQ3NDZjOTZkYmFiM2QyMWIxMjkwOTlmNjA5MTp7fQ==','2014-08-24 10:07:30'),('ein0uddfyvwxcwl1ygr32hvkqbna1hjm','YWQ4MWU2MDRjZmJhYWQ3NDZjOTZkYmFiM2QyMWIxMjkwOTlmNjA5MTp7fQ==','2014-08-23 12:58:42'),('n7k98336mti0p2eg30d4mqmb6t8u53vu','MzI0OGYzZGYxMDA1MGRmY2M5YjM5MTE5ZjJhYjY2MTVmMzQwYTY5MDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=','2014-08-24 02:00:02'),('rl9oe41zxneska4cqnsz9fes8q3e96od','MzI0OGYzZGYxMDA1MGRmY2M5YjM5MTE5ZjJhYjY2MTVmMzQwYTY5MDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=','2014-08-25 03:41:24');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_assignment`
--

DROP TABLE IF EXISTS `review_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assignment_uuid` varchar(36) NOT NULL,
  `name` longtext NOT NULL,
  `repository_format` longtext NOT NULL,
  `first_display_date` datetime NOT NULL,
  `submission_open_date` datetime NOT NULL,
  `submission_close_date` datetime NOT NULL,
  `review_open_date` datetime NOT NULL,
  `review_close_date` datetime NOT NULL,
  `course_code_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `review_assignment_f4b0fac7` (`course_code_id`),
  CONSTRAINT `course_code_id_refs_id_2bfd7468` FOREIGN KEY (`course_code_id`) REFERENCES `review_course` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_assignment`
--

LOCK TABLES `review_assignment` WRITE;
/*!40000 ALTER TABLE `review_assignment` DISABLE KEYS */;
INSERT INTO `review_assignment` VALUES (1,'cfafd9e3-8555-416e-a42e-583b9a405d61','Learning 1','https://www.source-hosting.com/{username}/ass1/ ','2014-08-10 02:43:57','2014-08-10 02:43:57','2014-08-10 12:44:34','2014-08-10 02:43:57','2014-08-10 12:44:36',1),(4,'bdf53f3e-b8df-4d28-bd36-93af08b22639','fdasasdfas','asdfasd','2014-08-19 18:30:00','2014-08-10 10:40:00','2014-08-27 11:00:00','2014-08-10 10:40:00','2014-08-27 02:00:00',1);
/*!40000 ALTER TABLE `review_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_assignmentsubmission`
--

DROP TABLE IF EXISTS `review_assignmentsubmission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_assignmentsubmission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `submission_uuid` varchar(36) NOT NULL,
  `submission_date` datetime NOT NULL,
  `by_id` int(11) NOT NULL,
  `submission_repository` longtext NOT NULL,
  `submission_for_id` int(11) NOT NULL,
  `error_occurred` tinyint(1) NOT NULL,
  `root_folder_id` int(11) DEFAULT NULL,
  `test_results_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `root_folder_id` (`root_folder_id`),
  UNIQUE KEY `test_results_id` (`test_results_id`),
  KEY `review_assignmentsubmission_e48e5091` (`by_id`),
  KEY `review_assignmentsubmission_e7178437` (`submission_for_id`),
  CONSTRAINT `submission_for_id_refs_id_8d20aaf0` FOREIGN KEY (`submission_for_id`) REFERENCES `review_assignment` (`id`),
  CONSTRAINT `root_folder_id_refs_id_55a751b9` FOREIGN KEY (`root_folder_id`) REFERENCES `review_sourcefolder` (`id`),
  CONSTRAINT `test_results_id_refs_id_ff4abb0b` FOREIGN KEY (`test_results_id`) REFERENCES `review_submissiontestresults` (`id`),
  CONSTRAINT `by_id_refs_id_a4fcd4d1` FOREIGN KEY (`by_id`) REFERENCES `review_reviewuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_assignmentsubmission`
--

LOCK TABLES `review_assignmentsubmission` WRITE;
/*!40000 ALTER TABLE `review_assignmentsubmission` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_assignmentsubmission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_course`
--

DROP TABLE IF EXISTS `review_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_uuid` varchar(36) NOT NULL,
  `course_code` varchar(10) NOT NULL,
  `course_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_course`
--

LOCK TABLES `review_course` WRITE;
/*!40000 ALTER TABLE `review_course` DISABLE KEYS */;
INSERT INTO `review_course` VALUES (1,'c0d0bf8a-b431-4c1a-9ace-2dfb4514e1b8','ABCD1234','Introduction to LearnIntro to learning'),(2,'ee80a762-96af-4033-804d-2249135220a3','AERO4200','Flight Mechanics & Avionics'),(3,'2d277953-f847-4fe9-8ae3-e3a2b8b10f75','COMP3301','Operating Systems Architecture'),(4,'4b0796e0-c07b-4365-9e88-a3ae21cda20b','COMP3506','Algorithms & Data Structures'),(5,'f5523d26-4cd3-496a-b442-3aa1e142e922','COMP3702','Artificial Intelligence'),(6,'a7c01423-6348-4eb3-a164-3eb72bbe6373','COMP4403','Compilers and Interpreters'),(7,'61b70fe7-5bee-496a-9f72-a6d832c0b060','COMP4500','Advanced Algorithms & Data Structures'),(8,'f1e09ee9-e5bf-49a1-8918-8db393134561','COMP4702','Machine Learning'),(9,'5cef10e9-ae92-4256-b9f7-1a243fa175a3','COMP6801','Computer Science Research Project'),(10,'fff2d4fd-8f3b-4a1a-b307-a6a741f7f559','COMP6803','Computer Science Research Project'),(11,'04fd1f7f-3afb-4f4a-b94e-4516d6f528ba','COMP6804','Computer Science Research Project'),(12,'da46ff03-a8ba-4bed-b6d2-6e126c5ffce1','COMP7308','Operating Systems Architecture'),(13,'56501d32-3677-4383-a0e3-dfced7d5a6c6','COMP7402','Compilers & Interpreters'),(14,'0601a3a2-a8e9-494e-8582-2cac931eef36','COMP7500','Advanced Algorithms & Data Structures'),(15,'7588446b-0c9d-4303-970e-1dedf29f5f65','COMP7505','Algorithms & Data Structures'),(16,'0ee54a91-b2f6-46d7-8947-b7451c3cfa80','COMP7702','Artificial Intelligence'),(17,'fd2158a9-15df-425f-a781-29ea3cd374bd','COMP7703','Machine Learning'),(18,'cc78cfe0-4d4f-4b33-b0eb-fffb0a1d891f','COMP7801','Computer Science Research Project'),(19,'560cb42b-12a7-4e16-bf4d-43b5ba205aad','COMP7802','Computer Science Research Project'),(20,'f87b4323-e86b-4249-9531-8374077baa86','COMP7840','Computer Science Research Project'),(21,'7d214426-9ea6-42ef-8c66-6a470d888cb8','COMP7860','Computer Science Research Project'),(22,'cc52fa95-299d-4a7c-a3a9-097aa5c4cb72','COMP7861','Computer Science Research Project'),(23,'c420384f-e7e9-4b06-bb60-5107e8dd5d90','COMP7862','Computer Science Research Project'),(24,'b6b14beb-b8f1-45b8-9d95-8fad0f4cf575','COMP7880','Computer Science Research Project'),(25,'2cdb9e0d-3a61-4d81-a9e6-135a8b24b506','COMP7881','Computer Science Research Project'),(26,'ae7e03f5-331b-4d76-b772-c2a7bb2d6f11','COMP7882','Computer Science Research Project'),(27,'b791aa0f-9c01-4a28-8ab1-b3bfd8d98f86','COMS3000','Information Security'),(28,'b0d5b0bb-b531-4a18-a2c7-50d610c39df8','COMS3200','Computer Networks I'),(29,'cbff2374-ed57-4935-bec0-84b1cf9e889a','COMS4103','Photonics'),(30,'f7292fb9-cd44-473b-9a73-4add20822ecc','COMS4104','Microwave Subsystems & Antennas'),(31,'b984a771-ecf1-4994-9ae8-d5718ac91188','COMS4105','Communication Systems'),(32,'ab685910-9c97-4932-8047-15524f59a622','COMS4200','Computer Networks II'),(33,'2c254ae3-672f-4b82-b5c4-be471c4658a7','COMS4507','Advanced Computer and Network Security'),(34,'0ae42139-e7fa-4ea2-a3b8-01b116532556','COMS7003','Information Security'),(35,'6858255e-0221-4eee-82d1-1797a9f58d08','COMS7104','Microwave Subsystems and Antennas'),(36,'3eeb1f78-8af3-4268-9727-01ceeac9df53','COMS7200','Computer Networks II	Moves to semester 2 from 2013.'),(37,'cad246b7-ff83-4488-b773-70b589a8f735','COMS7201','Computer Networks I	Moves to semester 1 from 2013.'),(38,'b812ced8-2d8d-42e7-ad4f-d5c25f03c8ed','COMS7305','Advanced Microwave Circuit Design'),(39,'957590f3-572a-456c-9d08-4f1405258fe2','COMS7306','Electromagnetic Design and Measurements in Microwaves and Photonics'),(40,'5bc6ea68-1925-40b1-a589-09a72d646796','COMS7307','Advanced Photonics'),(41,'9d5b8885-9a35-4c82-aef7-6a7a37fd6a69','COMS7308','Antenna Design'),(42,'c73735da-acd5-4b03-acda-93ca094484ca','COMS7309','Computational Techniques in Electromagnetics'),(43,'bfc42c3a-31e0-4165-a9fa-eb3e556b1d45','COMS7310','Radar and Electronic Warfare Fundamentals'),(44,'f9486af5-e083-4c89-9b88-55219748e61c','COMS7400','Photonics'),(45,'732ef465-7d61-4741-bb34-244e43c3a5ec','COMS7410','Communication Systems'),(46,'57798e66-89c2-4a18-8a2f-969df83dd5e9','COMS7507','Advanced Computer and Network Security'),(47,'7421665f-3b31-4e51-b646-c58e7c9b11bd','COSC2500','Numerical Methods in Computational Science'),(48,'cc363276-dbeb-4b79-b37d-e8808ab9de49','COSC3000','Visualization, Computer Graphics & Data Analysis'),(49,'cc01138b-fd2b-4e92-a15e-75c2687362ed','COSC3500','High-Performance Computing'),(50,'c3e94525-41de-4c07-921e-8f55afffeded','CSSE1001','Introduction to Software Engineering I'),(51,'44bd4863-77e7-40c0-b18b-bbeb363641c3','CSSE2002','Programming in the Large'),(52,'64d68a29-28e2-4c88-8917-0623aa239869','CSSE2010','Introduction to Computer Systems'),(53,'363cc6fe-0323-4fe5-ad25-35ffcef0ad65','CSSE2310','Computer Systems Principles and Programming'),(54,'346e126c-91ca-46f3-bd51-91355dec3c89','CSSE3002','The Software Process'),(55,'63557d6d-cf94-4efc-89bb-623365f7eb11','CSSE3005','Advanced Information Technology Project'),(56,'dc922a85-58a0-46c9-8be0-f6efa3788c87','CSSE3006','Special Projects in Computer Systems and Software Engineering'),(57,'7fa7f0e6-6d65-4bbf-b284-c87346f04ce4','CSSE3010','Embedded Systems Design & Interfacing'),(58,'3838fc2a-0122-4c35-b65e-3af928bd15d7','CSSE4004','Distributed Computing'),(59,'69d54858-4f75-41f9-a212-c7ab6f150055','CSSE4010','Digital System Design'),(60,'983989f4-47c8-4cd3-b800-6b54a75a6e39','CSSE4011','Advanced Embedded Systems'),(61,'71637208-dad0-4e31-8751-846d55d5cc29','CSSE4020','Wireless Sensor Networks'),(62,'7f77fbba-bd13-48dd-a2ac-8e4ae58c96cd','CSSE4603','Models of Software Systems'),(63,'c75672ae-5c07-4517-8e0a-6c5a6d7db623','CSSE7001','The Software Process'),(64,'164f8294-6d89-46c2-bc18-a686419a16bf','CSSE7014','Distributed Computing'),(65,'6ced6ab8-82c9-49f8-b243-383d1e364a62','CSSE7023','Advanced Software Engineering'),(66,'8572dbdc-ad4c-4b87-a14f-7e4d87a76611','CSSE7025','Advanced Information Technology Project'),(67,'338eea2f-945f-4d6e-8678-5d387b1dfa06','CSSE7030','Introduction to Software Engineering I'),(68,'cde7cbeb-c79e-4e36-a1fb-722d372f90dc','CSSE7032','Models of Software Systems'),(69,'be91ab0b-22a6-4f90-aef7-94602ee5c0c7','CSSE7034','Predictable Professional Performance'),(70,'ecfeed04-450d-4011-8e11-1de4c6daa766','CSSE7201','Introduction to Computer Systems'),(71,'7e847a99-9292-4bc9-8824-1a36062d7be9','CSSE7231','Computer Systems Principles and Programming'),(72,'9c2f17c7-ee88-4f49-92ef-c8f3e6aaa08f','CSSE7301','Embedded Systems Design & Interfacing'),(73,'f2e5e91d-7036-4c71-aaae-78f7d703ccb8','CSSE7306','Special Projects in Computer Systems and Software Engineering	#4'),(74,'951611cc-8a73-46dd-83a9-dc2f698b2683','CSSE7410','Digital System Design'),(75,'79fda2dc-1ef1-4407-8a3e-8315c5ab7354','CSSE7411','Advanced Embedded Systems'),(76,'655b55d2-f901-4a53-a937-f50792df84e8','CSSE7420','Wireless Sensor Networks'),(77,'40c450fa-8c1e-4120-bf0b-865349866ab4','CSSE7500','Modelling and Simulation'),(78,'df826bdb-d80c-40d8-9a15-29766d006a27','CSSE7510','Reconfigurable Embedded Systems - Concepts adn Practice'),(79,'28eaf276-2031-4cdf-95d7-731b50aa13eb','CSSE7520','Unmanned Aerial Vehicles - Avionics'),(80,'f7156da3-1ce4-4bc8-909e-3e0ef53f39f8','CSSE7530','VLSI Circuits and Systems'),(81,'db3aa0b6-f8c2-453e-864c-27edb97f4b9f','CSSE7610','Concurrency: Theory and Practice'),(82,'2a5a6443-1754-4061-a999-59aaf3044d96','DECO1100','Design Thinking'),(83,'593bd825-5c37-4b9f-a698-258272bb83ee','DECO1400','Introduction to Web Design'),(84,'f25a5b91-c843-404f-af11-3713aa0718bb','DECO1800','Design Computing Studio 1 - Interactive Technology'),(85,'5031c641-5bed-4e0d-b8a5-d22627433485','DECO2200','Graphic Design'),(86,'e20471d9-864c-41ad-9630-1123ec904bc3','DECO2300','Digital Prototyping'),(87,'33bcecb9-c8fb-4601-ab54-2be159da7122','DECO2500','Human-Computer Interaction'),(88,'b5249500-1916-41e0-b001-9ca00f682c72','DECO2800','Design Computing Studio 2 - Testing & Evaluation'),(89,'5b73329d-8e1e-40bc-b02a-2849864c66b7','DECO3500','Social and Mobile Computing'),(90,'edc567ae-23ee-4a0b-847a-ed30eb3fe160','DECO3800','Design Computing Studio 3 - Proposal'),(91,'12ee1599-5781-4947-a7ed-e919f65ac80e','DECO3801','Design Computing Studio 3 - Build'),(92,'7cd97c69-e6af-410b-8225-9babba88104e','DECO3850','Physical Computing & Interaction Design Studio'),(93,'292d71a4-c44d-461d-b000-42cbc7c9bdb4','DECO4500','Advanced Human-Computer Interaction'),(94,'b0c6c328-c440-475c-a43f-17f423d862c2','DECO6801','Design Computing Thesis'),(95,'d46844c3-6eb3-46e7-8db8-52afe165aa1c','DECO6802','Design Computing Thesis'),(96,'b0a3859b-9420-4ba7-86d2-16a8da6cc76f','DECO7110','Design Thinking'),(97,'7426376d-715f-4eac-923c-3ac5a9261a4d','DECO7140','Introduction to Web Design'),(98,'6b8f692f-0993-4015-ab42-72dbb4a00f92','DECO7180','Design Computing Studio 1 - Interactive Technology'),(99,'e6846b02-3c6b-4de2-b5d0-b41befc2c462','DECO7220','Graphic Design'),(100,'02a4eb51-e1f4-4d37-8b73-cd0f626c97c4','DECO7230','Digital Prototyping'),(101,'96cbde91-6f0e-47ca-bd5a-2666b0ea4b38','DECO7250','Human-Computer Interaction'),(102,'fa656eef-74ea-4bc6-a656-4bad70e62430','DECO7280','Design Computing Studio 2 - Testing & Evaluation'),(103,'8fa28fac-1304-40f5-ba37-aef93065167e','DECO7350','Social & Mobile Computing'),(104,'6a7f6e37-02b0-4eb8-be72-cce3e889f669','DECO7380','Design Computing Studio 3 - Proposal'),(105,'efbcf82a-f401-411e-8ad6-1e683b1aee7b','DECO7381','Design Computing Studio 3 - Build'),(106,'1d89351c-f04c-49b8-b5c6-2585fad07036','DECO7385','Physical Computing & Interaction Design Studio'),(107,'3594178c-adc7-43d4-aedf-0a8d80e92857','DECO7450','Advanced Human-Computer Interaction'),(108,'1ec55b02-012f-47dc-a7f6-8a7a56451bd4','DECO7860','Masters Thesis'),(109,'40a41921-f263-408b-8b68-26ad5d364108','DECO7861','Masters Thesis'),(110,'7bc0e558-470d-4e5f-be9e-1436806b29b1','DECO7862','Masters Thesis'),(111,'2bf78fed-eace-4f8f-9b57-f3351b7beda7','ELEC2003','Electromechanics & Electronics'),(112,'efe1f224-a4c8-4fc5-ae14-eb7af723bc54','ELEC2004','Circuits, Signals & Systems'),(113,'b3472ebb-f999-4c22-8fa3-b43e91d6bd2e','ELEC3004','Signals, Systems & Control'),(114,'a871b0d7-4206-438e-ae96-a05e23e84f41','ELEC3100','Fundamentals of Electromagnetic Fields & Waves'),(115,'b8bc7f7e-035a-43ec-87f5-37de0fe7dbac','ELEC3300','Electrical Energy Conversion & Utilisation'),(116,'3a54a237-e088-43f7-b02b-84f9c21cc1b2','ELEC3400','Electronic Circuits'),(117,'9853fccf-db2d-4326-8746-4efe25d7afc9','ELEC4300','Power Systems Analysis'),(118,'a0e2759a-dafc-4b75-8116-1cbbc994dc10','ELEC4302','Power System Protection'),(119,'157c3f61-7dd2-4c6e-9ff6-10cfba27b297','ELEC4320','Modern Asset Management and Condition Monitoring in Power System'),(120,'1e398080-c8c4-43e4-9ada-18d6ae226376','ELEC4400','Advanced Electronic & Power Electronics Design'),(121,'74fef6d7-9092-40f9-aa70-7446cb3ea96d','ELEC4403','Medical & Industrial Instrumentation'),(122,'a8fe3b3c-f62f-482f-842c-f9091bf742d8','ELEC4601','Medical Imaging I'),(123,'9400f134-59e2-4dc6-ad83-869b7dbf0ed8','ELEC4620','Digital Signal Processing'),(124,'4b3bb88b-5b9c-404e-a598-75371df9c41f','ELEC4630','Image Processing and Computer Vision'),(125,'7e5846a4-443f-4aa9-8126-e7c28ea39846','ELEC7050','Generator Technology Design & Application'),(126,'fc0c915b-d57f-4faa-b2cb-6199b69938e7','ELEC7051','Transformer Technology Design and Operation'),(127,'7b8b6c90-ad53-4570-b670-0506e800b2e1','ELEC7052','Plant Control Systems	Not offered after 2013.'),(128,'25a15631-cb99-43d8-a6f5-18e13ea6d32c','ELEC7101','Fundamentals of Electromagnetic Fields & Waves'),(129,'bc12b3f1-8de0-428c-aed9-4a8bc5ed1826','ELEC7302','Electrical Energy Conversion & Utilisation'),(130,'1effcb4e-ecaf-4747-9a38-f88d75614720','ELEC7303','Power Systems Analysis'),(131,'4295dd15-57b2-43a0-8145-95fb8afe39a1','ELEC7309','Power System Planning and Reliability'),(132,'e1dc45df-4f62-4772-b72c-da2718e4bca1','ELEC7310','Electricity Market Operation and Security'),(133,'91ae14eb-6272-49b0-b39d-be41a56db960','ELEC7311','Power System Protection'),(134,'7ee0008b-1075-4a08-8ef2-db15c628b501','ELEC7312','Signals, Systems & Control'),(135,'1cae4a5c-f047-4a37-9471-81476bdf6eb3','ELEC7313','Renewable Energy Integration: Technologies to Technical Challenges'),(136,'2e755568-ee0f-494f-81d5-8dd66b52c123','ELEC7401','Electronic Circuits'),(137,'5436736a-8bad-471e-93cd-83ac578a3a14','ELEC7402','Advanced Electronic & Power Electronics Design'),(138,'f2cbc465-07ff-4087-952e-5ef7f4665646','ELEC7403','Medical & Industrial Instrumentation'),(139,'b0b32aa3-021c-4403-b300-cb46f048a9ba','ELEC7420','Modern Asset Management and Condition Monitoring in Power System'),(140,'949a31b5-0b13-410a-b963-ed76691446f4','ELEC7462','Digital Signal Processing'),(141,'cc32b670-778b-4f8c-80f0-80bf261c29f4','ELEC7463','Image Processing and Computer Vision'),(142,'fc0af9f1-6a91-4015-a2dd-0a1c1f33944b','ELEC7606','Medical Imaging I'),(143,'6368cdfc-a467-44fc-a874-b8a948cd4f66','ELEC7901','Advanced Medical Device Engineering'),(144,'001c1d29-2461-4250-a761-5260f8c63f27','ELEC7902','Clinical Biomedical Signal Processing'),(145,'c376c8b2-9499-4c71-8941-69f2b88a7eb4','ELEC7903','Biomedical Engineering in Sports Medicine'),(146,'97199ea9-c22c-4bfc-b079-a082535b716a','ENGG1100','Introduction to Engineering Design'),(147,'49d5ace8-db4b-444e-bb24-04ac1baecc37','ENGG1200','Engineering Modelling & Problem Solving'),(148,'34ab6b46-01ff-4afa-b135-b95e145d8ecf','ENGG1300','Introduction to Electrical Systems'),(149,'720e90d9-54c3-4912-9464-8bb35dae8076','ENGG2800','Team Project I'),(150,'d5280563-4675-4879-8cb1-7a91007e1ab3','ENGG4000','Introduction to Systems Engineering'),(151,'e4c6cbfc-ef7b-4c00-bd83-51b008130cf4','ENGG4020','Systems Safety Engineering'),(152,'2c8a34a4-a181-411c-9081-958fc6ed66fb','ENGG4800','Project Management'),(153,'f3fc6651-5ee8-42fe-83fd-3f8587a67517','ENGG4801','Thesis Project (S1 start)'),(154,'242249f3-118e-4a0c-b6e9-f78391dbbb73','ENGG4802','Thesis Project (S2 start)'),(155,'a9328727-a0aa-4a94-82fa-7f4969c18727','ENGG4805','Thesis Project'),(156,'5faee042-c15d-4959-b09a-955e19c0c4b1','ENGG4810','Team Project II'),(157,'7362ce9d-3026-4dd7-8571-beec0291bff7','ENGG7000','Systems Engineering'),(158,'bedc8cc2-0e93-4234-b7ba-17a5cbf36cc1','ENGG7020','Systems Safety Engineering'),(159,'34be7ce0-5977-44ce-96ee-3525cfcd2c72','ENGG7302','Advanced Computational Techniques in Engineering'),(160,'1d20443c-5070-4147-a62c-97ec388d299f','ENGG7800','Engineering Project Management'),(161,'dd2b870b-5b66-4e51-a722-c182b266592c','ENGG7802','Engineering Postgraduate Project B'),(162,'530c26df-f751-4cde-96ab-d7d0957c7976','ENGG7803','Engineering Postgraduate Project B'),(163,'fa159bef-2c1b-451c-9231-b79167ba03a1','ENGG7804','Engineering Postgraduate Project B'),(164,'c664c37a-5e0c-4bcd-81fd-43948f170eb2','ENGG7806','Engineering Postgraduate Project D'),(165,'5ef0b0bd-2bb9-4a3e-a5dc-4b71444c6648','ENGG7807','Engineering Postgraduate Project D'),(166,'7dead654-0921-4112-a514-23d4461dc43b','ENGG7808','Engineering Postgraduate Project D'),(167,'298e12d7-084a-4779-8131-e8f1fe549061','ENGG7820','Engineering Thesis Project'),(168,'ad0e3fef-110e-4f31-8c80-27808ab95c03','ENGG7830','Engineering Placement Project'),(169,'68c129ca-3125-42ac-adfd-0b6f0450cb41','INFS1200','Introduction to Information Systems'),(170,'3ebc94f8-0c32-4164-8523-86bca545756e','INFS1300','The Web from the Inside Out - from Geeks to Google & Facebook'),(171,'ddcba88f-6379-4a68-8107-f2673ddf38dc','INFS2200','Relational Database Systems'),(172,'7316a0a6-a77c-45ff-89d5-495cc58caa8a','INFS3200','Advanced Database Systems'),(173,'f5773f54-c044-4e79-9f2c-cf1ab3a691ba','INFS3202','Web Information Systems'),(174,'7a2fa209-1df5-4794-8f00-fa0c08367e4b','INFS3204','Service-Oriented Architectures'),(175,'a01c304a-4345-4126-b96e-51d40fb7f6d4','INFS4203','Data Mining'),(176,'c958a74d-5623-442c-84e9-7a2c6eee7773','INFS4205','Spatial and Multimedia Databases'),(177,'9f1e1576-4214-4908-865d-f59ac00ee7be','INFS7130','The Web from the Inside Out - from Geeks to Google & Facebook'),(178,'2a0c3b0c-5cca-4d3b-8a58-a98a6b8c138d','INFS7202','Web Information Systems'),(179,'0f0f70f1-ffce-41b8-b93a-ba08a7835b8d','INFS7203','Data Mining'),(180,'dc90ef22-2ade-49bf-b7f9-d2b0825bf5cb','INFS7204','Service-Oriented Architectures'),(181,'c6f7c10e-1df8-48eb-a772-118f92c8617f','INFS7205','Spatial and Multimedia Databases'),(182,'ec97fa99-c019-41a5-a315-0b8a56b49704','INFS7410','Information Retrieval and Web Search'),(183,'912669b5-4c9f-4ac0-b167-f2d4ec6cfdb8','INFS7900','Information Systems'),(184,'9b1e99e5-7399-4afc-9602-07560c3e7759','INFS7903','Relational Database Systems'),(185,'882edca7-e3b1-4230-ac27-5e77150ef1f4','INFS7907','Advanced Database Systems'),(186,'1e356a22-651b-4ead-91f6-884f27ed7d3b','METR2800','Mechatronic System Design Project I'),(187,'da3b1093-f34f-4322-84d8-7c7f3ac1b97c','METR3100','Sensors & Actuators'),(188,'aa4b26e4-ef00-457f-ba83-635ea3e00a2e','METR3200','Introduction to Control Systems'),(189,'30f27d6e-0cbe-4367-94c4-7f2aed82151a','METR3800','Mechatronic System Design Project II'),(190,'9bd6aae6-22be-4812-83d4-8f2465b77a26','METR4201','Introduction to Control Systems'),(191,'e1a15a46-3420-4907-9a0c-2c2e06de7019','METR4202','Advanced Control & Robotics'),(192,'29b23002-b855-4653-bdc5-01082878ccb8','METR4810','Mechatronic System Design Project II'),(193,'5881986a-3367-444f-b7db-d0c758c72987','METR4900','Thesis/Design Project'),(194,'d2defe32-c93e-4779-9587-4251a3b403c3','METR4901','Thesis/Design Project'),(195,'f4fb5e6c-86e7-40c1-b25b-ea34c865c017','METR7200','Introduction to Control Systems'),(196,'a3f6f961-2c04-4213-aeaa-882075c0b2e3','METR7202','Advanced Control & Robotics'),(197,'5d8cf9c4-0e59-474a-b6ca-4c9fa9d4b125','METR7820','Engineering Thesis Project'),(198,'24ade3d5-a578-4549-ae9c-e548e6916ebe','METR7830','Engineering Placement Project'),(199,'61515066-2709-407b-aa75-7d7bfebe99ee','SCIE1000','Theory & Practice in Science'),(200,'1c4db223-4179-4023-af21-7dae43ba2efa','SCIE2100','1 Introduction to Bioinformatics');
/*!40000 ALTER TABLE `review_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_course_students`
--

DROP TABLE IF EXISTS `review_course_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_course_students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `reviewuser_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `review_course_students_course_id_33e15abeb9b928c7_uniq` (`course_id`,`reviewuser_id`),
  KEY `review_course_students_6234103b` (`course_id`),
  KEY `review_course_students_c6440f4a` (`reviewuser_id`),
  CONSTRAINT `course_id_refs_id_4df39490` FOREIGN KEY (`course_id`) REFERENCES `review_course` (`id`),
  CONSTRAINT `reviewuser_id_refs_id_23835d11` FOREIGN KEY (`reviewuser_id`) REFERENCES `review_reviewuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_course_students`
--

LOCK TABLES `review_course_students` WRITE;
/*!40000 ALTER TABLE `review_course_students` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_course_students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_reviewuser`
--

DROP TABLE IF EXISTS `review_reviewuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_reviewuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_uuid` varchar(36) NOT NULL,
  `djangoUser_id` int(11) NOT NULL,
  `isStaff` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `djangoUser_id` (`djangoUser_id`),
  CONSTRAINT `djangoUser_id_refs_id_ce92d1c6` FOREIGN KEY (`djangoUser_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_reviewuser`
--

LOCK TABLES `review_reviewuser` WRITE;
/*!40000 ALTER TABLE `review_reviewuser` DISABLE KEYS */;
INSERT INTO `review_reviewuser` VALUES (1,'99ffcc68-a9c4-450d-b74c-8acc976b206d',2,0);
/*!40000 ALTER TABLE `review_reviewuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_reviewuser_courses`
--

DROP TABLE IF EXISTS `review_reviewuser_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_reviewuser_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reviewuser_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `review_reviewuser_courses_reviewuser_id_744e9d5e44593134_uniq` (`reviewuser_id`,`course_id`),
  KEY `review_reviewuser_courses_c6440f4a` (`reviewuser_id`),
  KEY `review_reviewuser_courses_6234103b` (`course_id`),
  CONSTRAINT `reviewuser_id_refs_id_eca292ce` FOREIGN KEY (`reviewuser_id`) REFERENCES `review_reviewuser` (`id`),
  CONSTRAINT `course_id_refs_id_e1fe2446` FOREIGN KEY (`course_id`) REFERENCES `review_course` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_reviewuser_courses`
--

LOCK TABLES `review_reviewuser_courses` WRITE;
/*!40000 ALTER TABLE `review_reviewuser_courses` DISABLE KEYS */;
INSERT INTO `review_reviewuser_courses` VALUES (1,1,1);
/*!40000 ALTER TABLE `review_reviewuser_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_sourceannotation`
--

DROP TABLE IF EXISTS `review_sourceannotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_sourceannotation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `annotation_uuid` varchar(36) NOT NULL,
  `user_id` int(11) NOT NULL,
  `source_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `text` longtext NOT NULL,
  `quote` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `review_sourceannotation_6340c63c` (`user_id`),
  KEY `review_sourceannotation_a34b03a6` (`source_id`),
  CONSTRAINT `source_id_refs_id_ff216b20` FOREIGN KEY (`source_id`) REFERENCES `review_sourcefile` (`id`),
  CONSTRAINT `user_id_refs_id_c5e486c3` FOREIGN KEY (`user_id`) REFERENCES `review_reviewuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_sourceannotation`
--

LOCK TABLES `review_sourceannotation` WRITE;
/*!40000 ALTER TABLE `review_sourceannotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_sourceannotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_sourceannotationrange`
--

DROP TABLE IF EXISTS `review_sourceannotationrange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_sourceannotationrange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `range_annotation_id` int(11) NOT NULL,
  `start` longtext NOT NULL,
  `end` longtext NOT NULL,
  `startOffset` int(10) unsigned NOT NULL,
  `endOffset` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `review_sourceannotationrange_e92f1259` (`range_annotation_id`),
  CONSTRAINT `range_annotation_id_refs_id_2e0dc21e` FOREIGN KEY (`range_annotation_id`) REFERENCES `review_sourceannotation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_sourceannotationrange`
--

LOCK TABLES `review_sourceannotationrange` WRITE;
/*!40000 ALTER TABLE `review_sourceannotationrange` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_sourceannotationrange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_sourceannotationtag`
--

DROP TABLE IF EXISTS `review_sourceannotationtag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_sourceannotationtag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_annotation_id` int(11) NOT NULL,
  `tag` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `review_sourceannotationtag_afe05e8a` (`tag_annotation_id`),
  CONSTRAINT `tag_annotation_id_refs_id_1d6bf2d6` FOREIGN KEY (`tag_annotation_id`) REFERENCES `review_sourceannotation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_sourceannotationtag`
--

LOCK TABLES `review_sourceannotationtag` WRITE;
/*!40000 ALTER TABLE `review_sourceannotationtag` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_sourceannotationtag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_sourcefile`
--

DROP TABLE IF EXISTS `review_sourcefile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_sourcefile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) NOT NULL,
  `file_uuid` varchar(36) NOT NULL,
  `name` longtext NOT NULL,
  `file` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `review_sourcefile_3aef490b` (`folder_id`),
  CONSTRAINT `folder_id_refs_id_64e8f40a` FOREIGN KEY (`folder_id`) REFERENCES `review_sourcefolder` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_sourcefile`
--

LOCK TABLES `review_sourcefile` WRITE;
/*!40000 ALTER TABLE `review_sourcefile` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_sourcefile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_sourcefolder`
--

DROP TABLE IF EXISTS `review_sourcefolder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_sourcefolder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_uuid` varchar(36) NOT NULL,
  `name` longtext NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `review_sourcefolder_410d0aac` (`parent_id`),
  CONSTRAINT `parent_id_refs_id_49b8a727` FOREIGN KEY (`parent_id`) REFERENCES `review_sourcefolder` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_sourcefolder`
--

LOCK TABLES `review_sourcefolder` WRITE;
/*!40000 ALTER TABLE `review_sourcefolder` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_sourcefolder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_submissiontest`
--

DROP TABLE IF EXISTS `review_submissiontest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_submissiontest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_of_id` int(11) NOT NULL,
  `test_name` longtext NOT NULL,
  `test_count` int(10) unsigned NOT NULL,
  `test_pass_count` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `review_submissiontest_f740f564` (`part_of_id`),
  CONSTRAINT `part_of_id_refs_id_f31b377e` FOREIGN KEY (`part_of_id`) REFERENCES `review_submissiontestresults` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_submissiontest`
--

LOCK TABLES `review_submissiontest` WRITE;
/*!40000 ALTER TABLE `review_submissiontest` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_submissiontest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_submissiontestresults`
--

DROP TABLE IF EXISTS `review_submissiontestresults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_submissiontestresults` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tests_completed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_submissiontestresults`
--

LOCK TABLES `review_submissiontestresults` WRITE;
/*!40000 ALTER TABLE `review_submissiontestresults` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_submissiontestresults` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `south_migrationhistory`
--

DROP TABLE IF EXISTS `south_migrationhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `south_migrationhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(255) NOT NULL,
  `migration` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `south_migrationhistory`
--

LOCK TABLES `south_migrationhistory` WRITE;
/*!40000 ALTER TABLE `south_migrationhistory` DISABLE KEYS */;
INSERT INTO `south_migrationhistory` VALUES (1,'review','0001_initial','2014-08-09 12:39:02'),(2,'review','0002_auto__del_test__add_user__add_sourceannotation__add_sourcefile__add_so','2014-08-09 12:39:10'),(3,'review','0003_auto__del_user__add_reviewuser__chg_field_sourceannotation_user__chg_f','2014-08-09 12:39:11'),(4,'review','0004_auto__add_field_reviewuser_isStaff','2014-08-09 12:39:11'),(5,'review','0005_auto__add_course','2014-08-09 12:39:12'),(6,'review','0006_auto__add_field_course_course_code__add_field_course_course_name','2014-08-09 12:39:12'),(7,'review','0007_auto__add_field_assignment_course_code','2014-08-09 12:39:13'),(8,'review','0008_auto','2014-08-09 12:39:15'),(9,'review','0009_auto__chg_field_course_course_name','2014-08-09 12:39:15'),(10,'review','0010_auto','2014-08-09 12:39:16');
/*!40000 ALTER TABLE `south_migrationhistory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-08-11 13:43:08
