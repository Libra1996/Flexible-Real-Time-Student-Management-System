/*
Navicat MySQL Data Transfer

Source Server         : gia
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : db_student_manager_web

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2022-08-02 22:28:54
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `s_admin`
-- ----------------------------
DROP TABLE IF EXISTS `s_admin`;
CREATE TABLE `s_admin` (
  `id` int(5) NOT NULL,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_admin
-- ----------------------------
INSERT INTO `s_admin` VALUES ('0', 'admin', '123456', '1');

-- ----------------------------
-- Table structure for `s_attendance`
-- ----------------------------
DROP TABLE IF EXISTS `s_attendance`;
CREATE TABLE `s_attendance` (
  ` id` int(5) NOT NULL AUTO_INCREMENT,
  `course_id` int(5) NOT NULL,
  `student_id` int(5) NOT NULL,
  `type` varchar(11) NOT NULL,
  `date` varchar(11) NOT NULL,
  PRIMARY KEY (` id`),
  KEY `attendance_course_foreign_key` (`course_id`),
  KEY `attendance_student_foreign_key` (`student_id`),
  CONSTRAINT `attendance_course_foreign_key` FOREIGN KEY (`course_id`) REFERENCES `s_course` (`id`),
  CONSTRAINT `attendance_student_foreign_key` FOREIGN KEY (`student_id`) REFERENCES `s_student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_attendance
-- ----------------------------
INSERT INTO `s_attendance` VALUES ('1', '1', '1', 'session 1', '2022-07-20');
INSERT INTO `s_attendance` VALUES ('2', '2', '1', 'session 1', '2022-07-20');

-- ----------------------------
-- Table structure for `s_clazz`
-- ----------------------------
DROP TABLE IF EXISTS `s_clazz`;
CREATE TABLE `s_clazz` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `info` varchar(512) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_clazz
-- ----------------------------
INSERT INTO `s_clazz` VALUES ('1', 'Advertising, BS', 'Successful modern advertising takes creativity and innovation. The School of Journalism and Mass Communications can give you the skills to make a difference in this dynamic field.');
INSERT INTO `s_clazz` VALUES ('2', 'Aerospace Engineering, BS', 'The Aerospace Engineering BS, offered by the Department of Aerospace Engineering, is based on a strong core of mathematics, science, and engineering science and is designed to prepare students for professional careers in aerospace engineering fields.');
INSERT INTO `s_clazz` VALUES ('3', 'Anthropology, BA', 'The Department of Anthropology provides students with an integrated anthropological experience through coursework in archeology, cultural anthropology, and physical anthropology.');
INSERT INTO `s_clazz` VALUES ('4', 'Behavioral Science, BA', 'Behavioral Science majors develop an interdisciplinary perspective on human behavior and an understanding of psychological, social and cultural dimensions to being human in a complex society.');
INSERT INTO `s_clazz` VALUES ('5', 'Biomedical Engineering, BS', 'The reputation of our educational programs as providing a unique practical approach built on a strong academic foundation continues to attract students.');
INSERT INTO `s_clazz` VALUES ('6', 'Business Administration, BS', 'updating...');
INSERT INTO `s_clazz` VALUES ('7', 'Civil Engineering, BS', 'Civil Engineers plan, design and supervise construction of buildings, roadways, bridges, water supply systems, communications networks and transportation systems.');
INSERT INTO `s_clazz` VALUES ('8', 'Computer Engineering, BS', 'The program prepares students to become qualified engineers for IT leading companies in Silicon Valley and international engineering market by providing them with state-of-the-art engineering methods, emergent technologies, team work experience, and solutions.');
INSERT INTO `s_clazz` VALUES ('9', 'Computer Science, BS', 'The program not only prepares students for graduate work in computer science, but also for advanced work in the related fields of management science and operations research.');
INSERT INTO `s_clazz` VALUES ('10', 'Dance, BA', 'The BA program strives to challenge students with technical practice in various dance techniques, theoretical study in several areas, and ample performance opportunities.');
INSERT INTO `s_clazz` VALUES ('11', 'Design Studies, BA', 'Students may be admitted to the BFA in Interior Design or BFA in Graphic Design or the BS in Industrial Design on a space-available basis after successfully completing required portfolio reviews.');
INSERT INTO `s_clazz` VALUES ('12', 'Economics, BS', 'The Department of Economics has one core mission: to train both graduate and undergraduate students in the economic way of thinking and market process.');
INSERT INTO `s_clazz` VALUES ('13', 'Electrical Engineering, BS', 'Our curriculum is designed to prepare our graduates for the dynamic global society. A very highly qualified and dedicated EE faculty is the strength of the department.');
INSERT INTO `s_clazz` VALUES ('14', 'English, BA', 'Students are exposed to a wide range of canonical and non-canonical texts, and they learn to read closely and critically, and to write clearly and effectively.');
INSERT INTO `s_clazz` VALUES ('15', 'Forensic Science, BS', 'updating...');
INSERT INTO `s_clazz` VALUES ('16', 'French, BA', 'The Department of World Languages and Literatures seeks to develop in students the ability to communicate effectively with people who speak languages other than English and whose world views and cultural values may differ substantially from their own.');
INSERT INTO `s_clazz` VALUES ('17', 'Geography, BA', 'The Geography, BA degree will allow students to focus more specifically on a particular area of Geography.');
INSERT INTO `s_clazz` VALUES ('18', 'Geology, BS', 'The BS in Geology, offered by the Department of Geology, provides a flexible program that prepares students for admission to graduate programs in the geosciences, and for entry-level positions in engineering.');
INSERT INTO `s_clazz` VALUES ('19', 'Graphic Design, BFA', 'Preparation involves both theoretical and practical study with emphasis on typography, form and image, information architecture, experience design and interactive design.');
INSERT INTO `s_clazz` VALUES ('20', 'History, BA', 'Pplanned for those who wish a general liberal education, for those who want a broad foundation for any one of the social sciences, for those who desire advanced degrees in the field of history.');
INSERT INTO `s_clazz` VALUES ('21', 'Humanities, BA', 'Our courses, research, and events emphasize the cultural, political, and social aspects of the United States, past and present.');
INSERT INTO `s_clazz` VALUES ('22', 'Industrial Design, BS', 'The Bachelor of Science Industrial Design (BSID) program, offered by the Department of Design, prepares students for a career in industrial design through a curriculum in design studio, theory and skill classes.');
INSERT INTO `s_clazz` VALUES ('23', 'Interior Design, BFA', 'Students majoring in Interior Design, offered by the Department of Design, draw upon a wide range of university and Bay Area community resources to prepare for professional careers in both the private and public sectors in areas such as corporate, hospitality, institutional, office and retail planning and design.');

-- ----------------------------
-- Table structure for `s_course`
-- ----------------------------
DROP TABLE IF EXISTS `s_course`;
CREATE TABLE `s_course` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `teacher_id` int(5) NOT NULL,
  `course_date` varchar(32) DEFAULT NULL,
  `selected_num` int(5) NOT NULL DEFAULT 0,
  `max_num` int(5) NOT NULL DEFAULT 50,
  `info` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  CONSTRAINT `s_course_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `s_teacher` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_course
-- ----------------------------
INSERT INTO `s_course` VALUES ('1', 'Introduction to Advertising', '1', 'MW 8:00am - 9:00am', '6', '30', '');
INSERT INTO `s_course` VALUES ('2', 'Strategic Planning/Communications', '1', 'MW 8:00am - 9:00am', '6', '30', '');
INSERT INTO `s_course` VALUES ('3', 'Visual Communication for Modern Media', '2', 'MW 9:00am - 10:00am', '2', '30', '');
INSERT INTO `s_course` VALUES ('4', 'Writing Workshop: Mass Communications', '2', 'MW 9:00am - 10:00am', '2', '30', '');
INSERT INTO `s_course` VALUES ('5', 'Aerospace Structural Analysis I', '3', 'MW 8:00am - 9:00am', '2', '20', '');
INSERT INTO `s_course` VALUES ('6', 'Aerospace Structural Analysis II', '3', 'MW 8:00am - 9:00am', '2', '20', '');
INSERT INTO `s_course` VALUES ('7', 'Rigid Body Dynamics', '4', 'MW 8:00am - 9:00am', '2', '20', '');
INSERT INTO `s_course` VALUES ('8', 'Aerothermodynamics', '4', 'MW 9:00am - 10:00am', '2', '20', '');
INSERT INTO `s_course` VALUES ('9', 'Cultural Anthropology', '5', 'MW 8:00am - 9:00am', '0', '25', '');
INSERT INTO `s_course` VALUES ('10', 'Introduction to Human Evolution', '5', 'MW 9:00am - 10:00am', '0', '25', '');
INSERT INTO `s_course` VALUES ('11', 'Ethnographic Methods', '6', 'MW 8:00am - 9:00am', '0', '25', '');
INSERT INTO `s_course` VALUES ('12', 'Forensic Osteology', '6', 'MW 9:00am - 10:00am', '0', '25', '');
INSERT INTO `s_course` VALUES ('13', 'Cultural Anthropology', '7', 'TTH 8:00am - 9:00am', '0', '30', '');
INSERT INTO `s_course` VALUES ('14', 'Historical Archaeology', '7', 'TTH 9:00am - 10:00am', '0', '30', '');
INSERT INTO `s_course` VALUES ('15', 'Behavioral Science in Practice', '8', 'TTH 8:00am - 9:00am', '0', '30', '');
INSERT INTO `s_course` VALUES ('16', 'Quantitative Research Methods', '8', 'TTH 9:00am - 10:00am', '0', '30', '');
INSERT INTO `s_course` VALUES ('17', 'Principles of Biology I', '9', 'TTH 8:00am - 9:00am', '0', '20', '');
INSERT INTO `s_course` VALUES ('18', 'General Chemistry', '9', 'TTH 9:00am - 10:00am', '0', '20', '');
INSERT INTO `s_course` VALUES ('19', 'Organic Chemistry', '10', 'TTH 8:00am - 9:00am', '0', '25', '');
INSERT INTO `s_course` VALUES ('20', 'Biomedical Applications of Statics', '10', 'TTH 9:00am - 10:00am', '0', '25', '');
INSERT INTO `s_course` VALUES ('21', 'Financial Accounting', '11', 'TTH 8:00am - 9:00am', '0', '20', '');
INSERT INTO `s_course` VALUES ('22', 'Legal Environment of Business', '11', 'TTH 9:00am - 10:00am', '0', '20', '');
INSERT INTO `s_course` VALUES ('23', 'Business Statistics', '12', 'TTH 8:00am - 9:00am', '0', '20', '');
INSERT INTO `s_course` VALUES ('24', 'Computer Tools for Business', '12', 'TTH 9:00am - 10:00am', '0', '20', '');

-- ----------------------------
-- Table structure for `s_leave`
-- ----------------------------
DROP TABLE IF EXISTS `s_leave`;
CREATE TABLE `s_leave` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `student_id` int(5) NOT NULL,
  `info` varchar(512) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `remark` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `leave_student_foreign_key` (`student_id`),
  CONSTRAINT `leave_student_foreign_key` FOREIGN KEY (`student_id`) REFERENCES `s_student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_leave
-- ----------------------------
INSERT INTO `s_leave` VALUES ('1', '1', 'sick', '1', '');

-- ----------------------------
-- Table structure for `s_score`
-- ----------------------------
DROP TABLE IF EXISTS `s_score`;
CREATE TABLE `s_score` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `student_id` int(5) NOT NULL,
  `course_id` int(5) NOT NULL,
  `score` double(5,2) NOT NULL,
  `remark` varchar(128) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `selected_course_student_fk` (`student_id`),
  KEY `selected_course_course_fk` (`course_id`),
  CONSTRAINT `s_score_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `s_course` (`id`),
  CONSTRAINT `s_score_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `s_student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_score
-- ----------------------------
INSERT INTO `s_score` VALUES ('1', '1', '1', '90.00', '');
INSERT INTO `s_score` VALUES ('2', '1', '2', '89.00', '');
INSERT INTO `s_score` VALUES ('3', '2', '1', '45.00', '');
INSERT INTO `s_score` VALUES ('4', '2', '2', '80.00', '');
INSERT INTO `s_score` VALUES ('5', '3', '3', '80.00', '');
INSERT INTO `s_score` VALUES ('6', '3', '4', '98.00', '');
INSERT INTO `s_score` VALUES ('7', '4', '3', '69.00', '');
INSERT INTO `s_score` VALUES ('8', '4', '4', '90.00', '');
INSERT INTO `s_score` VALUES ('9', '5', '5', '90.00', '');
INSERT INTO `s_score` VALUES ('10', '5', '6', '55.00', '');
INSERT INTO `s_score` VALUES ('11', '6', '5', '69.00', '');
INSERT INTO `s_score` VALUES ('12', '6', '6', '79.00', '');
INSERT INTO `s_score` VALUES ('13', '7', '7', '67.00', '');
INSERT INTO `s_score` VALUES ('14', '7', '8', '89.00', '');
INSERT INTO `s_score` VALUES ('15', '8', '7', '69.00', '');
INSERT INTO `s_score` VALUES ('16', '8', '8', '91.00', '');
INSERT INTO `s_score` VALUES ('17', '9', '1', '97.00', '');
INSERT INTO `s_score` VALUES ('18', '9', '2', '97.00', '');
INSERT INTO `s_score` VALUES ('19', '10', '1', '58.00', '');
INSERT INTO `s_score` VALUES ('20', '11', '2', '78.00', '');
INSERT INTO `s_score` VALUES ('21', '12', '1', '78.00', '');
INSERT INTO `s_score` VALUES ('22', '12', '2', '89.00', '');
INSERT INTO `s_score` VALUES ('23', '13', '2', '49.00', '');
INSERT INTO `s_score` VALUES ('24', '14', '1', '59.00', '');

-- ----------------------------
-- Table structure for `s_selected_course`
-- ----------------------------
DROP TABLE IF EXISTS `s_selected_course`;
CREATE TABLE `s_selected_course` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `student_id` int(5) NOT NULL,
  `course_id` int(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `selected_course_course_fk` (`course_id`),
  KEY `selected_course_student_fk` (`student_id`),
  CONSTRAINT `selected_course_course_fk` FOREIGN KEY (`course_id`) REFERENCES `s_course` (`id`),
  CONSTRAINT `selected_course_student_fk` FOREIGN KEY (`student_id`) REFERENCES `s_student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_selected_course
-- ----------------------------
INSERT INTO `s_selected_course` VALUES ('1', '1', '1');
INSERT INTO `s_selected_course` VALUES ('2', '2', '2');
INSERT INTO `s_selected_course` VALUES ('3', '3', '3');
INSERT INTO `s_selected_course` VALUES ('4', '4', '4');
INSERT INTO `s_selected_course` VALUES ('5', '5', '5');
INSERT INTO `s_selected_course` VALUES ('6', '6', '6');
INSERT INTO `s_selected_course` VALUES ('7', '7', '7');
INSERT INTO `s_selected_course` VALUES ('8', '8', '8');
INSERT INTO `s_selected_course` VALUES ('9', '1', '2');
INSERT INTO `s_selected_course` VALUES ('10', '2', '1');
INSERT INTO `s_selected_course` VALUES ('11', '3', '4');
INSERT INTO `s_selected_course` VALUES ('12', '4', '3');
INSERT INTO `s_selected_course` VALUES ('13', '5', '6');
INSERT INTO `s_selected_course` VALUES ('14', '6', '5');
INSERT INTO `s_selected_course` VALUES ('15', '7', '8');
INSERT INTO `s_selected_course` VALUES ('16', '8', '7');
INSERT INTO `s_selected_course` VALUES ('17', '9', '1');
INSERT INTO `s_selected_course` VALUES ('18', '10', '1');
INSERT INTO `s_selected_course` VALUES ('19', '11', '2');
INSERT INTO `s_selected_course` VALUES ('20', '12', '2');
INSERT INTO `s_selected_course` VALUES ('21', '13', '2');
INSERT INTO `s_selected_course` VALUES ('22', '14', '1');
INSERT INTO `s_selected_course` VALUES ('23', '9', '2');
INSERT INTO `s_selected_course` VALUES ('24', '12', '1');

-- ----------------------------
-- Table structure for `s_student`
-- ----------------------------
DROP TABLE IF EXISTS `s_student`;
CREATE TABLE `s_student` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `sn` varchar(32) NOT NULL,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `clazz_id` int(5) NOT NULL,
  `sex` varchar(6) NOT NULL DEFAULT 'male',
  `mobile` varchar(12) DEFAULT '',
  `email` varchar(32) DEFAULT '',
  `photo` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`,`sn`),
  KEY `id` (`id`),
  KEY `clazz_id` (`clazz_id`),
  CONSTRAINT `s_student_ibfk_1` FOREIGN KEY (`clazz_id`) REFERENCES `s_clazz` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_student
-- ----------------------------
INSERT INTO `s_student` VALUES ('1', 'S1658299328943', 'adam', 'adam123', '1', 'male', '', '', null);
INSERT INTO `s_student` VALUES ('2', 'S1658299349185', 'anthony', 'anthony123', '1', 'male', '', '', null);
INSERT INTO `s_student` VALUES ('3', 'S1658299362519', 'angel', 'angel123', '1', 'female', '', '', null);
INSERT INTO `s_student` VALUES ('4', 'S1658299376644', 'anna', 'anna123', '1', 'female', '', '', null);
INSERT INTO `s_student` VALUES ('5', 'S1658299424715', 'brandon', 'brandon123', '2', 'male', '', '', null);
INSERT INTO `s_student` VALUES ('6', 'S1658299488431', 'barrett', 'barrett123', '2', 'male', '', '', null);
INSERT INTO `s_student` VALUES ('7', 'S1658299508192', 'bella', 'bella', '2', 'female', '', '', null);
INSERT INTO `s_student` VALUES ('8', 'S1658299522483', 'bailey', 'bailey', '2', 'female', '', '', null);
INSERT INTO `s_student` VALUES ('9', 'S1658333526508', 'alexander', 'alexander123', '1', 'male', '', '', null);
INSERT INTO `s_student` VALUES ('10', 'S1658333542057', 'aiden', 'aiden123', '1', 'male', '', '', null);
INSERT INTO `s_student` VALUES ('11', 'S1658333559529', 'aaron', 'aaron123', '1', 'male', '', '', null);
INSERT INTO `s_student` VALUES ('12', 'S1658333597601', 'audrey', 'audrey123', '1', 'female', '', '', null);
INSERT INTO `s_student` VALUES ('13', 'S1658333679621', 'avery', 'avery123', '1', 'female', '', '', null);
INSERT INTO `s_student` VALUES ('14', 'S1658333696438', 'aria', 'aria123', '1', 'female', '', '', null);

-- ----------------------------
-- Table structure for `s_teacher`
-- ----------------------------
DROP TABLE IF EXISTS `s_teacher`;
CREATE TABLE `s_teacher` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `sn` varchar(32) NOT NULL,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `clazz_id` int(5) NOT NULL,
  `sex` varchar(6) NOT NULL DEFAULT 'male',
  `mobile` varchar(12) DEFAULT '',
  `email` varchar(32) DEFAULT '',
  `photo` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`,`sn`),
  KEY `student_clazz_id_foreign` (`clazz_id`),
  KEY `id` (`id`),
  CONSTRAINT `s_teacher_ibfk_1` FOREIGN KEY (`clazz_id`) REFERENCES `s_clazz` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of s_teacher
-- ----------------------------
INSERT INTO `s_teacher` VALUES ('1', 'T1658296715614', 'abbort', 'abbort123', '1', 'male', '4081234567', 'abbort@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('2', 'T1658296877607', 'abrams', 'abrams123', '1', 'female', '4089876543', 'abrams@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('3', 'T1658296918661', 'baba', 'baba123', '2', 'male', '4081234567', 'baba@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('4', 'T1658296964549', 'bacich', 'bacich123', '2', 'female', '4089876543', 'bacich@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('5', 'T1658297188028', 'cabot', 'cabot123', '3', 'male', '4081234567', 'cabot@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('6', 'T1658297232599', 'caffrey', 'caffrey123', '3', 'female', '4089876543', 'caffrey@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('7', 'T1658297314553', 'danese', 'danese123', '4', 'male', '4081234567', 'danese@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('8', 'T1658297345406', 'danzig', 'danzig123', '4', 'female', '4089876543', 'danzig@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('9', 'T1658297368329', 'easter', 'easter123', '5', 'male', '4081234567', 'easter@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('10', 'T1658297401533', 'eggers', 'eggers123', '5', 'female', '4089876543', 'eggers@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('11', 'T1658297432289', 'fadiman', 'fadiman123', '6', 'male', '4081234567', 'fadiman@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('12', 'T1658297461711', 'faires', 'faires123', '6', 'female', '4089876543', 'faires@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('13', 'T1658297490787', 'gaines', 'gaines123', '7', 'male', '4081234567', 'gaines@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('14', 'T1658297508895', 'gao', 'gao123', '7', 'female', '4089876543', 'gao@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('15', 'T1658297536489', 'haas', 'haas123', '8', 'male', '4081234567', 'haas@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('16', 'T1658297560844', 'hager', 'hager123', '8', 'female', '4089876543', 'hager@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('17', 'T1658297586417', 'inaba', 'inaba123', '9', 'male', '4081234567', 'inaba@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('18', 'T1658297613250', 'ionescu', 'ionescu123', '9', 'female', '4089876543', 'ionescu@sjsu.edu', null);
INSERT INTO `s_teacher` VALUES ('19', 'T1658297627696', 'jackson', 'jackson123', '10', 'male', '', '', null);
INSERT INTO `s_teacher` VALUES ('20', 'T1658297644452', 'jacoby', 'jacoby123', '10', 'female', '', '', null);
INSERT INTO `s_teacher` VALUES ('21', 'T1658297658933', 'kahn', 'kahn123', '11', 'male', '', '', null);
INSERT INTO `s_teacher` VALUES ('22', 'T1658297671386', 'kalar', 'kalar123', '11', 'female', '', '', null);
INSERT INTO `s_teacher` VALUES ('23', 'T1658297743424', 'laker', 'laker123', '12', 'male', '', '', null);
INSERT INTO `s_teacher` VALUES ('24', 'T1658297753304', 'lam', 'lam123', '12', 'female', '', '', null);
