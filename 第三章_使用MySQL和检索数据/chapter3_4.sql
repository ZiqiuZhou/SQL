SHOW DATABASES;
USE TEST;
SHOW TABLES;
SHOW COLUMNS FROM customers; # SHOW COLUMNS要求给出表名
DESCRIBE customers; #功能如上

/*SELECT语句*/
SELECT prod_id, vend_id #可以限定表明: products.prod_id
FROM products;

/*DISTINCT 去重*/
SELECT DISTINCT prod_id # DISTINCT过滤掉重复值(只适用单列)
FROM products; 
LIMIT 5;

