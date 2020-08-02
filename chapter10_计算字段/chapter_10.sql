USE test;
/*存储在数据库表中的数据一般不是应用程序所需要的格式,
需要用计算字段转换，计算字段是运行时在SELECT语句内创建的。*/

/*拼接字段
1.拼接同一个表中的两列， 使用Concat()*/
SELECT Concat(vend_name, ' (', vend_country, ') ')
FROM vendors
ORDER BY vend_name;

#通过RTrim(), LTrim()去掉串左右空格， Trim()去掉两边空格
SELECT Concat(RTrim(vend_name), ' (', RTrim(vend_country), ') ') AS
vend_title # AS 赋予别名
FROM vendors
ORDER BY vend_name;

/*算术计算,用+ - * / */
SELECT prod_id, quantity, item_price, item_price * quantity AS expand_price
FROM orderitems
WHERE order_num = 20005;