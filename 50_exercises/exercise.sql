USE exercise;
SHOW TABLES;
# 17 19 42

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

-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比

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

-- 26、查询每门课程被选修的学生数 
SELECT c_id, COUNT(s_id)
FROM Score 
GROUP BY c_id;

-- 27、查询出只有两门课程的全部学生的学号和姓名 
SELECT Student.s_id, Student.s_name
FROM Student 
INNER JOIN (
    SELECT s_id
    FROM Score 
    GROUP BY s_id
    HAVING COUNT(c_id) = 2) AS score1
WHERE Student.s_id = score1.s_id;

-- 28、查询男生、女生人数 
SELECT COUNT(s_id) AS count
FROM Student
GROUP BY s_sex;

-- 29、查询名字中含有"风"字的学生信息
SELECT *
FROM Student
WHERE s_name LIKE '%风%';

-- 30、查询同名同性学生名单，并统计同名人数 
SELECT Stu1.s_name, COUNT(Stu1.s_name)
FROM Student AS Stu1, Student AS Stu2
WHERE Stu1.s_name = Stu2.s_name AND Stu1.s_id != Stu2.s_id;

-- 31、查询1990年出生的学生名单
SELECT s_name
FROM Student
WHERE s_birth REGEXP '1990.';

-- 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列 
 SELECT c_id, AVG(s_score) AS average
 FROM Score
 GROUP BY c_id
 ORDER BY  average DESC, c_id;

-- 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩
SELECT  Student.s_id, s_name, AVG(s_score) AS average
FROM Student
INNER JOIN Score
ON Student.s_id = Score.s_id
GROUP BY s_id
HAVING average >= 85;

-- 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 
SELECT Student.s_name, Score.s_score
FROM Student
INNER JOIN Score 
ON Student.s_id = Score.s_id
WHERE Student.s_id IN(
    SELECT s_id FROM Score WHERE s_score < 60)
    AND Score.c_id IN (SELECT c_id FROM Course WHERE c_name = '数学');

-- 35、查询所有学生的课程及分数情况； 
select a.s_id,a.s_name,
					SUM(case c.c_name when '语文' then b.s_score else 0 end) as '语文',
					SUM(case c.c_name when '数学' then b.s_score else 0 end) as '数学',
					SUM(case c.c_name when '英语' then b.s_score else 0 end) as '英语',
					SUM(b.s_score) as  '总分'
		from student a left join score b on a.s_id = b.s_id 
		left join course c on b.c_id = c.c_id 
		GROUP BY a.s_id,a.s_name;

-- 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数； 
SELECT Student.s_name, Score.c_id, s_score
FROM Student
INNER JOIN Score
ON Student.s_id = Score.s_id
AND 
Score.s_id IN(
    SELECT s_id
    FROM Score
    GROUP BY s_id
    HAVING MIN(s_score) > 70
);

-- 37、查询不及格的课程
SELECT DISTINCT Score.c_id, Course.c_name
FROM Score
INNER JOIN Course
ON Score.c_id = Course.c_id
AND s_score < 60;

#--38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名
SELECT Student.s_id, Student.s_name
FROM Student
INNER JOIN Score
ON Student.s_id = Score.s_id
AND Score.c_id = '01' AND Score.s_score >= 80;

-- 39、求每门课程的学生人数 
SELECT COUNT(*) from Score
GROUP BY c_id;

-- 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩
SELECT Student.*, Score.s_score
FROM Student
INNER JOIN Score ON Student.s_id = Score.s_id AND
c_id IN(
    SELECT c_id 
    FROM Course 
    WHERE t_id IN(SELECT t_id FROM Teacher WHERE t_name = '张三')
)
LIMIT 1;

-- 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
SELECT DISTINCT Sc1.s_id, Sc1.c_id, Sc1.s_score
FROM Score AS Sc1, Score AS Sc2
WHERE Sc1.s_score = Sc2.s_score AND Sc1.c_id != Sc2.c_id;	

-- 42、查询每门功成绩最好的前两名 
select a.s_id,a.c_id,a.s_score from score a
		where (select COUNT(1) from score b where b.c_id=a.c_id and b.s_score>=a.s_score)<=2 ORDER BY a.c_id;


-- 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列  
		select c_id,count(*) as total from score GROUP BY c_id HAVING total>5 ORDER BY total,c_id ASC;
		
-- 44、检索至少选修两门课程的学生学号 
		select s_id,count(*) as sel from score GROUP BY s_id HAVING sel>=2;

-- 45、查询选修了全部课程的学生信息 
		select * from student where s_id in(		
			select s_id from score GROUP BY s_id HAVING count(*)=(select count(*) from course));

#--46、查询各学生的年龄-- 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
    SELECT s_birth, (YEAR(NOW()) - YEAR(s_birth) - 
                    (CASE WHEN DATE_FORMAT(NOW(), '%m%d') < DATE_FORMAT(s_birth, '%m%d') then 1 else 0 END)) AS Age 
    FROM Student;

-- 47、查询本周过生日的学生
SELECT * FROM Student WHERE WEEK(NOW()) = WEEK(s_birth);

-- 48、查询下周过生日的学生
SELECT * FROM Student WHERE WEEK(NOW()) + 1 = WEEK(s_birth);

-- 49、查询本月过生日的学生
SELECT * FROM Student WHERE MONTH(NOW()) = MONTH(s_birth);
	
-- 50、查询下月过生日的学生
SELECT * FROM Student WHERE MONTH(NOW()) + 1 = MONTH(s_birth);



