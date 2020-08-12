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

-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
#并集中去掉交集
SELECT *
FROM Student
WHERE s_id IN(
    SELECT s_id
    FROM Score
    WHERE c_id = '01'
) 
AND s_id NOT IN(
    SELECT Sc1.s_id
    FROM Score AS Sc1, Score AS Sc2
    WHERE Sc1.c_id = '01' AND Sc2.c_id = '02'
    AND Sc1.s_id = Sc2.s_id
);

-- 11、查询没有学全所有课程的同学的信息 
#总学生去掉学全的人
SELECT *
FROM Student
WHERE s_id NOT IN(
    SELECT DISTINCT Sc1.s_id
    FROM Score AS Sc1, Score AS Sc2, Score AS Sc3 
    WHERE Sc1.c_id = '01' AND Sc2.c_id = '02' AND Sc3.c_id = '03'
    AND Sc1.s_id = Sc2.s_id AND Sc2.s_id = Sc3.s_id AND Sc1.s_id = Sc3.s_id
);
#或者
SELECT *
FROM Student
WHERE s_id NOT IN(
    SELECT s_id
    FROM Score
    GROUP BY s_id
    HAVING COUNT(c_id) = (SELECT COUNT(c_id) FROM Course) # count不会统计有缺失值的学生
)

-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息
SELECT *
FROM Student
WHERE s_id IN(
    SELECT s_id
    FROM Score
    WHERE c_id NOT IN(
        SELECT c_id
        FROM Score
        WHERE s_id = '01'
    )
    UNION # 并上没有选过课的
    SELECT s_id
    FROM Student
    WHERE s_id NOT IN(
        SELECT s_id
        FROM Score
    )
);
*/
-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息 
SELECT *
FROM Student
WHERE s_id IN(
SELECT DISTINCT s_id
FROM Score
WHERE c_id IN(  # IN 的逻辑等同于OR,筛选出来的是选课在01, 02, 03中间,未必全选
    SELECT c_id
    FROM Score
    WHERE s_id = '01'
)
AND s_id IN(
SELECT s_id
FROM Score
GROUP BY s_id
HAVING COUNT(c_id) = (SELECT COUNT(c_id)
                     FROM Score
                     WHERE s_id = '01')));


