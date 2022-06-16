-- FUNCTION: IT_Company.empAuditFunc()

-- DROP FUNCTION IF EXISTS "IT_Company"."empAuditFunc"();

CREATE OR REPLACE FUNCTION "IT_Company"."empAuditFunc"()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
Begin
INSERT INTO Employee_Audit(EmpID , EntryDate) VALUES (new.EmpID, now());
      RETURN NEW;

End
$BODY$;

ALTER FUNCTION "IT_Company"."empAuditFunc"()
    OWNER TO postgres;





-- FUNCTION: IT_Company.projectAuditFunc()

-- DROP FUNCTION IF EXISTS "IT_Company"."projectAuditFunc"();

CREATE OR REPLACE FUNCTION "IT_Company"."projectAuditFunc"()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
Begin

INSERT INTO Project_Audit(PrID , EntryDate , Duration)
VALUES (new.PrID, now() , old.Deadline - old.StartDate);
      RETURN NEW;

End
$BODY$;

ALTER FUNCTION "IT_Company"."projectAuditFunc"()
    OWNER TO postgres;



-- FUNCTION: IT_Company.projectUpdateFunc()

-- DROP FUNCTION IF EXISTS "IT_Company"."projectUpdateFunc"();

CREATE OR REPLACE FUNCTION "IT_Company"."projectUpdateFunc"()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
Begin

IF new.Deadline <> old.Deadline THEN
    INSERT INTO Project_Updates(PrID , NewDeadline, EntryDate)
    VALUES(new.PrID , new.Deadline , now());
END IF;

End
$BODY$;

ALTER FUNCTION "IT_Company"."projectUpdateFunc"()
    OWNER TO postgres;



