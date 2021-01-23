## Q1
You are given the following table, representing authorship of books:
```sql
CREATE TABLE A(
BID VARCHAR(40) NOT NULL,
     AID VARCHAR(40) NOT NULL,
CONSTRAINT PK PRIMARY KEY (BID, AID)
);
```
Attribute BID identifies a book, attribute AID identifies an author. A record (BID, AID) represents the fact that individual <AID> is one of the authors of book <BID>.
The following is a plausible instance of table A:

|	                                            bid |	aid |
|------------------------------------------------ | --- |
|	                      Confessions of a DBA      |	Ada |
|	                      Confessions of a DBA      |	Bob |
|	                      Confessions of a DBA      | Carl|
|   Falling in love with Relational Algebra       |	Ada |
| Falling in love with Relational Algebra         |	Bob |
| Falling in love with Relational Algebra         | Carl|
| Falling in love with Relational Algebra         | Dave|
|	NULL values and me                              | Carl|
  
Two distinct individuals are co-authors if they share at least one book they have written. Two co-authors are said to be exclusive co-authors if the share all the books they have ever written (and the set of books they share is not empty). For example, in the instance above Ada and Carl are co-authors, but they are not exclusive co-authors; Ada and Bob, instead, are exclusive co- authors. Write a SQL select statement to identify all the pairs of exclusive coauthors. Do not return the same pair more than once. The expected result for the given database instance is:


| aid1   | aid2  |
| -------| ------|
| 	     | 	     |
|	Ada    |	Bob  |
| 	     | 	     |

Make sure your answer adopts the same output-schema and sorts the tuples by (aid1, aid2). Your SQL statement must work properly on any arbitrary database instance, not just the one that is given. Your SQL statement will be evaluated in PostgreSQL 9.6: make sure to test it in www.db-fiddle.com or any other similar service; answers that fail to run on PostgreSQL 9.6 will be penalized. State any assumption you make. Do not use any DDL statement. Do not return duplicate tuples.

Solution :
```sql
SELECT distinct a1.AID aid1 , a2.AID aid2 
FROM A a1 , A a2
WHERE a1.BID = a2.BID AND a1.AID <> a2.AID 
AND (SELECT count(BID) FROM A WHERE AID = a1.AID )  =  (SELECT count(BID) FROM A WHERE AID = a2.AID ) 
AND (SELECT count(BID) FROM A WHERE AID = a1.AID ) <> 0
AND a1.AID > a2.AID
GROUP BY a1.AID,a2.AID
ORDER BY aid1 , aid2;
```
## Q2 [External memory algorithms]
A set of 4,194,304 fixed-length records is stored on disk, into a heap file (unsorted). Each record in the file consists of 2 Kbytes of data, hence the whole file contains 8 Gigabytes1 of data, overall. Let’s assume that the size of a memory-block is 2 Megabytes and that the main memory consists of 512 blocks (i.e. 1 Gigabyte).

a)	Your goal is to create a new 8 Gigabytes file where the records are sorted by some primary key. Devise an algorithm to achieve this goal minimizing the number of 2-Megabytes blocks  that are either read from or written to the disk. Keep in mind that you can never store more that 512 blocks in main memory at the same time. Explain your algorithm step by step and report the minimum number of blocks that is necessary to read from/write into the disk in order to complete the task.

b)	If you had to look-up a single record (identified by its primary key) into the newly created sorted file, how many memory-blocks would you need to read from disk, in the worst-case scenario? Justify your answer.

You are welcomed to solve Q2




