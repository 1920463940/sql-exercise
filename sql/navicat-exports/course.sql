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

 Date: 08/10/2026 18:02:22
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
  PRIMARY KEY (`course_id`) USING BTREE,
  INDEX `fk_course_dept`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `fk_course_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES ('C00001', '数据库系统', 3.5, 'D001');
INSERT INTO `course` VALUES ('C00002', '计算机网络', 3.0, 'D001');
INSERT INTO `course` VALUES ('C00003', '软件工程', 3.0, 'D002');
INSERT INTO `course` VALUES ('C00004', '网络安全', 2.5, 'D003');

SET FOREIGN_KEY_CHECKS = 1;
