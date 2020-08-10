USE exercise;
SHOW TABLES;
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
SELECT Student.s_id, Student.s_name, AVG(s_score)
FROM Score
INNER JOIN Student
ON Student.s_id = Score.s_id
GROUP BY Score.s_id
HAVING AVG(s_score) >= 60;
