USE exercise;
SHOW TABLES;
# 17 19
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
SELECT *
FROM Student
WHERE s_id NOT IN(
    SELECT s_id
    FROM Score
    INNER JOIN Course
    ON Score.c_id = Course.c_id AND
    Course.t_id IN (
        SELECT t_id FROM Teacher WHERE t_name = '张三'
    ));

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

-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息 
SELECT *
FROM Student
WHERE s_id IN(
SELECT s_id
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

-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名 
SELECT *
FROM Student
WHERE s_id NOT IN(
    SELECT s_id
    FROM Score
    INNER JOIN Course
    ON Score.c_id = Course.c_id AND
    Course.t_id IN (
        SELECT t_id FROM Teacher WHERE t_name = '张三')
    );

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 
SELECT Student.s_id, Student.s_name, AVG(s_score) AS average_score
FROM Student
INNER JOIN Score
ON Student.s_id = Score.s_id AND s_score < 60
GROUP BY Score.s_id
HAVING COUNT(s_score) >= 2;

-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
SELECT Student.*, s_score
FROM Student
INNER JOIN Score
ON Student.s_id = Score.s_id AND s_score < 60 AND c_id = '01'
ORDER BY s_score DESC;

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩

-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
--及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90

CREATE VIEW largerthan60 AS
SELECT c_id, 
    COUNT(s_score) / (
        SELECT COUNT(s_score)
        FROM Score AS sc1 
        GROUP BY sc1.c_id 
        HAVING sc1.c_id = Score.c_id) AS ratio60
FROM Score
WHERE s_score >= 60
GROUP BY c_id;

CREATE VIEW largerthan70 AS
SELECT c_id, 
    COUNT(s_score) / (
        SELECT COUNT(s_score)
        FROM Score AS sc1 
        GROUP BY sc1.c_id 
        HAVING sc1.c_id = Score.c_id) AS ratio70
FROM Score
WHERE s_score >= 70 AND s_score < 80
GROUP BY c_id;

CREATE VIEW largerthan80 AS
SELECT c_id, 
    COUNT(s_score) / (
        SELECT COUNT(s_score)
        FROM Score AS sc1 
        GROUP BY sc1.c_id 
        HAVING sc1.c_id = Score.c_id) AS ratio80
FROM Score
WHERE s_score >= 80 AND s_score < 90
GROUP BY c_id;

CREATE VIEW largerthan90 AS
SELECT c_id, 
    COUNT(s_score) / (
        SELECT COUNT(s_score)
        FROM Score AS sc1 
        GROUP BY sc1.c_id 
        HAVING sc1.c_id = Score.c_id) AS ratio90
FROM Score
WHERE s_score >= 90
GROUP BY c_id;

CREATE VIEW partView AS
SELECT Score.c_id, Course.c_name, MAX(s_score), MIN(s_score), AVG(s_score)
FROM Score
INNER JOIN Course
ON Score.c_id = Course.c_id
GROUP BY Score.c_id;

SELECT partView.*, largerthan60.ratio60, largerthan70.ratio70,
    largerthan80.ratio80, largerthan90.ratio90
FROM partView
LEFT OUTER JOIN largerthan60
ON largerthan60.c_id = partView.c_id
LEFT OUTER JOIN largerthan70
ON largerthan70.c_id = partView.c_id
LEFT OUTER JOIN largerthan80
ON largerthan80.c_id = partView.c_id
LEFT OUTER JOIN largerthan90
ON largerthan90.c_id = partView.c_id;


-- 19、按各科成绩进行排序，并显示排名
SELECT * FROM (
SELECT c_id, s_score, @rank1 := @rank1 + 1 AS score_Rank
FROM Score a, (SELECT @rank1 := 0) b
WHERE c_id = '01'
ORDER BY s_score DESC) AS Score1
UNION
SELECT * FROM (
SELECT c_id, s_score, @rank2 := @rank2 + 1 AS score_Rank
FROM Score a, (SELECT @rank2 := 0) b
WHERE c_id = '02'
ORDER BY s_score DESC) AS Score2
UNION
SELECT * FROM (
SELECT c_id, s_score, @rank3 := @rank3 + 1 AS score_Rank
FROM Score a, (SELECT @rank3 := 0) b
WHERE c_id = '03'
ORDER BY s_score DESC) AS Score3;

-- 20、查询学生的总成绩并进行排名
SELECT s_id, SUM(s_score) AS totalscore, @rank := @rank + 1 AS score_Rank
FROM Score a, (SELECT @rank := 0) b
GROUP BY s_id
ORDER BY totalscore DESC;

-- 21、查询不同老师所教不同课程平均分从高到低显示 
SELECT Teacher.t_id, Course.c_id, AVG(Score.s_score) AS average_score
From Course
INNER JOIN Teacher ON Teacher.t_id = Course.t_id
INNER JOIN Score ON Course.c_id = Score.c_id
GROUP BY c_id
ORDER BY average_score DESC;

-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
SELECT Student.*, wholetable.s_score
    FROM(
    SELECT s_id, s_score
    FROM (
        SELECT s_id, c_id, s_score, @rank1 := @rank1 + 1 AS score_Rank
        FROM Score a, (SELECT @rank1 := 0) b
        WHERE c_id = '01' 
        ORDER BY s_score DESC) AS Score1
    WHERE Score1.score_Rank IN (2, 3)
    UNION
    SELECT s_id, s_score
    FROM (
        SELECT s_id, c_id, s_score, @rank2 := @rank2 + 1 AS score_Rank
        FROM Score a, (SELECT @rank2 := 0) b
        WHERE c_id = '02'
        ORDER BY s_score DESC) AS Score2
    WHERE Score2.score_Rank IN (2, 3)
    UNION
    SELECT s_id, s_score
    FROM (
        SELECT s_id, c_id, s_score, @rank3 := @rank3 + 1 AS score_Rank
        FROM Score a, (SELECT @rank3 := 0) b
        WHERE c_id = '03'
        ORDER BY s_score DESC) AS Score3
    WHERE Score3.score_Rank IN (2, 3)) AS wholetable
INNER JOIN Student
ON Student.s_id = wholetable.s_id;
*/
-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
SELECT Score.c_id, Course.c_name
FROM Score
LEFT OUTER JOIN Course
ON Score.c_id = Course.c_id 
GROUP BY Score.c_id, Course.c_name;

SELECT Course.c_id, Course.c_name, over85.count85, over70.count70, over60.count60, over0.count0
 FROM Course
LEFT OUTER JOIN (SELECT c_id, COUNT(s_score) AS count85 FROM Score Where s_score > 85
    GROUP BY c_id) AS over85
ON Course.c_id = over85.c_id
LEFT OUTER JOIN 
    (SELECT c_id, COUNT(s_score) AS count70 FROM Score Where s_score > 70 AND s_score <= 85
    GROUP BY c_id) AS over70
ON Course.c_id = over70.c_id
LEFT OUTER JOIN 
    (SELECT c_id, COUNT(s_score) AS count60 FROM Score Where s_score >= 60 AND s_score <= 70
    GROUP BY c_id) AS over60
ON Course.c_id = over60.c_id
LEFT OUTER JOIN 
    (SELECT c_id, COUNT(s_score) AS count0 FROM Score Where s_score < 60
    GROUP BY c_id) AS over0
ON Course.c_id = over0.c_id;

-- 24、查询学生平均成绩及其名次 
SELECT a.*, @rank := @rank + 1 AS score_Rank FROM 
    (SELECT s_id, AVG(s_score) AS average_score
    FROM Score 
    GROUP BY s_id
    ORDER BY average_score DESC) AS a, (SELECT @rank := 0) b;

-- 25、查询各科成绩前三名的记录
SELECT s_id, c_id, @rank := @rank + 1 AS score_Rank
FROM Score, (SELECT @rank := 0) b
WHERE c_id = '01'
ORDER BY s_score DESC;




