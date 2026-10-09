-- 基于 Navicat 实际导出整理的可复现教学脚本（MySQL 8.0.43）
-- 注意：此脚本会先删除 school_db 中同名的 4 张表及其数据，仅用于独立练习库！
CREATE DATABASE IF NOT EXISTS `school_db`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `school_db`;

-- 按外键依赖关系删除子表 -> 父表
DROP TABLE IF EXISTS `sc`;
DROP TABLE IF EXISTS `course`;
DROP TABLE IF EXISTS `student`;
DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
    `dept_id` CHAR(4) NOT NULL,
    `dept_name` VARCHAR(50) NOT NULL,
    `office` VARCHAR(100),
    PRIMARY KEY (`dept_id`),
    UNIQUE KEY `uq_dept_name` (`dept_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `student` (
    `student_id` CHAR(10) NOT NULL,
    `student_name` VARCHAR(30) NOT NULL,
    `gender` CHAR(1),
    `age` TINYINT UNSIGNED,
    `dept_id` CHAR(4) NOT NULL,
    PRIMARY KEY (`student_id`),
    CONSTRAINT `fk_student_dept` FOREIGN KEY (`dept_id`)
       REFERENCES `department` (`dept_id`)
       ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `course` (
    `course_id` CHAR(6) NOT NULL,
    `course_name` VARCHAR(60) NOT NULL,
    `credits` DECIMAL(3,1) NOT NULL,
    `dept_id` CHAR(4) NOT NULL,
    `cpno` CHAR(6) DEFAULT NULL,
    PRIMARY KEY (`course_id`),
    CONSTRAINT `fk_course_dept` FOREIGN KEY (`dept_id`)
       REFERENCES `department` (`dept_id`)
       ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_course_prerequisite` FOREIGN KEY (`cpno`)
       REFERENCES `course` (`course_id`)
       ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sc` (
    `student_id` CHAR(10) NOT NULL,
    `course_id` CHAR(6) NOT NULL,
    `grade` DECIMAL(5,2) DEFAULT NULL,
    PRIMARY KEY (`student_id`,`course_id`),
    CONSTRAINT `fk_sc_student` FOREIGN KEY (`student_id`)
       REFERENCES `student` (`student_id`)
       ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_sc_course` FOREIGN KEY (`course_id`)
       REFERENCES `course` (`course_id`)
       ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 先插入被引用的系、学生和课程记录
INSERT INTO `department` (`dept_id`,`dept_name`,`office`) VALUES
 ('D001','计算机系','A301'),('D002','软件工程系','A302'),('D003','网络工程系','A303');

INSERT INTO `student` (`student_id`,`student_name`,`gender`,`age`,`dept_id`) VALUES
 ('2023000001','张三','男',20,'D001'),
 ('2023000002','李四','女',21,'D001'),
 ('2023000003','王五','男',20,'D002'),
 ('2023000004','赵六','女',22,'D003');

-- 先不填 cpno；课程全部插入后再设置自引用外键值
INSERT INTO `course` (`course_id`,`course_name`,`credits`,`dept_id`) VALUES
 ('C00001','数据库系统',3.5,'D001'),
 ('C00002','计算机网络',3.0,'D001'),
 ('C00003','软件工程',3.0,'D002'),
 ('C00004','网络安全',2.5,'D003'),
 ('C00005','程序设计基础',3.0,'D001'),
 ('C00006','数据结构',4.0,'D001');

UPDATE `course` SET `cpno`='C00005' WHERE `course_id`='C00006';
UPDATE `course` SET `cpno`='C00006' WHERE `course_id` IN ('C00001','C00002');
UPDATE `course` SET `cpno`='C00002' WHERE `course_id`='C00004';

INSERT INTO `sc` (`student_id`,`course_id`,`grade`) VALUES
 ('2023000001','C00001',85.50),
 ('2023000001','C00002',92.00),
 ('2023000002','C00001',88.00),
 ('2023000002','C00003',90.50),
 ('2023000003','C00003',86.00),
 ('2023000004','C00004',91.00);
