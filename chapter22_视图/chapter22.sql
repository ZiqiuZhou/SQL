USE test;
/*视图(虚拟表)——整个查询的封装，不包含表中应该有的任何列或数据，它包含的是
一个SQL查询。在视图创建之后，可以用与表基本相同的方式利用它们。
可以对视图执行SELECT操作，过滤和排序数据，将视图联结到其他
视图或表，甚至能添加和更新数据。
*/

# 创建视图隐藏复杂语句

CREATE VIEW productcustomers AS
SELECT cust_name, cust_contact, prod_id
FROM orders 
INNER JOIN customers
ON customers.cust_id = orders.cust_id
INNER JOIN orderitems
ON orderitems.order_num = orders.order_num;

SELECT * FROM productcustomers;

# 查询视图过滤数据
SELECT cust_name, cust_contact
FROM productcustomers
WHERE prod_id = 'TNT2';
/*
#利用视图简化计算字段
CREATE VIEW orderitemsexpand AS
SELECT order_num, prod_id, quantity, item_price,
        quantity * item_price AS expanded_price
FROM orderitems;
*/
SELECT * 
FROM orderitemsexpand
WHERE order_num = 20005;

/*
更新一个视图将更新其基表。如果对视图增加或删除行，
实际上是对其基表增加或删除行。当视图不能确定视图中
的数据来源，则不能更新：
分组（使用GROUP BY和HAVING）；
联结JOIN；
子查询；
并UNION；
聚集函数（Min()、Count()、Sum()等）；
*/