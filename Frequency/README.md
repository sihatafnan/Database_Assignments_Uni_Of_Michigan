You work for a big corporation and you are assigned with the task of reviewing the company policies for hiring new employees. The company wants you to detect 
any discriminatory policy that may have affected the hiring decisions taken during the past year. You are given a single relation HR, defined as follows:
```sql
create table hr
(
  candidate_id INTEGER PRIMARY KEY,      -- candidate unique identifier
  candidate_gname VARCHAR(30) NOT NULL,  -- candidate's given name
  candidate_fname VARCHAR(30) NOT NULL,  -- candidate's family name
  position VARCHAR(30) NOT NULL,         -- job position the candidate applied for
  hired BOOLEAN NOT NULL,                -- final hiring decision (yes/no)
  zipcode CHAR(5) NOT NULL,              -- hiring office zipcode
  population CHAR(2) NOT NULL            -- candidate's membership to the
                                         -- "general" population (GP) or to the
                                         -- "protected" population (PP)
);
```
To populate the tables,
```sql
INSERT INTO hr VALUES (0,'Ruby','Padilla','ADVANCED SW DEV',FALSE,'48226','PP');
INSERT INTO hr VALUES (1,'Bernadette','Phillips','ENTRY LEVEL SW DEV',TRUE,'48226','GP');--
INSERT INTO hr VALUES (2,'George','Jackson','ENTRY LEVEL SW DEV',FALSE,'48226','PP');-----
INSERT INTO hr VALUES (3,'Sherry','Fishman','ENTRY LEVEL SW DEV',FALSE,'48226','PP');-----
INSERT INTO hr VALUES (4,'Roger','Geisinsky','ENTRY LEVEL SW DEV',TRUE,'48226','PP');-----
INSERT INTO hr VALUES (5,'Marie','Clermont','ENTRY LEVEL SW DEV',FALSE,'48226','GP');--
INSERT INTO hr VALUES (6,'Velma','Maki','ENTRY LEVEL SW DEV',TRUE,'48226','GP');--
INSERT INTO hr VALUES (7,'Tabatha','Russo','ADVANCED SW DEV',FALSE,'48226','PP');
INSERT INTO hr VALUES (8,'April','Christianson','ENTRY LEVEL SW DEV',FALSE,'02139','GP');--
INSERT INTO hr VALUES (9,'Philip','Hendon','ENTRY LEVEL SW DEV',TRUE,'48226','GP');--
INSERT INTO hr VALUES (10,'Katie','Korando','ENTRY LEVEL SW DEV',FALSE,'02139','GP');--
INSERT INTO hr VALUES (11,'William','Cottingham','ADVANCED SW DEV',TRUE,'02139','PP');
INSERT INTO hr VALUES (12,'Jose','Willey','ADVANCED SW DEV',FALSE,'02139','PP');
INSERT INTO hr VALUES (13,'Joseph','Coles','ENTRY LEVEL SW DEV',FALSE,'48226','GP');
INSERT INTO hr VALUES (14,'Kurt','Soto','ENTRY LEVEL SW DEV',TRUE,'02139','GP');
INSERT INTO hr VALUES (15,'Ernest','Doe','ENTRY LEVEL SW DEV',FALSE,'48226','GP');
INSERT INTO hr VALUES (16,'Gilbert','Holland','ENTRY LEVEL SW DEV',FALSE,'02139','GP');
INSERT INTO hr VALUES (17,'Sabrina','Walter','ADVANCED SW DEV',FALSE,'02139','PP');
INSERT INTO hr VALUES (18,'Margaret','Lapoint','ADVANCED SW DEV',FALSE,'48226','GP');
INSERT INTO hr VALUES (19,'Deanna','Stamper','ADVANCED SW DEV',FALSE,'02139','GP');
INSERT INTO hr VALUES (20,'Paul','Williams','ENTRY LEVEL SW DEV',FALSE,'02139','GP');
```
Each record represents a candidate who applied for an open position within the company in the last year. Column “hired” reports the final hiring decision (“true” means that the candidate was
hired, “false” means that the candidate was rejected). The candidates can only apply for one of two positions (column “position”), either “ENTRY LEVEL SW ENG” or “ADVANCED SW
ENG”. Column “zipcode” identifies the location where the job was offered (either Detroit or Boston). Column “population” is used to identify the candidates who may (or may not) be
subject to discrimination (they are marked as “PP”, protected population) from all the others (who are marked as “GP”, general population). Below is a 0.001% random sample from the
table.

