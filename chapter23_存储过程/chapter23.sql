USE test;

/*存储过程就是为以后的使用而保存
的一条或多条MySQL语句的集合，类似函数，
可以传入变量，也可以返回变量*/

 CREATE PROCEDURE productpricing() # 参数在()中列出
 BEGIN
    SELECT Avg(prod_price) AS priceaverage
    FROM products;
END;


CALL productpricing();
DROP PROCEDURE IF EXISTS productpricing; #删除存储过程

#使用参数的存储过程
CREATE PROCEDURE productpricing(
    # 参数指定类型，OUT作为传出存储过程(返回)关键词
    OUT pl DECIMAL(8, 2), #最低价格
    OUT ph DECIMAL(8, 2), #最高价格
    OUT pa DECIMAL(8, 2) #平均价格
)
BEGIN
    SELECT MIN(prod_price) 
    INTO pl
    FROM products;
    SELECT MAX(prod_price) 
    INTO ph
    FROM products;
    SELECT Avg(prod_price)
    INTO pa
    FROM products;
END;

#调用存储过程, 调用不显示任何数据，返回以后可以显示的变量,返回变量必须加@，输入变量不用加
CALL productpricing(
    @pricelow,
    @pricehigh,
    @priceaverage
);

SELECT @pricelow, @pricehigh, @priceaverage;

#传入变量使用关键词IN
CREATE PROCEDURE ordertotal(
    IN ordernumber INT, #指定某个订单号作为输入
    OUT ordertotal DECIMAL(8, 2)
)
BEGIN
    SELECT SUM(item_price * quantity) # AS totalprice
    INTO ordertotal
    FROM orderitems
    WHERE order_num = ordernumber;
END;


CALL ordertotal(20005, @total);
SELECT @total;

DROP PROCEDURE IF EXISTS ordertotal;

/*在存储过程内包含业务规则和智能处理*/
CREATE PROCEDURE ordertotal(
    IN ordernumber INT, # 指定输入订单号
    IN taxable BOOLEAN, #指定是否上税
    OUT totalorder DECIMAL(8, 2)
)
BEGIN # BEGIN...END;语句中每条语句都必须用;隔开
    # 定义两个临时局部变量
    DECLARE total DECIMAL(8, 2);
    DECLARE tax INT DEFAULT 6;

    SELECT SUM(item_price * quantity)
    INTO total
    FROM orderitems
    WHERE order_num = ordernumber;
    
    #IF语句还支持ELSEIF和ELSE子句, 前者还使用THEN子句，后者不使用
    IF taxable THEN
        SELECT total + (total / (100 * taxable)) INTO total;
    END iF;
    SELECT total INTO totalorder;
END;

CALL ordertotal(20005, 0, @total);
SELECT @total;

CALL ordertotal(20005, 1, @total);
SELECT @total;

