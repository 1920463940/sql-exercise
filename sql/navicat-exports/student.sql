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

 Date: 08/10/2026 18:02:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
