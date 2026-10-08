-- 学生、系、课程数据库实践 / MySQL 8.0.43
-- 注意：此脚本用于演示环境的重建。再次执行会删除并重新创建三张表，原有数据将被覆盖！
-- 如需保留既有数据，请不要执行下面的 DROP TABLE 语句。

CREATE DATABASE IF NOT EXISTS `school_db`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;
USE `school_db`;
SET NAMES utf8mb4;

-- 按外键依赖顺序先删除子表，再删除父表
DROP TABLE IF EXISTS `student`;
DROP TABLE IF EXISTS `course`;
DROP TABLE IF EXISTS `department`;

-- 先创建系表（父表）
CREATE TABLE `department`  (
  `dept_id` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `office` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`dept_id`) USING BTREE,
  UNIQUE INDEX `uq_dept_name`(`dept_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- 学生表（子表）
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

-- 课程表（子表）
CREATE TABLE `course`  (
  `course_id` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `course_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `credits` decimal(3, 1) NOT NULL,
  `dept_id` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`course_id`) USING BTREE,
  INDEX `fk_course_dept`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `fk_course_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- 插入系表示例数据：3 条
INSERT INTO `department` VALUES ('D001', '计算机系', 'A301');
INSERT INTO `department` VALUES ('D002', '软件工程系', 'A302');
INSERT INTO `department` VALUES ('D003', '网络工程系', 'A303');

-- 插入学生表示例数据：4 条
INSERT INTO `student` VALUES ('2023000001', '张三', '男', 20, 'D001');
INSERT INTO `student` VALUES ('2023000002', '李四', '女', 21, 'D001');
INSERT INTO `student` VALUES ('2023000003', '王五', '男', 20, 'D002');
INSERT INTO `student` VALUES ('2023000004', '赵六', '女', 22, 'D003');

-- 插入课程表示例数据：4 条
INSERT INTO `course` VALUES ('C00001', '数据库系统', 3.5, 'D001');
INSERT INTO `course` VALUES ('C00002', '计算机网络', 3.0, 'D001');
INSERT INTO `course` VALUES ('C00003', '软件工程', 3.0, 'D002');
INSERT INTO `course` VALUES ('C00004', '网络安全', 2.5, 'D003');

-- 基本检查
SELECT * FROM `department`;
SELECT * FROM `student`;
SELECT * FROM `course`;
