USE test;

/*WHERE子句过滤数据*/
SELECT vend_id, prod_name, prod_price
FROM products
WHERE prod_price < 10 AND vend_id = 1003;

#范围值检查使用BETWEEN
SELECT prod_name, prod_price
FROM products
WHERE prod_price BETWEEN 5 AND 10; # 使用AND或OR操作符

/*用WHERE检查某列NULL值， 某列中
NULL值所在行无法通过WHERE中!= 某个值过滤出来*/
SELECT cust_id
FROM customers
WHERE cust_email IS NOT NULL;

#使用()决定AND和OR操作符的计算次序
SELECT vend_id, prod_name, prod_price
FROM products
WHERE (vend_id = 1002 OR vend_id = 1003) AND prod_price >= 10;

# 用IN取代 OR, 执行速度更快
SELECT vend_id, prod_name, prod_price
FROM products
WHERE vend_id IN (1002, 1003)
ORDER BY prod_name;

# NOT对IN, BETWEEN取反
SELECT vend_id, prod_name, prod_price
FROM products
WHERE vend_id NOT IN (1002, 1003)
ORDER BY prod_name;

