USE test;
#假如给customers表格插入一行
/*每个列必须提供一个值。如果某个列没有值应该使用NULL值,
（假定表允许对该列指定空值）.各个列必须以它们在表定义中出现的
次序填充。
*/
INSERT INTO customers
VALUES(
    NULL, # auto_increment
    'Pep E. LaPew',
    '100 Main Street',
    'Los Angeles',
    'CA',
    '90046',
    'USA',
    NULL,
    NULL
    ),
    (
     NULL, # auto_increment
     'M. Martian',
     '42 Galaxy Way',
     'New York',
     'NY',
     '11213',
     'USA',
     NULL,
     NULL  
);


/*更新数据,UPDATE*/
UPDATE customers 
SET cust_email = 'elmer@fud.com',
    cust_name = 'The Fudds' # 最后一列之后不用逗号
WHERE cust_id = 10005;

/*删除数据*/
#删除某个列的值，可用UPDATE设置其为NULL
UPDATE customers
SET cust_email = NULL
WHERE cust_id = 10005; # 用主键来过滤

# DELETE删指定整行
DELETE FROM customers
WHERE cust_id = 10006;

/*创建和操纵表*/
CREATE TABLE customersNew
(
    cust_id      int NOT NULL auto_increment,
    cust_name    char(50) NOT NULL,
    cust_address char(50) NULL,
    cust_city    char(50) NULL,
    cust_state   char(5) NULL,
    cust_zip     char(10) NULL,
    cust_country char(50) NULL,
    cust_contact char(50) NULL,
    cust_email   char(255) NULL,
    PRIMARY KEY (cust_id) #主键有多个列，在括号内每个列名用逗号隔开
) ENGINE=InnoDB;

CREATE TABLE orderitemsNew
(
    order_num    int NOT NULL,
    order_item   int NOT NULL,
    prod_id      char(10) NOT NULL,
    quantity     int NOT NLL DEFAULT 1‘ # default
    PRIMARY KEY (order_num，order_item) #主键有多个列，在括号内每个列名用逗号隔开
) ENGINE=InnoDB;

/*
InnoDB是一个可靠的事务处理引擎，不支持全文本搜索
MyISAM支持全文本搜索，但不支持事务处理
*/

/*原则上表创建好就不用修改结构， 必要时使用ALTER TABLE*/
#添加一列
ALTER TABLE vendors
ADD vend_phone CHAR(20);
#删除一列
ALTER TABLE vendors
DROP COLUMN vend_phone;
#删除表
DROP TABLE orderitemsNew;
#重命名表
RENAME TABLE customersNew to customers2;