**a)** Does membership to the “protected” population affect the chances of a random candidate of being hired? Write a SQL query to compute the relative frequency of positive and negative
hiring decisions with respect to the two populations (“PP” and “GP”). Your query should adopt the following output-schema:

| freq | hired | population |
| ---- | ----- | ---------- |
| 0.49 | true  | GP         |
| 0.51 | false | GP         |
| 0.52 | true  | PP         |
| 0.48 | false | PP         |

The first record in the example above simply states that 49% of the candidates from the general population received an offer, while the remaining 51% were rejected (second record). Records
#3 and #4 report the same statistics for the protected population, where 52% of the candidates were hired and the remaining 48% were rejected. The numbers reported here are for illustration
only; using the real data you will obtain different numbers. Your query must measure the same statistics as above, but with the real data. Your query must
adopt the same schema as above and the same sorting order (order by population, hired DESC ).Your query must round the frequencies down to two digits of precision (you can use function
ROUND(X,2)). All the frequencies related to a certain population must always sum up to one. Your query must return exactly four records, one for each possible assignment to attributes {hired,
population}. Run your query in PostgreSQL and report both the query and the observed result. Hint #1: consider using window functions! Hint #2: Test-drive your queries against a small
subset of the data first, before moving to the real data set, it will save you a lot of time.

**b)** For each of the two available positions, “ENTRY LEVEL SW ENG” and “ADVANCED LEVEL SW ENG”, compute the same four statistics as in point (a), but considering only the
candidates who applied for the given position. The relation produced by your SQL query should look this:

| position           | freq | hired | population |
| ------------------ | ---- | ----- | ---------- |
| ENTRY LEVEL SW DEV | 0.55 | true  | GP         |
| ENTRY LEVEL SW DEV | 0.45 | false | GP         |
| ENTRY LEVEL SW DEV | 0.54 | true  | PP         |
| ENTRY LEVEL SW DEV | 0.46 | false | PP         |
| ADVANCED SW DEV    | 0.44 | true  | GP         |
| ADVANCED SW DEV    | 0.56 | false | GP         |
| ADVANCED SW DEV    | 0.43 | true  | PP         |
| ADVANCED SW DEV    | 0.57 | false | PP         |

In the example, the first two records state that 55% of the candidates from the general population (“GP”) who applied for the “entry-level” position were hired, while the remaining 45% were rejected. Records #3 and #4 state that 54% of the candidates from the protectedpopulation (“PP”) who applied for the “entry-level” position were hired, while the remainin 46% were rejected. Records #5 and #6 state that 44% of the candidates from the general population (“GP”) who applied for the “advanced” position were hired, while the remaining 66% were rejected. Records #7 and #8 state that 43% of the candidates from the protected population (“PP”) who applied for the “advanced” position were hired, while the remaining 57% were rejected. Once again, the numbers reported here are for illustration only and you will get different results with the real data. Your query must adopt the same schema as above and the same sorting order (order by position DESC, population, hired DESC). Your query must round the frequencies down to two digits of precision (you can use function ROUND(X,2)). All the frequencies related to a certain population and job position must always sum up to one. Your query must return exactly eight records, i.e. one record for each possible assignment to attributes {position, hired, population}. Run your query in PostgreSQL and report both the query and the observed result.

**Solution**
a)
```sql
select round(count(*)*1.0/t.total,2) as freq , t1.hired , t1.population
from hr as t1 , (
select population , count(*) as total from hr
group by population
) as t
where t1.population=t.population group by t1.hired , t1.population,t.total
order by population, hired desc
;
```
b)
```sql
select t1.position , round(count(*)*1.0/t.total,2) as freq , t1.hired , t1.population
from hr as t1 , (
select population , position , count(*) as total from hr
group by population,position
) as t
where t1.population=t.population and t1.position=t.position group by t1.position , t1.hired , t1.population,t.total
order by population, hired desc
;

```
