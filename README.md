# MySQL + Navicat 教务数据库实践：四表设计、选课成绩与先修课程

> 《数据库系统基础》课程实践记录｜MySQL 8.0.43 + Navicat Premium + GitHub

本项目以一个简化的数据库 school_db 为例，记录从连接 MySQL、设计关系模式，到使用 Navicat 创建数据表、配置主外键、插入数据、执行连接查询以及生成关系模型图的全过程。

项目完成系表、学生表和课程表的基础设计，增加选课表 sc，并在课程表中加入先修课编号 cpno。

**项目文件：**

- [完整建表与演示数据 SQL](sql/school_db.sql)
- [查询练习 SQL](sql/queries.sql)
- [Navicat 最新原始 SQL 导出](sql/navicat-exports/school_db_latest.sql)



## 一、实验目的与环境

本实验主要学习以下内容：

1. **一期：三表基础练习**——创建 department、student、course 三张表，完成主键、外键、唯一索引以及基础 INNER JOIN 查询。
2. **二期：选课与先修课扩展**——增加 sc 选课表与 course.cpno 字段，设置联合主键和自引用外键，使用 LEFT JOIN 进行课程先修关系查询。

实验环境如下：

| 项目 | 使用环境 |
| --- | --- |
| 操作系统 | Windows |
| 数据库 | MySQL 8.0.43 |
| 管理工具 | Navicat Premium |
| 数据库连接 | localhost:3306 |
| 数据库名称 | school_db |
| 字符集 | utf8mb4 |
| 排序规则 | utf8mb4_0900_ai_ci |

本项目的学生、课程、系信息均为课程实践所用的演示数据。

## 二、关系模式与字段设计

数据库共设计四张表：department（系）、student（学生）、course（课程）、sc（选课成绩）。

### 2.1 系表 department

| 字段 | 类型 | 约束 | 含义 |
| --- | --- | --- | --- |
| dept_id | CHAR(4) | 主键、非空 | 系编号 |
| dept_name | VARCHAR(50) | 非空、唯一索引 | 系名称 |
| office | VARCHAR(100) | 允许 NULL | 办公室 |

系表通过 dept_id 唯一标识一条记录，并为 dept_name 设置唯一索引 uq_dept_name，避免系名称重复。

![Navicat department 唯一索引设置](images/02-department-unique-index.png)

### 2.2 学生表 student

| 字段 | 类型 | 约束 | 含义 |
| --- | --- | --- | --- |
| student_id | CHAR(10) | 主键、非空 | 学号 |
| student_name | VARCHAR(30) | 非空 | 学生姓名 |
| gender | CHAR(1) | 允许 NULL | 性别 |
| age | TINYINT UNSIGNED | 允许 NULL | 年龄 |
| dept_id | CHAR(4) | 外键、非空 | 所属系编号 |

student.dept_id 引用 department.dept_id。删除规则为 RESTRICT，更新规则为 CASCADE：当某个系仍被学生引用时不能直接删除该系；系编号更新时，相关学生记录中的系编号也会随之更新。

![学生表主键和外键 SQL 预览](images/03-student-table-design.png)

### 2.3 课程表 course（含先修课）

| 字段 | 类型 | 约束 | 含义 |
| --- | --- | --- | --- |
| course_id | CHAR(6) | 主键、非空 | 课程编号 |
| course_name | VARCHAR(60) | 非空 | 课程名称 |
| credits | DECIMAL(3,1) | 非空 | 学分 |
| dept_id | CHAR(4) | 外键、非空 | 开课系编号 |
| cpno | CHAR(6) | 自引用外键、允许 NULL | 直接先修课编号 |

course.dept_id 引用 department.dept_id，用于表示课程所属的开课系。

在第二阶段，课程表新增 cpno 字段，引用同一张表中的 course_id。这种关联称为**自引用外键**。其删除规则为 SET NULL，更新规则为 CASCADE。当课程没有直接先修课时，cpno 可以为 NULL。

本设计中，每门课程最多记录一门直接先修课。如果需要为同一门课程记录多门先修课，就应该进一步创建独立的“课程—先修课程”关系表。

![初始课程表设计（新增 cpno 之前）](images/04-course-table-design.png)

### 2.4 选课表 sc（联合主键）

