USE test;

# ORDER BY排序：单列
SELECT prod_name
From products
ORDER BY prod_name; # 对prod_name列以字母顺序排序数据

/*多列排序:先对第一列排序，仅当第一列值相同时
再对第二列排序*/
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price, prod_name;

#升降序：默认升序, 降序DESC
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC, prod_name; # DESC只应用于直接位于前面的列

SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC
LIMIT 1; # prod_id的最大值