# Database Assignments — University of Michigan (PostgreSQL)

A collection of database design and SQL assignments completed alongside the
University of Michigan database coursework, using **PostgreSQL**. Each folder is
a self-contained mini-project covering schema design (DDL), data population
(DML), and a set of SQL queries against that schema.

## Projects

| Folder | Description |
| ------ | ----------- |
| `Library Management System/` | Library schema with an ERD (`BOOK_ERD.png`), `DDL.sql` for table creation, a `DML/` folder of insert/query scripts, sample `Query_results/`, and a detailed `README.md`. |
| `Coronostats/` | COVID statistics dataset/queries, including an ER diagram (`Corona.png`) and a comprehensive `README.md`. |
| `Employee Selection System/` | Schema and queries for an employee selection scenario. |
| `IT Company/` | Schema and queries modeling an IT company. |
| `Frequency/` | Query exercise focused on frequency-based analysis. |
| `Mid Assignment/` | Mid-term assignment. |

Several subfolders (notably `Library Management System` and `Coronostats`)
contain their own README files with the schema details, problem statements, and
query explanations.

## Tech Stack

- **PostgreSQL** as the relational database engine
- Plain **SQL** (DDL + DML) — table creation, data insertion, and SELECT queries

## Usage

For any project, create the schema and load the data, then run the queries. For
example, using `psql`:

```bash
# create/connect to a database, then:
psql -d your_database -f "Library Management System/DDL.sql"
# run the DML scripts in the project's DML/ folder, then your query files
```

Open each project's own `README.md` (where present) for the specific schema,
problem statements, and expected results.
