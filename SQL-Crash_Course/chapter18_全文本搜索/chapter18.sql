USE test;
/*全文本搜索
MyISAM引擎支持, InnoDB不支持
*/
/*
LIKE通配符和正则化匹配仍存在一些限制：
1.匹配表中所有行，非常耗时；
2.很难明确匹配或不匹配什么；
3.不太智能，如不能返回与搜索词相关的其他词，
  不区分各个匹配结果的匹配相关度，也不按照匹配度排序

使用FULLEXT索引，不需要分别查看每个行，不需要分别分析和处理
每个词。FULLTEXT创建指定列中每个词的索引，搜索可以进行为，哪些
行包含为该索引的词。
在创建表productnotes时,对其中一列note_text使用FULLTEXT(note_text),
删改行时索引自动更新。。应该首先导入所有数据，然后再修改表，定义FULLTEXT。
*/
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('rabbit'); # Match()指定被搜索的列，Against()指定要使用的搜索表达式

# 全文本搜索对结果排序
SELECT note_text, Match(note_text) Against('rabbit') AS ranks
FROM productnotes;

/* 找出可能与搜索词有关的所有其他行，即使它们不包含关键词
在使用查询扩展时，MySQL对数据和索引进行两遍扫描来完成搜索：
1.首先，进行一个基本的全文本搜索，找出与搜索条件匹配的所有
行；
2.其次，MySQL检查这些匹配行并选择所有有用的词
3.再其次，MySQL再次进行全文本搜索，这次不仅使用原来的条件，
而且还使用所有有用的词。
*/
SELECT note_text, Match(note_text) Against('anvils' WITH QUERY EXPANSION) AS ranks
FROM productnotes
WHERE Match(note_text) Against('anvils' WITH QUERY EXPANSION);

/*布尔文本搜索, 没有FULLTEXT也可以使用
+ 包含，词必须存在
- 排除，词必须不出现
> 包含，而且增加等级值
< 包含，且减少等级值
() 把词组成子表达式（允许这些子表达式作为一个组被包含、
排除、排列等）
~ 取消一个词的排序值
* 词尾的通配符
"" 定义一个短语
*/

# 搜索匹配包含词rabbit和bait的行
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('+rabbit +bait' IN BOOLEAN MODE);

# 搜索匹配短语rabbit bait而不是匹配两个词rabbit和bait
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against(' "rabbit bait" ' IN BOOLEAN MODE);

# 匹配rabbit和carrot，增加前者的等级，降低后者的等级
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('>rabbit <bait' IN BOOLEAN MODE);

/*
1. FULLTEXT索引时，短词被忽略且从索引中排除(长度不足3)
2。如果一个词出现在50%以上的行中，则将它作为一个非用词忽略。50%规则不用于IN BOOLEAN MODE
*/