| 字段 | 类型 | 约束 | 含义 |
| --- | --- | --- | --- |
| student_id | CHAR(10) | 联合主键成员、外键 | 学号 |
| course_id | CHAR(6) | 联合主键成员、外键 | 课程编号 |
| grade | DECIMAL(5,2) | 允许 NULL | 成绩 |

sc 表通过 student_id 和 course_id **共同组成联合主键**，一个学生不能在此表中重复登记同一门课程，但可以选修多门课程；同一门课程也可以被多名学生选修。

两个外键分别为：

- sc.student_id 引用 student.student_id。
- sc.course_id 引用 course.course_id。

这张选课表将学生与课程之间的多对多联系拆分为两个一对多联系，同时保存成绩。

![SC 表联合主键与两个外键的 SQL 预览](images/10-sc-design.png)

### 2.5 五条外键关系

| 引用方字段 | 被引用方字段 | 含义 |
| --- | --- | --- |
| student.dept_id | department.dept_id | 学生所属系 |
| course.dept_id | department.dept_id | 课程开课系 |
| sc.student_id | student.student_id | 选课学生 |
| sc.course_id | course.course_id | 所选课程 |
| course.cpno | course.course_id | 课程的直接先修课 |

**外键引用方向的判断方法：** 外键定义在引用方表中，其值必须与被引用表的合法主键值对应（允许为 NULL 的外键字段除外）。例如，sc.student_id 引用 student.student_id，而不是反过来。

## 三、Navicat 逆向建模：四表关系图

完成四张表及五条外键约束后，使用 Navicat 的“逆向数据库到模型”功能生成关系图。

![Navicat 四表关系图（含 SC 联合主键与课程自引用）](images/14-four-table-er.png)

图中的黄色钥匙表示主键。sc 表有两个黄色钥匙，表示 student_id 和 course_id 共同组成联合主键；课程表的 fk_course_prerequisite 对应课程先修关系的自引用外键。

为便于对照扩展过程，仍保留[第一阶段三表关系图](images/09-er-diagram.png)。

## 四、操作步骤与实际数据

### 4.1 建库与建表

首先确认 Windows 中的 MySQL80 服务已经运行，在 Navicat 中连接本机 MySQL，创建 school_db 数据库，并设置字符集和排序规则。随后依次创建表、设置主键和唯一索引、配置外键。

也可以通过以下 SQL 创建数据库：

```sql
CREATE DATABASE IF NOT EXISTS school_db
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE school_db;
```

完整的四表建表与数据脚本见 [sql/school_db.sql](sql/school_db.sql)。

### 4.2 系、学生与课程基础数据

第一阶段共插入 3 条系数据、4 条学生数据和 4 条课程数据，随后在第二阶段新增两门基础课程，因此最终课程表共有 6 条记录。

**系表查询结果：**

![department 数据查询结果](images/05-department-query.png)

**学生表查询结果：**

![student 数据查询结果](images/06-student-query.png)

**第一阶段课程表查询结果：**

![course 初始数据查询结果](images/07-course-query.png)

### 4.3 SC 选课成绩数据

在学生和课程已经存在的前提下，执行下面的插入语句：

```sql
INSERT INTO sc (student_id, course_id, grade) VALUES
('2023000001', 'C00001', 85.50),
('2023000001', 'C00002', 92.00),
('2023000002', 'C00001', 88.00),
('2023000002', 'C00003', 90.50),
('2023000003', 'C00003', 86.00),
('2023000004', 'C00004', 91.00);
```

执行 SELECT 查询后，sc 表共有 6 条选课记录。由于采用了联合主键，同一学生与课程的编号组合不能重复插入。

![SC 表数据查询结果](images/11-sc-data.png)

### 4.4 课程先修关系数据

先增加 C00005（程序设计基础）和 C00006（数据结构），再依次设置已有课程的先修关系：

```sql
UPDATE course
SET cpno = 'C00005'
WHERE course_id = 'C00006';

UPDATE course
SET cpno = 'C00006'
WHERE course_id IN ('C00001', 'C00002');

UPDATE course
SET cpno = 'C00002'
WHERE course_id = 'C00004';
```

| 课程 | 直接先修课程 |
| --- | --- |
| 数据库系统 | 数据结构 |
| 计算机网络 | 数据结构 |
| 软件工程 | 无 |
| 网络安全 | 计算机网络 |
| 程序设计基础 | 无 |
| 数据结构 | 程序设计基础 |

例如：程序设计基础 → 数据结构 → 数据库系统，是一条完整的课程依赖路径。

