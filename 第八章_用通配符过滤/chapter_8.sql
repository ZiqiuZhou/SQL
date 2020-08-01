USE test;

/*用通配符过滤某些元素包含某特殊含义的字符
使用LIKE*/

/* %通配符在搜索中,放在某字符后string%表示string后面出现的任何字符出现任意次
放在某字符前%string表示string前面出现的任何字符出现任意次*/
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE 'jet%';#接受jet后任意字符出现任意次(以jet开头的product)

SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '%s';

# %string%表示搜索包含string的值,包含以其开头或结尾
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '%anvil%';


/* _通配符， 作用和%一样但只匹配单个字符,即_string前面
只出现一个字符的行被搜索出来*/
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '_ ton anvil';

