-- Table: IT_Company.Role

-- DROP TABLE IF EXISTS "IT_Company"."Role";

CREATE TABLE IF NOT EXISTS "IT_Company"."Role"
(
    "RoleID" integer NOT NULL DEFAULT nextval('"IT_Company"."Role_RoleID_seq"'::regclass),
    "Name" character varying[] COLLATE pg_catalog."default",
    CONSTRAINT "Role_pkey" PRIMARY KEY ("RoleID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Role"
    OWNER to postgres;

-- Table: IT_Company.User Group

-- DROP TABLE IF EXISTS "IT_Company"."User Group";

CREATE TABLE IF NOT EXISTS "IT_Company"."User Group"
(
    "GrID" integer NOT NULL DEFAULT nextval('"IT_Company"."User Group_GrID_seq"'::regclass),
    "Name" character varying[] COLLATE pg_catalog."default",
    CONSTRAINT "User Group_pkey" PRIMARY KEY ("GrID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."User Group"
    OWNER to postgres;

-- Table: IT_Company.Location

-- DROP TABLE IF EXISTS "IT_Company"."Location";

CREATE TABLE IF NOT EXISTS "IT_Company"."Location"
(
    "LID" integer NOT NULL DEFAULT nextval('"IT_Company"."Location_LID_seq"'::regclass),
    "Address" "char"[],
    "Country" "char"[],
    CONSTRAINT "Location_pkey" PRIMARY KEY ("LID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Location"
    OWNER to postgres;

-- Table: IT_Company.Customer

-- DROP TABLE IF EXISTS "IT_Company"."Customer";

CREATE TABLE IF NOT EXISTS "IT_Company"."Customer"
(
    "CID" integer NOT NULL DEFAULT nextval('"IT_Company"."Customer_CID_seq"'::regclass),
    "Name" "char"[],
    "Email" "char"[],
    "LID" integer NOT NULL,
    CONSTRAINT "Customer_pkey" PRIMARY KEY ("CID"),
    CONSTRAINT "LID_FK" FOREIGN KEY ("LID")
        REFERENCES "IT_Company"."Location" ("LID") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Customer"
    OWNER to postgres;


-- Table: IT_Company.Project

-- DROP TABLE IF EXISTS "IT_Company"."Project";

CREATE TABLE IF NOT EXISTS "IT_Company"."Project"
(
    "PrID" integer NOT NULL DEFAULT nextval('"IT_Company"."Project_PrID_seq"'::regclass),
    "Name" "char"[],
    "Budget" "char"[],
    "StartDate" date CHECK (StartDate >= now()),
    "Deadline" date,
    "CID" integer,
    CONSTRAINT "Project_pkey" PRIMARY KEY ("PrID"),
    CONSTRAINT "CID_FK" FOREIGN KEY ("CID")
        REFERENCES "IT_Company"."Customer" ("CID") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Project"
    OWNER to postgres;


-- Trigger: ProjectAuditTrigger

-- DROP TRIGGER IF EXISTS "ProjectAuditTrigger" ON "IT_Company"."Project";

CREATE TRIGGER "ProjectAuditTrigger"
    AFTER INSERT
    ON "IT_Company"."Project"
    FOR EACH ROW
    EXECUTE FUNCTION "IT_Company"."projectAuditFunc"();

-- Trigger: projectUpdateTrigger

-- DROP TRIGGER IF EXISTS "projectUpdateTrigger" ON "IT_Company"."Project";

CREATE TRIGGER "projectUpdateTrigger"
    AFTER UPDATE
    ON "IT_Company"."Project"
    FOR EACH ROW
    EXECUTE FUNCTION "IT_Company"."projectUpdateFunc"();


-- Table: IT_Company.Department

-- DROP TABLE IF EXISTS "IT_Company"."Department";

CREATE TABLE IF NOT EXISTS "IT_Company"."Department"
(
    "DepID" integer NOT NULL DEFAULT nextval('"IT_Company"."Department_DepID_seq"'::regclass),
    "Name" "char"[],
    "LID" integer,
    CONSTRAINT "Department_pkey" PRIMARY KEY ("DepID"),
    CONSTRAINT "LID_FK" FOREIGN KEY ("LID")
        REFERENCES "IT_Company"."Location" ("LID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Department"
    OWNER to postgres;

-- Table: IT_Company.Employee

-- DROP TABLE IF EXISTS "IT_Company"."Employee";

CREATE TABLE IF NOT EXISTS "IT_Company"."Employee"
(
    "EmpID" integer NOT NULL DEFAULT nextval('"IT_Company"."Employee_EmpID_seq"'::regclass),
    "Email" "char"[],
    "Name" "char"[],
    "DepID" integer,
    CONSTRAINT "Employee_pkey" PRIMARY KEY ("EmpID"),
    CONSTRAINT "DepID_FK" FOREIGN KEY ("DepID")
        REFERENCES "IT_Company"."Department" ("DepID") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL;
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Employee"
    OWNER to postgres;

-- Table: IT_Company.Project_Employee

-- DROP TABLE IF EXISTS "IT_Company"."Project_Employee";

CREATE TABLE IF NOT EXISTS "IT_Company"."Project_Employee"
(
    "PrID" integer NOT NULL,
    "EmpID" integer NOT NULL,
    "StartedWorking" date,
    CONSTRAINT "Project_Employee_pkey" PRIMARY KEY ("PrID", "EmpID"),
    CONSTRAINT "EmpID_FK" FOREIGN KEY ("EmpID")
        REFERENCES "IT_Company"."Employee" ("EmpID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "PrID_DK" FOREIGN KEY ("PrID")
        REFERENCES "IT_Company"."Project" ("PrID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Project_Employee"
    OWNER to postgres;

-- Trigger: EmpAuditTrigger

-- DROP TRIGGER IF EXISTS "EmpAuditTrigger" ON "IT_Company"."Employee";

CREATE TRIGGER "EmpAuditTrigger"
    AFTER INSERT
    ON "IT_Company"."Employee"
    FOR EACH ROW
    EXECUTE FUNCTION "IT_Company"."empAuditFunc"();


-- Table: IT_Company.Employee_UserGroup

-- DROP TABLE IF EXISTS "IT_Company"."Employee_UserGroup";

CREATE TABLE IF NOT EXISTS "IT_Company"."Employee_UserGroup"
(
    "EmpID" integer NOT NULL,
    "GrID" integer NOT NULL,
    CONSTRAINT "Employee_UserGroup_pkey" PRIMARY KEY ("EmpID", "GrID"),
    CONSTRAINT "EmpID_FK" FOREIGN KEY ("EmpID")
        REFERENCES "IT_Company"."Employee" ("EmpID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "GrID_FK" FOREIGN KEY ("GrID")
        REFERENCES "IT_Company"."User Group" ("GrID") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Employee_UserGroup"
    OWNER to postgres;


    -- Table: IT_Company.Employee_Role

-- DROP TABLE IF EXISTS "IT_Company"."Employee_Role";

CREATE TABLE IF NOT EXISTS "IT_Company"."Employee_Role"
(
    "EmpID" integer NOT NULL,
    "RoleID" integer NOT NULL,
    CONSTRAINT "Employee_Role_pkey" PRIMARY KEY ("EmpID", "RoleID"),
    CONSTRAINT "EmpID_FK" FOREIGN KEY ("EmpID")
        REFERENCES "IT_Company"."Employee" ("EmpID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "RoleID_FK" FOREIGN KEY ("RoleID")
        REFERENCES "IT_Company"."Role" ("RoleID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Employee_Role"
    OWNER to postgres;


-- Table: IT_Company.Project_Audit

-- DROP TABLE IF EXISTS "IT_Company"."Project_Audit";

CREATE TABLE IF NOT EXISTS "IT_Company"."Project_Audit"
(
    "PrID" integer NOT NULL,
    "EntryDate" date,
    "Duration" timestamp without time zone,
    CONSTRAINT "Project_Audit_pkey" PRIMARY KEY ("PrID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Project_Audit"
    OWNER to postgres;


-- Table: IT_Company.Project_Updates

-- DROP TABLE IF EXISTS "IT_Company"."Project_Updates";

CREATE TABLE IF NOT EXISTS "IT_Company"."Project_Updates"
(
    "PrID" integer NOT NULL,
    "NewDeadline" date,
    "EntryDate" date,
    CONSTRAINT "Project_Updates_pkey" PRIMARY KEY ("PrID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Project_Updates"
    OWNER to postgres;

-- Table: IT_Company.Employee_Audit

-- DROP TABLE IF EXISTS "IT_Company"."Employee_Audit";

CREATE TABLE IF NOT EXISTS "IT_Company"."Employee_Audit"
(
    "EmpID" integer NOT NULL,
    "EntryDate" date,
    CONSTRAINT "Employee_Audit_pkey" PRIMARY KEY ("EmpID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "IT_Company"."Employee_Audit"
    OWNER to postgres;
