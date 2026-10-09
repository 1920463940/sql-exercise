-- 实验查询；先执行 sql/school_db.sql 创建数据后，再逐段运行
USE `school_db`;

-- 1. 查看四张表
SELECT * FROM `department`;
SELECT * FROM `student`;
SELECT * FROM `course` ORDER BY `course_id`;
SELECT * FROM `sc`;

-- 2. INNER JOIN：学生与所属系
SELECT s.student_id AS 学号, s.student_name AS 姓名, d.dept_name AS 所属系
FROM student AS s
INNER JOIN department AS d ON s.dept_id = d.dept_id;

-- 3. SC 多表连接：学生、课程和成绩
SELECT s.student_name AS 学生姓名, c.course_name AS 课程名称, sc.grade AS 成绩
FROM sc
INNER JOIN student AS s ON sc.student_id = s.student_id
INNER JOIN course AS c ON sc.course_id = c.course_id
ORDER BY sc.student_id, sc.course_id;

-- 4. 自连接：显示课程与其直接先修课程（含无先修课程）
SELECT c.course_id AS 课程编号, c.course_name AS 课程名称,
       p.course_name AS 先修课程
FROM course AS c
LEFT JOIN course AS p ON c.cpno = p.course_id
ORDER BY c.course_id;

-- 5. 两次自连接：查找存在第二级先修关系的课程
-- 如数据库系统 -> 数据结构 -> 程序设计基础
SELECT c.course_name AS 当前课程, p.course_name AS 直接先修课,
       pp.course_name AS 间接先修课
FROM course AS c
INNER JOIN course AS p ON c.cpno = p.course_id
INNER JOIN course AS pp ON p.cpno = pp.course_id
ORDER BY c.course_id;
