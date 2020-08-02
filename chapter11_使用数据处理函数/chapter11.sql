USE test;
 /*文本处理函数：
Left() 返回串左边的字符
Length() 返回串的长度
Locate() 找出串的一个子串
Lower() 将串转换为小写
LTrim() 去掉串左边的空格
Right() 返回串右边的字符
RTrim() 去掉串右边的空格
Soundex() 返回串的SOUNDEX值
SubString() 返回子串的字符
Upper() 将串转换为大写*/

/* 日期和时间处理函数：
Date() 返回日期时间的日期部分(精确到年月日)
DateDiff() 计算两个日期之差
Day() 返回一个日期的天数部分
DayOfWeek() 对于一个日期，返回对应的星期几
Hour() 返回一个时间的小时部分
Minute() 返回一个时间的分钟部分
Month() 返回一个日期的月份部分
Now() 返回当前日期和时间
Second() 返回一个时间的秒部分
Time() 返回一个日期时间的时间部分
Year() 返回一个日期的年份部分
*/
Select cust_id, order_num
FROM orders
WHERE Date(order_date) = '2005-09-01'; #精确到年月日

#检索到某年某月中的所有订单
Select cust_id, order_num, order_date
FROM orders
WHERE Year(order_date) = 2005 AND Month(order_date) = 9;


/*数值处理函数：
Abs() 返回一个数的绝对值
Exp() 返回一个数的指数值
Mod() 返回除操作的余数
Sin() 返回一个角度的正弦
Sqrt() 返回一个数的平方根
Tan() 返回一个角度的正切
*/

/*聚集函数(aggregate function):
AVG() 返回某列的平均值
COUNT() 返回某列的行数
MAX() 返回某列的最大值
MIN() 返回某列的最小值
SUM() 返回某列值之和
*/

# AVG()确定特定几行的平均值， 一个AVG()函数只能用于一列(忽略NULL)
SELECT AVG(prod_price) AS avg_price
FROM products
WHERE vend_id = 1003;

#只考虑不同价格的平均
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM products
WHERE vend_id = 1003;

/* COUNT()*/
# COUNT(*)对全表的行数计数，无论是否有NULL值
SELECT COUNT(*) AS num_cust
FROM customers;

SELECT COUNT(cust_email) AS num_cust
FROM customers;

/*MAX()：找出最大数值或日期*/
SELECT MAX(order_date)
FROM orders;

/*SUM()*/
SELECT SUM(item_price * quantity) AS total_price
FROM orderitems
WHERE order_num = 20005;


/*组合聚合函数*/
SELECT COUNT(*) AS num_items,
    MIN(prod_price) AS price_min,
    MAX(prod_price) AS price_max,
    AVG(prod_price) AS price_avg
FROM products;

