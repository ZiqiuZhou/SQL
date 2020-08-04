USE test;

/*GROUP BY*/
# 按vend_id排序并分组数据, SELECT中除了计算语句涉及的列，
# 每个列都必须在GROUP BY中出现, GROUP BY中的列必须
#是SELECT中的每个选择列
SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id; 

# GROUP BY子句必须出现在WHERE子句之后，ORDER BY子句之前
SELECT vend_id, COUNT(*) AS num_prods
FROM products
WHERE prod_price > 5
GROUP BY vend_id;

/*过滤分组, HAVING: WHERE过滤行, HAVING过滤GROUP BY后的分组
WHERE在数据分组前进行过滤，HAVING在数据分组后进行过滤
*/
SELECT vend_id, COUNT(*) AS num_prods
FROM products
WHERE prod_price > 5
GROUP BY vend_id
HAVING num_prods >= 2;

/*一般在使用GROUP BY子句时，应该也给
出ORDER BY子句, 这是保证数据正确排序的唯一方法*/
SELECT order_num, SUM(quantity * item_price) AS ordertotal
FROM orderitems
GROUP BY order_num
HAVING ordertotal >= 50
ORDER BY ordertotal;