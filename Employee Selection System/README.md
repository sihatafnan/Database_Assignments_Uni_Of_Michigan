# Employee Selection System
This is an assignment issued by university Of Michigun.It's 'bout establishing the backend part(database) and generating some query solely on a database tool.First let's look at the 5 tables.You can find the DDL statements in the file section:
**Candidates table**
![](candidates.png)
**Candidatesskill table**
![](cs.png)
**openpositions table**
![](p.png)
**positionrequirements table**
![](pr.png)
**skills table**
![](skill.png)

Now , let's look at the proposed query and their sql code;The results are shown for the DML statements included in this repository. 

## 1
Write a SQL select statement to identify all the candidates that are proficient in both C++ and Java. Your query should return a relation with schema (cid, name), sorted by (cid, name).
```sql
SELECT DISTINCT cd.cid , cd.name
FROM candidates cd , 
(SELECT cs.cid FROM candidateskills cs WHERE cs.skill = 'Java') cpp,
(SELECT cs.cid FROM candidateskills cs WHERE cs.skill = 'C++') java
WHERE cd.cid = cpp.cid AND cd.cid = java.cid
ORDER BY cd.cid , cd.name;
```
| cid     | name    |
| -------	| --------|
|	2	|	Bob	|
|	4	|	Tom	|
|	5	|	Liz	|


## 2
Write a SQL select statement to report all the candidates with less than 3 distinct technical skills. Do not ignore Leo! Your query should return a relation with schema (cid, name), sorted by (cid, name).
```sql
SELECT cd.cid , cd.name
FROM candidates cd,
(
SELECT DISTINCT cd.cid , COUNT(cs.cid)
FROM candidates cd LEFT JOIN candidateskills cs
ON cd.cid = cs.cid
GROUP BY cd.cid  ,cs.cid
) poor_cd
WHERE cd.cid = poor_cd.cid AND poor_cd.count<3
ORDER BY cd.cid , cd.name; 

```
| cid     | name    |
| -------	| --------|
|	1	|	Ada	|
|	2	|	Bob	|
|	3	|	Eve	|
|	6	|	Leo	|


## 3
Is it true that all C++ programmers are also proficient in either Java or Cobol (or both)? Write a SQL select statement find out. Your query should return an empty relation whenever the above hypothesis is satisfied.

The following query will find  the candidates who is proficient in c++ but not in java and cobol.So , if the proposed hypothesis in the question is true , the query will return an empty relation.
```sql
(
(SELECT cs.cid ,cd.name FROM candidateskills cs,candidates cd WHERE cd.cid=cs.cid AND cs.skill='C++')
EXCEPT
(SELECT cs.cid ,cd.name FROM candidateskills cs,candidates cd WHERE cd.cid=cs.cid AND cs.skill='Java')
)
EXCEPT
(SELECT cs.cid ,cd.name FROM candidateskills cs,candidates cd WHERE cd.cid=cs.cid AND cs.skill='COBOL'); 
```
| cid     | name    |
| -------	| --------|
|	1	|	Ada	|

## 4
Write a SQL select statement to report id and name of all the candidates who have at least one skill that no one else has. Your query should return a relation with schema (cid, name), sorted by (cid, name).
```sql
SELECT DISTINCT cd.cid,cd.name FROM candidates cd , 

(SELECT cs.skill FROM candidateskills cs
GROUP BY cs.skill
HAVING COUNT(cs.skill)=1) dist_skill ,

candidateskills cs
WHERE cd.cid = cs.cid AND cs.skill = dist_skill.skill
ORDER BY cd.cid,cd.name; 

```
| cid  | name |
|----- |------|
|	3 |	Eve |
|	5 |	Liz |

## 5
Write a SQL select statement to match each open position with all the suitable candidates. A candidate is suitable only if she possesses all the skills that the position requires. Your query should return a relation with schema (pid, employer, descr, cid, name), sorted by (pid, employer, descr, cid, name).
```sql
SELECT p.pid , p.employer , p.descr , cd.cid , cd.name
FROM
openpositions p ,candidates cd

WHERE

(SELECT COUNT(*) FROM positionrequirements WHERE pid = p.pid)
=
(SELECT COUNT(*)FROM candidateskills WHERE cid = cd.cid AND skill IN(SELECT skill FROM positionrequirements WHERE pid = p.pid)) 
ORDER BY p.pid , p.employer , p.descr , cd.cid , cd.name; 

```
| pid     | employer|	descr               | cid     | name    |
|---------|--------	|------------------------|---------|---------|
|	1	|	IBM	|	Junior SWE	     |	1	|	Ada	|
|	1	|	IBM	|	Junior SWE	     |	2	|	Bob	|
|	1	|	IBM	|	Junior SWE	     |	4	|	Tom	|
|	1	|	IBM	|	Junior SWE	     |	5	|	Liz	|
|	2	|	HPE	|	System SWE	     |	2	|	Bob	|
|	2	|	HPE	|	System SWE	     |	4	|	Tom	|
|	2	|	HPE	|	System SWE	     |	5	|	Liz	|
|	4	|	XZY	| COVID19	Vaccine tester	|	1	|	Ada	|
|	4	|	XZY	| COVID19	Vaccine tester	|	2	|	Bob	|
|	4	|	XZY	| COVID19	Vaccine tester	|	3	|	Eve	|
|	4	|	XZY	| COVID19	Vaccine tester	|	4	|	Tom	|
|	4	|	XZY	| COVID19	Vaccine tester	|	5	|	Liz	|
|	4	|	XZY	| COVID19	Vaccine tester	|	6	|	Leo	|


## 6
Write a SQL select statement to identify, for each candidate, the skills where the candidate proficiency is above average. Compute the average proficiency with respect to all the other candidates; for the candidates that do not possess a certain skill, count their proficiency as zero. Your query should return a relation with schema (cid, name, skill, proficiency, avg_proficiency), sorted by (cid, skill).
```sql
SELECT cs.cid , cd.name , cs.skill , cs.proficiency , sa.avg 
FROM
candidates cd,
candidateskills cs,
(SELECT cs.skill , (0.0 + sum(cs.proficiency))/( SELECT max(t.row_number) from (SELECT row_number() over()  FROM candidates) t)  avg
FROM candidateskills cs
GROUP BY cs.skill
) sa
WHERE cd.cid = cs.cid AND cs.skill = sa.skill
ORDER BY 
cs.cid , cs.skill; 
```
| cid     | name    |  skill  | proficiency  |	avg_proficiency     |
|---------|---------|---------|--------------|------------------------|
|	1	|	Ada	|	C++	|	7	     |	4.666666666666667	|
|	1	|	Ada	|	SQL	|	8	     |	4.333333333333333	|
|	2	|	Bob	|	C++	|	6	     |	4.666666666666667	|
|	2	|	Bob	|	Java	|	9	     |	4.5	               |
|	3	|	Eve	|   Python|	9	     |	1.5	               |
|	4	|	Tom	|	C++	|	7	     |	4.666666666666667	|
|	4	|	Tom	|	Java	|	9	     |	4.5	               |
|	4	|	Tom	|	SQL	|	9	     |	4.333333333333333	|
|	5	|	Liz	|	C++	|	8	     |	4.666666666666667	|
|	5	|	Liz	|    COBOL|	7	     |	1.1666666666666667	|
|	5	|	Liz	|	Java	|	9	     |	4.5	               |
|	5	|	Liz	|  Matlab	|	5	     |	0.8333333333333334	|
|	5	|	Liz	|	SQL	|	9	     |	4.333333333333333	|


