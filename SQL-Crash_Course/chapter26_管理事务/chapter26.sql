USE test;
/*
事务处理（transaction processing）可以用来维护数据库的完整性，它
保证成批的MySQL操作要么完全执行，要么完全不执行.保证数据库不存在
不完整的操作结果(插入过程中出现故障导致不完整)。。如果发生错误，
则进行回退（撤销）以恢复数据库到某个已知且安全的状态
1.事务（transaction）指一组SQL语句；
2.回退（rollback）指撤销指定SQL语句的过程；
3.提交（commit）指将未存储的SQL语句结果写入数据库表；
4.保留点（savepoint）指事务处理中设置的临时占位符（placeholder），
你可以对它发布回退（与回退整个事务处理不同）
*/

SELECT * FROM orderitemsexpanded;
START TRANSACTION; # 开始事务
DELETE FROM orderitemsexpanded;
SELECT * FROM orderitemsexpanded; # 空表
ROLLBACK; # 回退， 用来管理事务处理用来管理INSERT、UPDATE和DELETE语句
SELECT * FROM orderitemsexpanded; # 表非空
COMMIT; # 仅在不出错时写出更改

START TRANSACTION;
DELETE FROM orderitemsexpanded WHERE prod_id = 'ANV01';
DELETE FROM orderitemsexpanded WHERE prod_id = 'FB';
COMMIT; #COMMIT语句仅在不出错时写出更改。如果第一条DELETE起作用，但第二条失败，则DELETE不会提交

 
