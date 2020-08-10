USE test;

/*组合查询：union, 取并集，逻辑是OR, 默认去除几个查询中重复的行*/

/*组合相同表的两个查询完成的工作与
具有多个WHERE子句条件的单条查询完成的工作相同*/
# 使用多个WHERE过滤
SELECT vend_id, prod_id, prod_price
FROM products
WHERE prod_price <= 5 OR vend_id IN(1001, 1002);

#组合查询等价: UNION中的每个SELECT查询必须包含
#相同的列、表达式或聚集函数
SELECT vend_id, prod_id, prod_price
FROM products
WHERE prod_price <= 5
UNION
SELECT vend_id, prod_id, prod_price
FROM products
WHERE vend_id IN(1001, 1002);

# UNION ALL 拒绝取消重复的行
SELECT vend_id, prod_id, prod_price
FROM products
WHERE prod_price <= 5
UNION ALL
SELECT vend_id, prod_id, prod_price
FROM products
WHERE vend_id IN(1001, 1002);

# 只允许出现一次ORDER BY
SELECT vend_id, prod_id, prod_price
FROM products
WHERE prod_price <= 5
UNION
SELECT vend_id, prod_id, prod_price
FROM products
WHERE vend_id IN(1001, 1002)
ORDER BY vend_id, prod_price;
