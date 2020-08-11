USE exercise;
SHOW TABLES;
/*
-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数
SELECT Student.*, c_id, s_score
FROM Student
INNER JOIN Score 
ON Student.s_id IN(
    SELECT sc1.s_id
    FROM Score AS sc1, Score AS sc2
    WHERE sc1.c_id = '01' 
        AND sc2.c_id = '02'
        AND sc1.s_id = sc2.s_id
        AND sc1.s_score > sc2.s_score
) AND Student.s_id = Score.s_id;

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
SELECT Student.s_id, Student.s_name, AVG(s_score) AS average_score
FROM Score
INNER JOIN Student
ON Student.s_id = Score.s_id
GROUP BY Score.s_id
HAVING AVG(s_score) >= 60;

-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
		-- (包括有成绩的和无成绩的)
SELECT Student.s_id, Student.s_name, AVG(s_score) AS average_score
FROM Score
INNER JOIN Student
ON Student.s_id = Score.s_id
GROUP BY Score.s_id
HAVING AVG(s_score) < 60
UNION
SELECT Student.s_id, Student.s_name, 0 AS average_score
FROM Student
WHERE s_id NOT IN(
    SELECT s_id FROM Score
);

-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
SELECT Student.s_id, Student.s_name, Count(c_id) AS totalcourse, Sum(s_score) AS totalscore
FROM Student
INNER JOIN Score
ON Student.s_id = Score.s_id
GROUP BY Score.s_id
UNION
SELECT s_id, s_name, 0 AS totalcourse, 0 AS totalscore
FROM Student
WHERE s_id NOT IN(
    SELECT s_id FROM Score
)
ORDER BY totalscore DESC;

-- 6、查询"李"姓老师的数量 
SELECT Count(t_id) AS teachercount
FROM Teacher
WHERE t_name REGEXP '李.';
*/
-- 7、查询学过"张三"老师授课的同学的信息 
SELECT Student.*
FROM Score
INNER JOIN Course
ON Score.c_id = Course.c_id AND
Course.t_id IN (
    SELECT t_id FROM Teacher WHERE t_name = '张三'
)
INNER JOIN Student
ON Score.s_id = Student.s_id;

-- 8、查询没学过"张三"老师授课的同学的信息 
SELECT Student.*
FROM Student
WHERE s_id NOT IN(
    SELECT  Student.s_id
    FROM Score
    INNER JOIN Course
    ON Score.c_id = Course.c_id AND
    Course.t_id IN (
        SELECT t_id FROM Teacher WHERE t_name = '张三'
    )
    INNER JOIN Student
    ON Score.s_id = Student.s_id);

-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
SELECT *
FROM Student
WHERE s_id IN(
    SELECT Sc1.s_id
    FROM Score AS Sc1, Score AS Sc2
    WHERE Sc1.c_id = '01' AND Sc2.c_id = '02'
    AND Sc1.s_id = Sc2.s_id
);
