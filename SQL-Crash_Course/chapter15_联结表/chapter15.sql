USE test;
/*联结表join， 联结条件用ON而不是WHERE*/

# INNER JOIN, 等值联结
SELECT vend_name, prod_name, prod_price
FROM vendors INNER JOIN products
ON vendors.vend_id = products.vend_id;

#多表联结
SELECT prod_name, vend_name, prod_price, quantity
FROM products # products中并没有quantity,只有联结后的表中才有
INNER JOIN orderitems
ON orderitems.prod_id = products.prod_id
INNER JOIN vendors
ON products.vend_id = vendors.vend_id
WHERE orderitems.order_num = 20005;


# 用子查询返回订购产品TNT2的客户列表可以改成等值联结
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (SELECT cust_id
                  FROM orders
                  WHERE order_num IN (SELECT order_num
                                      FROM orderitems
                                      WHERE prod_id = 'TNT2'));

SELECT cust_name, cust_contact
FROM orders
INNER JOIN customers
ON orders.cust_id = customers.cust_id
INNER JOIN orderitems
ON orders.order_num = orderitems.order_num
WHERE orderitems.prod_id = 'TNT2';

/*另外一些联结方式*/
/*
自联结，不涉及别的表：发现某物品prod_id = DTNTR存在问题，
因此想知道生产该物品的供应商(vend_id)生产的其他物品是否
也存在这些问题.
其他物品代表的prod_id和prod_name都在同一个表中
*/
SELECT p1.vend_id, p1.prod_id, p1.prod_name
FROM products AS p1, products AS p2
WHERE p1.vend_id = p2.vend_id
AND p2.prod_id = 'DTNTR';

#外联结 LEFT/RIGHT OUTER JOIN, LEFT/RIGHT需要指定
SELECT customers.cust_id, orders.order_num
FROM customers LEFT OUTER JOIN orders
ON orders.cust_id = customers.cust_id;

# join和groupby组合使用
SELECT customers.cust_name, 
       customers.cust_id,
       COUNT(orders.order_num) AS num_ord
FROM customers INNER JOIN orders
ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_id
ORDER BY cust_name;