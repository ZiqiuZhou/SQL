USE test;

/*在WHERE子句中使用正则表达式过滤数据，
用来匹配文本的特殊的串(字符集合)*/
 
 /*基本字符匹配*/
 SELECT prod_name
 FROM products
 WHERE prod_name REGEXP '1000'; # REGEXP代替LIKE, 包含'1000',等同于通配符%1000%

# 表达式‘.’与‘%’意思相同
SELECT prod_name
 FROM products
 WHERE prod_name REGEXP 'jet.'; #匹配jet后任意字符

 #使用‘|’匹配文本中包含两个子串之一，进行逻辑OR
SELECT prod_name
 FROM products
 WHERE prod_name REGEXP '1000|2000'
 ORDER BY prod_name;

/*'[]用来匹配几个字符之一，是OR的特殊形式'，
如'[123] ton' 相当于'1 ton|2 ton|3 ton'*/
SELECT prod_name
 FROM products
 WHERE prod_name REGEXP '[123] ton' #可用[1-3]表示范围
 ORDER BY prod_name;

/*当需要被匹配的字符刚好是正则表达式中的特殊操作符，
需要加前缀\\以区分，如\\. 不加'\\'或被认为是操作符 */
SELECT prod_name
 FROM products
 WHERE prod_name REGEXP '\\.' #可用[1-3]表示范围
 ORDER BY prod_name;

/*字符类常见正则表达式：
[:alnum:] 任意字母和数字（同[a-zA-Z0-9]）
[:alpha:] 任意字符（同[a-zA-Z]）
[:blank:] 空格和制表（同[\\t]）
[:cntrl:] ASCII控制字符（ASCII 0到31和127）
[:digit:] 任意数字（同[0-9]）
[:graph:] 与[:print:]相同，但不包括空格
[:lower:] 任意小写字母（同[a-z]）
[:print:] 任意可打印字符
[:punct:] 既不在[:alnum:]又不在[:cntrl:]中的任意字符
[:space:] 包括空格在内的任意空白字符（同[\\f\\n\\r\\t\\v]）
[:upper:] 任意大写字母（同[A-Z]）
[:xdigit:] 任意十六进制数字（同[a-fA-F0-9]）
*/

/*待匹配文本处于特殊位置
^ 文本的开始
$ 文本的结尾
[[:<:]] 词的开始
[[:>:]] 词的结尾
*/
#此时用'.'不行，它将从文本任意位置开始，匹配该位置
#前任意个字符或后任意个字符
SELECT prod_name
FROM products
WHERE prod_name REGEXP '^[:digit:]'; #文本以数字开头

SELECT prod_name
FROM products
WHERE prod_name REGEXP '[:digit:]$'; #文本以数字结尾