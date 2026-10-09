/*
 Navicat Premium Dump SQL

 Source Server         : school_mysql
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : school_db

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 09/10/2026 16:20:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `course_id` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `course_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `credits` decimal(3, 1) NOT NULL,
  `dept_id` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cpno` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`course_id`) USING BTREE,
  INDEX `fk_course_dept`(`dept_id` ASC) USING BTREE,
  INDEX `fk_course_prerequisite`(`cpno` ASC) USING BTREE,
  CONSTRAINT `fk_course_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_course_prerequisite` FOREIGN KEY (`cpno`) REFERENCES `course` (`course_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES ('C00001', '数据库系统', 3.5, 'D001', 'C00006');
INSERT INTO `course` VALUES ('C00002', '计算机网络', 3.0, 'D001', 'C00006');
INSERT INTO `course` VALUES ('C00003', '软件工程', 3.0, 'D002', NULL);
INSERT INTO `course` VALUES ('C00004', '网络安全', 2.5, 'D003', 'C00002');
INSERT INTO `course` VALUES ('C00005', '程序设计基础', 3.0, 'D001', NULL);
INSERT INTO `course` VALUES ('C00006', '数据结构', 4.0, 'D001', 'C00005');

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `dept_id` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `office` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`dept_id`) USING BTREE,
  UNIQUE INDEX `uq_dept_name`(`dept_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES ('D001', '计算机系', 'A301');
INSERT INTO `department` VALUES ('D002', '软件工程系', 'A302');
INSERT INTO `department` VALUES ('D003', '网络工程系', 'A303');

-- ----------------------------
-- Table structure for sc
-- ----------------------------
DROP TABLE IF EXISTS `sc`;
CREATE TABLE `sc`  (
  `student_id` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `course_id` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `grade` decimal(5, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`student_id`, `course_id`) USING BTREE,
  INDEX `fk_sc_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `fk_sc_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_sc_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc
-- ----------------------------
INSERT INTO `sc` VALUES ('2023000001', 'C00001', 85.50);
INSERT INTO `sc` VALUES ('2023000001', 'C00002', 92.00);
INSERT INTO `sc` VALUES ('2023000002', 'C00001', 88.00);
INSERT INTO `sc` VALUES ('2023000002', 'C00003', 90.50);
INSERT INTO `sc` VALUES ('2023000003', 'C00003', 86.00);
INSERT INTO `sc` VALUES ('2023000004', 'C00004', 91.00);

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `student_id` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `student_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `age` tinyint UNSIGNED NULL DEFAULT NULL,
  `dept_id` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`student_id`) USING BTREE,
  INDEX `fk_student_dept`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `fk_student_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES ('2023000001', '张三', '男', 20, 'D001');
INSERT INTO `student` VALUES ('2023000002', '李四', '女', 21, 'D001');
INSERT INTO `student` VALUES ('2023000003', '王五', '男', 20, 'D002');
INSERT INTO `student` VALUES ('2023000004', '赵六', '女', 22, 'D003');

SET FOREIGN_KEY_CHECKS = 1;