![课程先修编号查询结果](images/12-course-prerequisites.png)

## 五、SQL 查询练习

### 5.1 INNER JOIN：查询学生所属系

学生表只存储所属系编号，要获取系名称，需要将 student 与 department 两张表连接。

```sql
SELECT
    s.student_id AS 学号,
    s.student_name AS 姓名,
    d.dept_name AS 所属系
FROM student AS s
INNER JOIN department AS d
    ON s.dept_id = d.dept_id;
```

![INNER JOIN 查询结果](images/08-inner-join.png)

INNER JOIN 只保留满足连接条件的记录。ON 用于指定两表之间如何匹配；WHERE 一般用于进一步筛选记录。在外连接中，ON 和 WHERE 的位置可能影响最终结果。

### 5.2 三表连接：查询学生、课程和成绩

通过 sc 连接 student 和 course，可以把选课记录中的学号、课程编号转换成更直观的学生姓名、课程名称，并同时查询成绩。

```sql
SELECT
    s.student_name AS 学生姓名,
    c.course_name AS 课程名称,
    sc.grade AS 成绩
FROM sc
INNER JOIN student AS s
    ON sc.student_id = s.student_id
INNER JOIN course AS c
    ON sc.course_id = c.course_id;
```



### 5.3 LEFT JOIN 自连接：课程及直接先修课

为了显示先修课的**课程名称**而不只是课程编号，需要让 course 表与自身连接。通过两个别名，将同一张表分为“当前课程”和“先修课程”两个角色。

```sql
SELECT
    c.course_id AS 课程编号,
    c.course_name AS 课程名称,
    p.course_name AS 先修课程
FROM course AS c
LEFT JOIN course AS p
    ON c.cpno = p.course_id
ORDER BY c.course_id;
```

使用 LEFT JOIN 的原因是：即使某门课程没有先修课，也要保留这门课程。此时查询结果中的先修课程名称为 NULL。

![LEFT JOIN 课程自连接查询结果](images/13-course-self-join.png)

### 5.4 扩展练习：间接先修课查询

当课程之间存在多级依赖关系时，可以连续进行两次自连接，查询某门课程的直接先修课及其先修课。

```sql
SELECT
    c.course_name AS 当前课程,
    p.course_name AS 直接先修课,
    pp.course_name AS 间接先修课
FROM course AS c
INNER JOIN course AS p
    ON c.cpno = p.course_id
INNER JOIN course AS pp
    ON p.cpno = pp.course_id;
```

例如，数据库系统的直接先修课是数据结构，间接先修课是程序设计基础。

## 六、实验总结

通过这次实践，我完成了从三表模型到四表模型的扩展，并进一步理解了以下知识点：

1. **联合主键**：sc 表的 student_id 与 course_id 共同唯一标识一条选课记录。某一字段可以重复，但二者的组合不能重复。
2. **外键的引用方向**：sc.student_id 引用 student.student_id，sc.course_id 引用 course.course_id。由引用方保存被引用方定义的编号，从而维护参照完整性。
3. **自引用外键与自连接**：course.cpno 指向 course.course_id；进行查询时，通过两个表别名分别表示当前课程与先修课程，并使用 LEFT JOIN 保留没有先修课的课程。
4. **关系模型的可视化**：Navicat 的逆向建模功能直观地展示了系、学生、课程、选课成绩四张表之间的五条外键关系。

本实验实际完成了建表、设置主键与外键、插入测试数据、基础 INNER JOIN 查询及先修课程 LEFT JOIN 自连接查询。

## 七、项目文件目录

```text
sql-exercise/
├── README.md
├── images/
│   ├── 01-database-created.png
│   ├── 02-department-unique-index.png
│   ├── 03-student-table-design.png
│   ├── 04-course-table-design.png
│   ├── 05-department-query.png
│   ├── 06-student-query.png
│   ├── 07-course-query.png
│   ├── 08-inner-join.png
│   ├── 09-er-diagram.png
│   ├── 10-sc-design.png
│   ├── 11-sc-data.png
│   ├── 12-course-prerequisites.png
│   ├── 13-course-self-join.png
│   └── 14-four-table-er.png
├── sql/
│   ├── school_db.sql
│   ├── queries.sql
│   └── navicat-exports/
│       ├── department.sql
│       ├── student.sql
│       ├── course.sql
│       └── school_db_latest.sql
└── PUSH_GUIDE.md
```

