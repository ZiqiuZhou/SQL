USE test;

/*利用子查询进行过滤
需要列出订购物品TNT2的所有客户
1.检索包含物品TNT2的所有订单的编号。
2.检索具有前一步骤列出的订单编号的所有客户的ID。
3.检索前一步骤返回的所有客户ID的客户信息。
*/
# 包含物品TNT2的所有订单的编号
SELECT order_num
FROM orderitems
WHERE prod_id = 'TNT2'; # order_num 结果为20005和20007
#检索具有前一步骤列出的订单编号的所有客户的ID
SELECT cust_id
FROM orders
WHERE order_num IN (20005, 20007); # cust_id为10001和10004
#检索前一步骤返回的所有客户ID的客户信息
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (10001, 10004);

#合成子查询
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (SELECT cust_id
                  FROM orders
                  WHERE order_num IN (SELECT order_num
                                      FROM orderitems
                                      WHERE prod_id = 'TNT2'));

/*显示customers表中每个客户的订单总数。
订单与相应的客户ID存储在orders表中, 纽带是cust_id*/
SELECT cust_name, cust_state, (
    SELECT COUNT(*) 
    FROM orders
    WHERE orders.cust_id = customers.cust_id
) AS orders
FROM customers
ORDER BY cust_name;

