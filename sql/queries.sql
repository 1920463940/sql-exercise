-- 使用前请在 Navicat 中选择 school_db 数据库
USE `school_db`;

-- 1. 查看三张表
SELECT * FROM `department`;
SELECT * FROM `student`;
SELECT * FROM `course`;

-- 2. INNER JOIN：查询学生姓名、学号及所属系
SELECT
    s.student_id AS 学号,
    s.student_name AS 姓名,
    d.dept_name AS 所属系
FROM student AS s
INNER JOIN department AS d
    ON s.dept_id = d.dept_id;

-- 3. 查看各系开设课程及学分
SELECT
    d.dept_name AS 开课系,
    c.course_name AS 课程名称,
    c.credits AS 学分
FROM department AS d
INNER JOIN course AS c
    ON d.dept_id = c.dept_id
ORDER BY d.dept_id, c.course_id;

-- 4. 外键检查：查看实际建表定义
SHOW CREATE TABLE student;
SHOW CREATE TABLE course;
