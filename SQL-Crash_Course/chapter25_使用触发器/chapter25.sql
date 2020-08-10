USE test;
/*触发器：想要某条语句（或某些语句）在事件发生时自动执行
响应如下语句而自动执行的语句：
DELETE, INSERT, UPDATE，指定发生在语句前或后，所以一个表只有6个Trigger
视图和临时表没有触发器
*/

/*创建和使用触发器
1.触发器名
2.触发器关联的表
3.触发器响应的活动(DELETE, INSERT, UPDATE)
4.活动前或活动后执行
删除触发器用 DROP TRIGGER Triggername

INSERT触发器中,NEW用来表示将要(BEFORE)或已经(AFTER)插入的新数据。
UPDATE触发器中，OLD用来表示将要或已经被修改的原数据，NEW用来表示将要或已经修改为的新数据。
DELETE触发器中，OLD用来表示将要或已经被删除的原数据。
*/

/* INSERT触发器
1.在INSERT触发器代码内，可引用一个名为NEW的虚拟表，访问被插入的行；
2.在BEFORE INSERT触发器中，NEW中的值也可以被更新（允许更改被插入的值）；
3.对于AUTO_INCREMENT列，NEW在INSERT执行之前包含0，在INSERT
执行之后包含新的自动生成值。*/
/*SELECT 结果放入一个变量中，不然报错*/

CREATE TRIGGER neworder AFTER INSERT ON orders # 指定一个对表orders的INSERT TRIGGER,发生在INSERT之后
FOR EACH ROW SELECT NEW.order_num INTO @p; # 触发器对每个新插入的行查询其order_num(auto_increment)

#测试
INSERT INTO orders
VALUES(NULL, Now(), 10001);

/*DELETE触发器
1. 在DELETE触发器代码内，你可以引用一个名为OLD的虚拟表，访问被删除的行；
2. OLD中的值全都是只读的，不能更新
*/

#使用OLD保存将要被删除的行到一个存档表中(提前建立archive_orders)
CREATE TRIGGER deleteorder BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO archive_orders(order_num, order_date, cust_id)
    VALUES(OLD.order_num, OLD.order_date, OLD.cust_id);
END;


#删除一个orders中的行，将orderitems中与orders表中被删除的行有
#相同order_num的行的orderitems修改为指定字符串
CREATE TRIGGER test_tt AFTER DELETE ON orders  
FOR EACH ROW
BEGIN
    DECLARE s VARCHAR(20) DEFAULT 'hello';
    SET s = 'world'; # 将变量s赋值为'world'
    UPDATE orderitems SET orderitem = s WHERE order_num = OLD.order_num; # OLD指被删除的orders表中的行
END;


/*UPDATE触发器
1.在UPDATE触发器代码中，可以引用一个名为OLD的虚拟表访问
以前（UPDATE语句前）的值，引用一个名为NEW的虚拟表访问新
更新的值。
*/

