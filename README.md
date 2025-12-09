# Business Interaction Manager (BIM)

**Student:** Turikumana Jean Claude  
**Student ID:** 26989  
**Group:** MONDAY   
**Date:** 1 December 2025

## Project Overview
This project implements an Oracle PL/SQL-driven Business Interaction Manager with:
- Database schema, PL/SQL modules, triggers and auditing
- Business-rule enforcement (weekday/holiday restrictions)
- BI-ready analytics and dashboards

## Problem Statement
Manual tracking of client interactions causes delays, missed follow-ups, and weak audit trails. BIM centralizes interaction logging, enforces rules, and provides analytical insights.

## Key Objectives
- Record client/staff interactions and follow-ups
- Enforce business rules via database triggers
- Maintain comprehensive audit logs
- Provide BI analytics (window functions, KPIs)

## Business process modeling with diagram

<img width="1024" height="1536" alt="Diagram" src="https://github.com/user-attachments/assets/08d8aea0-b9e7-47f0-813c-002b207856b4" />


## CREATE/INSERT scripts + data validation
### tables

**CLIENTS Table**

CREATE TABLE CLIENTS (
    client_id NUMBER(10) PRIMARY KEY,
    full_name VARCHAR2(100),
    email VARCHAR2(120),
    phone VARCHAR2(20),
    company VARCHAR2(120),
    created_at DATE
);

**STAFF Table**

CREATE TABLE STAFF (
    staff_id NUMBER(10) PRIMARY KEY,
    full_name VARCHAR2(100),
    role VARCHAR2(50),
    email VARCHAR2(100)
);

**INTERACTION_TYPES Table**

CREATE TABLE INTERACTION_TYPES (
    type_id NUMBER(10) PRIMARY KEY,
    type_name VARCHAR2(50)
);

**INTERACTIONS Table**

CREATE TABLE INTERACTIONS (
    interaction_id NUMBER(10) PRIMARY KEY,
    client_id NUMBER(10) REFERENCES CLIENTS(client_id),
    staff_id NUMBER(10) REFERENCES STAFF(staff_id),
    type_id NUMBER(10) REFERENCES INTERACTION_TYPES(type_id),
    interaction_date DATE,
    summary VARCHAR2(500),
    action_required VARCHAR2(200),
    next_followup DATE
);

**FOLLOWUP_ACTIONS Table**

CREATE TABLE FOLLOWUP_ACTIONS (
    followup_id NUMBER(10) PRIMARY KEY,
    interaction_id NUMBER(10) REFERENCES INTERACTIONS(interaction_id),
    followup_date DATE,
    status VARCHAR2(50),
    notes VARCHAR2(300)
);
## INSERT

**CLIENTS**

INSERT INTO CLIENTS VALUES (1, 'Alice Johnson', 'alice.johnson@example.com', '0788123456', 'Acme Corp', TO_DATE('2025-01-15','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (2, 'Bob Smith', 'bob.smith@example.com', '0788234567', 'Beta LLC', TO_DATE('2025-02-20','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (3, 'Carol Lee', 'carol.lee@example.com', '0788345678', 'Gamma Inc', TO_DATE('2025-03-10','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (4, 'David Kim', 'david.kim@example.com', '0788456789', 'Delta Ltd', TO_DATE('2025-04-05','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (5, 'Eva Brown', 'eva.brown@example.com', '0788567890', 'Epsilon Co', TO_DATE('2025-05-12','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (6, 'Frank Moore', 'frank.moore@example.com', NULL, 'Zeta Corp', TO_DATE('2025-06-01','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (7, 'Grace Hall', NULL, '0788678901', 'Eta LLC', TO_DATE('2025-07-18','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (8, 'Henry Adams', 'henry.adams@example.com', '0788789012', 'Theta Inc', NULL);

INSERT INTO CLIENTS VALUES (9, 'Isla White', 'isla.white@example.com', '0788890123', 'Iota Ltd', TO_DATE('2025-09-09','YYYY-MM-DD'));

INSERT INTO CLIENTS VALUES (10,'Jack Black','jack.black@example.com','0788901234','Kappa Co', TO_DATE('2025-10-01','YYYY-MM-DD'));

**STAFF**

INSERT INTO STAFF VALUES (1, 'Claude Monday', 'Manager', 'claude.monday@example.com');

INSERT INTO STAFF VALUES (2, 'Emma Watson', 'Sales', 'emma.watson@example.com');

INSERT INTO STAFF VALUES (3, 'Liam Neeson', 'Support', 'liam.neeson@example.com');

INSERT INTO STAFF VALUES (4, 'Olivia Brown', 'Sales', 'olivia.brown@example.com');

INSERT INTO STAFF VALUES (5, 'Noah Davis', 'Support', 'noah.davis@example.com');

INSERT INTO STAFF VALUES (6, 'Sophia Wilson', 'Manager', 'sophia.wilson@example.com');

INSERT INTO STAFF VALUES (7, 'Mason Taylor', 'Sales', 'mason.taylor@example.com');

INSERT INTO STAFF VALUES (8, 'Ava Martinez', 'Support', 'ava.martinez@example.com');

INSERT INTO STAFF VALUES (9, 'Ethan Thomas', 'Sales', 'ethan.thomas@example.com');

INSERT INTO STAFF VALUES (10,'Isabella Garcia','Support','isabella.garcia@example.com');

**INTERACTION_TYPES**

INSERT INTO INTERACTION_TYPES VALUES (1, 'Call');

INSERT INTO INTERACTION_TYPES VALUES (2, 'Email');

INSERT INTO INTERACTION_TYPES VALUES (3, 'Meeting');

INSERT INTO INTERACTION_TYPES VALUES (4, 'Demo');

INSERT INTO INTERACTION_TYPES VALUES (5, 'Follow-up');

INSERT INTO INTERACTION_TYPES VALUES (6, 'Complaint');

INSERT INTO INTERACTION_TYPES VALUES (7, 'Survey');

INSERT INTO INTERACTION_TYPES VALUES (8, 'Support Ticket');

INSERT INTO INTERACTION_TYPES VALUES (9, 'Onboarding');

INSERT INTO INTERACTION_TYPES VALUES (10,'Renewal');

**INTERACTIONS**

INSERT INTO INTERACTIONS VALUES (1, 1, 1, 1, TO_DATE('2025-11-01','YYYY-MM-DD'),'Initial call with client','Send proposal', TO_DATE('2025-11-10','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (2, 2, 2, 2, TO_DATE('2025-11-02','YYYY-MM-DD'),'Follow-up email','Schedule demo', TO_DATE('2025-11-12','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (3, 3, 3, 3, TO_DATE('2025-11-03','YYYY-MM-DD'),'In-person meeting','Send contract', TO_DATE('2025-11-15','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (4, 4, 4, 4, TO_DATE('2025-11-04','YYYY-MM-DD'),'Product demo','Gather feedback', TO_DATE('2025-11-20','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (5, 5, 5, 5, TO_DATE('2025-11-05','YYYY-MM-DD'),'Follow-up','Close deal', TO_DATE('2025-11-25','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (6, 6, 6, 6, TO_DATE('2025-11-06','YYYY-MM-DD'),'Complaint received','Investigate issue', TO_DATE('2025-11-18','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (7, 7, 7, 7, TO_DATE('2025-11-07','YYYY-MM-DD'),'Survey response','Analyze feedback', TO_DATE('2025-11-22','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (8, 8, 8, 8, TO_DATE('2025-11-08','YYYY-MM-DD'),'Support ticket','Resolve ticket', TO_DATE('2025-11-23','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (9, 9, 9, 9, TO_DATE('2025-11-09','YYYY-MM-DD'),'Onboarding session','Complete setup', TO_DATE('2025-11-26','YYYY-MM-DD'));

INSERT INTO INTERACTIONS VALUES (10,10,10,10,TO_DATE('2025-11-10','YYYY-MM-DD'),'Contract renewal','Sign new contract', TO_DATE('2025-11-30','YYYY-MM-DD'));

**FOLLOWUP_ACTIONS**

INSERT INTO FOLLOWUP_ACTIONS VALUES (1,1,TO_DATE('2025-11-11','YYYY-MM-DD'),'Pending','Waiting for client response');

INSERT INTO FOLLOWUP_ACTIONS VALUES (2,2,TO_DATE('2025-11-13','YYYY-MM-DD'),'Completed','Demo scheduled successfully');

INSERT INTO FOLLOWUP_ACTIONS VALUES (3,3,TO_DATE('2025-11-16','YYYY-MM-DD'),'Pending','Contract not yet signed');

INSERT INTO FOLLOWUP_ACTIONS VALUES (4,4,TO_DATE('2025-11-21','YYYY-MM-DD'),'Completed','Feedback received');

INSERT INTO FOLLOWUP_ACTIONS VALUES (5,5,TO_DATE('2025-11-26','YYYY-MM-DD'),'Pending','Deal not closed');

INSERT INTO FOLLOWUP_ACTIONS VALUES (6,6,TO_DATE('2025-11-19','YYYY-MM-DD'),'Completed','Issue resolved');

INSERT INTO FOLLOWUP_ACTIONS VALUES (7,7,TO_DATE('2025-11-23','YYYY-MM-DD'),'Pending','Analyze survey data');

INSERT INTO FOLLOWUP_ACTIONS VALUES (8,8,TO_DATE('2025-11-24','YYYY-MM-DD'),'Completed','Ticket resolved');

INSERT INTO FOLLOWUP_ACTIONS VALUES (9,9,TO_DATE('2025-11-27','YYYY-MM-DD'),'Pending','Setup not finished');

INSERT INTO FOLLOWUP_ACTIONS VALUES (10,10,TO_DATE('2025-12-01','YYYY-MM-DD'),'Pending','Contract pending client signature');


## SAMPLE DATA

<img width="1366" height="768" alt="Screenshot (41)" src="https://github.com/user-attachments/assets/2dd65699-9600-4826-ad65-20ac7a7c4882" />


## ERD of all table



<img width="3306" height="5361" alt="deepseek_mermaid_20251209_543349" src="https://github.com/user-attachments/assets/abad07b5-cf20-4b1b-b894-9fc82b55b05d" />


## Data Dictionary (sample)
| Table | Column | Type | Constraints | Purpose |
|-------|--------|------|-------------|---------|
| CLIENTS | CLIENT_ID | NUMBER(10) | PK | Unique client identifier |
| CLIENTS | FULL_NAME | VARCHAR2(100) |  | Client name |
| STAFF | STAFF_ID | NUMBER(10) | PK | Staff identifier |
| INTERACTIONS | INTERACTION_ID | NUMBER(10) | PK | Interaction record |
| FOLLOWUP_ACTIONS | FOLLOWUP_ID | NUMBER(10) | PK | Follow-up steps |
| HOLIDAYS | HOLIDAY_DATE | DATE | UNIQUE | Restricted dates |
| AUDIT_LOG | AUDIT_ID | NUMBER | PK | Audit records |

## FUNCTIONS

**Validate Email**

CREATE OR REPLACE FUNCTION validate_email (
    p_email IN VARCHAR2
) RETURN BOOLEAN
IS
BEGIN
    RETURN REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
END;
/

**Calculate Total Interactions for a Client**

CREATE OR REPLACE FUNCTION count_interactions (
    p_client_id IN NUMBER
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM interactions
    WHERE client_id = p_client_id;

    RETURN v_total;
END;
/

**Lookup Next Follow-up Date**

CREATE OR REPLACE FUNCTION get_next_followup (
    p_interaction_id IN NUMBER
) RETURN DATE
IS
    v_date DATE;
BEGIN
    SELECT next_followup
    INTO v_date
    FROM interactions
    WHERE interaction_id = p_interaction_id;

    RETURN v_date;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/


**Function TEST 1 CHECKING EMAIL**

DECLARE
    v_result BOOLEAN;
BEGIN
    v_result := validate_email('invalid_email');
    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('VALID EMAIL');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INVALID EMAIL');
    END IF;
END;
/

**Function TEST 1 CHECKING NUMBER OF interactions**

DECLARE
    v_total NUMBER;
BEGIN
    v_total := count_interactions(1);
    DBMS_OUTPUT.PUT_LINE('Total Interactions = ' || v_total);
END;
/

**Function TEST 1 CHECKING get next followup**


DECLARE
    v_date DATE;
BEGIN
    v_date := get_next_followup(10);

    IF v_date IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('No follow-up found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Next follow-up: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
    END IF;
END;
/

## OUTPUTS

1.<img width="1366" height="768" alt="Screenshot (53)" src="https://github.com/user-attachments/assets/846a2a6d-7e41-4402-8bf6-81da581da4f5" />

2.<img width="1366" height="768" alt="Screenshot (54)" src="https://github.com/user-attachments/assets/d0790f8c-c2e4-4682-9200-bf50a41a4988" />

3.
<img width="1366" height="768" alt="Screenshot (55)" src="https://github.com/user-attachments/assets/077bbf06-4787-4c1a-b879-7f9c7a7e3a79" />



## Procedure 

**ADD CLIENt**

CREATE OR REPLACE PROCEDURE add_client (
    p_full_name   IN  VARCHAR2,
    p_email       IN  VARCHAR2,
    p_phone       IN  VARCHAR2,
    p_company     IN  VARCHAR2,
    p_client_id   OUT NUMBER
)
IS
    email_invalid EXCEPTION;
BEGIN
    -- Validate email format
    IF NOT validate_email(p_email) THEN
        RAISE email_invalid;
    END IF;

    -- Insert client
    INSERT INTO clients (client_id, full_name, email, phone, company, created_at)
    VALUES (clients_seq.NEXTVAL, p_full_name, p_email, p_phone, p_company, SYSDATE)
    RETURNING client_id INTO p_client_id;

EXCEPTION
    WHEN email_invalid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid email format.');
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, 'Client already exists.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error adding client: ' || SQLERRM);
END;
/


**update**

CREATE OR REPLACE PROCEDURE update_client_phone (
    p_client_id IN NUMBER,
    p_new_phone IN VARCHAR2
)
IS
BEGIN
    UPDATE clients
    SET phone = p_new_phone
    WHERE client_id = p_client_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Client ID not found.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error updating phone: ' || SQLERRM);
END;
/



**Procedure: DELETE_FOLLOWUP (DELETE + IN)**

CREATE OR REPLACE PROCEDURE delete_followup (
    p_followup_id IN NUMBER
)
IS
BEGIN
    DELETE FROM followup_actions
    WHERE followup_id = p_followup_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'Follow-up not found.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20031, 'Error deleting follow-up: ' || SQLERRM);
END;
/


**TESTING ADD_CLIENT**

DECLARE
    v_id NUMBER;
BEGIN
    add_client(
        p_full_name => 'Alice Green',
        p_email     => 'alice.green@gmail.com',
        p_phone     => '0788001122',
        p_company   => 'GreenTech',
        p_client_id => v_id
    );

    DBMS_OUTPUT.put_line('Client Created, ID = ' || v_id);
END;
/



**TESTING update_client_phone**

BEGIN
    update_client_phone(1, '0788888999');
    DBMS_OUTPUT.put_line('Phone updated successfully.');
END;
/

 
 
**TESTING DELETE_FOLLOWUP (DELETE + IN)**
 
 BEGIN
    delete_followup(5);
    DBMS_OUTPUT.put_line('Follow-up deleted.');
END;
/

## OUTPUTS

<img width="1366" height="768" alt="Screenshot (60)" src="https://github.com/user-attachments/assets/1126b122-e50f-4699-988f-beb936e5658f" />

 
 
 <img width="1366" height="768" alt="Screenshot (61)" src="https://github.com/user-attachments/assets/02744231-8b56-416d-bd28-45d1fdddd7de" />


## Cursor

--Explicit Cursor Test
--This will print ALL 10 records you inserted.

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_interactions IS
        SELECT interaction_id, client_id, next_followup
        FROM interactions
        ORDER BY next_followup;

    v_row c_interactions%ROWTYPE;
BEGIN
    OPEN c_interactions;

    LOOP
        FETCH c_interactions INTO v_row;
        EXIT WHEN c_interactions%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
              'Interaction ID: ' || v_row.interaction_id
           || ' | Client ID: ' || v_row.client_id
           || ' | Follow-Up: ' || TO_CHAR(v_row.next_followup,'DD-MON-YYYY')
        );
    END LOOP;

    CLOSE c_interactions;
END;
/



--Cursor for UPCOMING Follow-ups (only future dates)
--This uses SYSDATE < NEXT_FOLLOWUP, perfect for your table.

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_upcoming IS
        SELECT interaction_id, client_id, next_followup
        FROM interactions
        WHERE next_followup >= SYSDATE
        ORDER BY next_followup;

    v_data c_upcoming%ROWTYPE;
BEGIN
    OPEN c_upcoming;

    LOOP
        FETCH c_upcoming INTO v_data;
        EXIT WHEN c_upcoming%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'UPCOMING → Interaction ' || v_data.interaction_id ||
            ' for Client ' || v_data.client_id ||
            ' on ' || TO_CHAR(v_data.next_followup,'DD-MON-YYYY')
        );
    END LOOP;

    CLOSE c_upcoming;
END;
/
--my dates are (10–30 Nov 2025) means  i can change date to see who is next



--Bulk Collect Cursor Test ( 10 records)
--Loads them all into memory and prints them.

SET SERVEROUTPUT ON;

DECLARE
    TYPE t_list IS TABLE OF interactions%ROWTYPE;
    v_list t_list;
BEGIN
    SELECT *
    BULK COLLECT INTO v_list
    FROM interactions
    ORDER BY next_followup;

    DBMS_OUTPUT.PUT_LINE('TOTAL ROWS: ' || v_list.COUNT);

    FOR i IN 1 .. v_list.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Bulk → Interaction ' || v_list(i).interaction_id ||
            ' | Client ' || v_list(i).client_id ||
            ' | Next: ' || TO_CHAR(v_list(i).next_followup,'DD-MON-YYYY')
        );
    END LOOP;
END;
/

## OUTPUTS
1
<img width="1366" height="768" alt="Screenshot (71)" src="https://github.com/user-attachments/assets/415c8da0-09a1-4cf2-bf3e-354b292d2b17" />
2
<img width="1366" height="768" alt="Screenshot (72)" src="https://github.com/user-attachments/assets/52051708-85aa-449a-be45-e71aad6a461a" />
3
<img width="1366" height="768" alt="Screenshot (73)" src="https://github.com/user-attachments/assets/e27270eb-ceb8-4d23-8ef1-105967428e3a" />


## Window Functions

--Ranking Staff by # of Interactions

SELECT staff_id, 
       COUNT(*) AS total_interactions,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS interaction_rank
FROM interactions
GROUP BY staff_id;

---Compare Interaction Dates – LAG/LEAD

SELECT interaction_id,
       interaction_date,
       LAG(interaction_date) OVER (ORDER BY interaction_date) AS previous_interaction,
       LEAD(interaction_date) OVER (ORDER BY interaction_date) AS next_interaction
FROM interactions;

---ROW_NUMBER() per Client

SELECT client_id, interaction_id,
       ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY interaction_date) AS seq_num
FROM interactions;


##OUTPUT 

1 
<img width="1366" height="768" alt="Screenshot (75)" src="https://github.com/user-attachments/assets/14682c54-384f-409d-a2d8-2d59e517018d" />

2
<img width="1366" height="768" alt="Screenshot (76)" src="https://github.com/user-attachments/assets/68a42105-44e1-4c74-af89-3b84e02d88f2" />

3
<img width="1366" height="768" alt="Screenshot (77)" src="https://github.com/user-attachments/assets/3959a873-b433-44de-8490-a330150c5043" />

## TRIGGER

---COMPOUND SECURITY TRIGGER

CREATE OR REPLACE TRIGGER trg_interactions_security
FOR INSERT OR UPDATE OR DELETE ON interactions
COMPOUND TRIGGER

    v_allowed BOOLEAN;

BEFORE STATEMENT IS
BEGIN
    v_allowed := check_restrictions;

    IF NOT v_allowed THEN
        log_action(
            p_table     => 'INTERACTIONS',
            p_operation => 'BLOCKED',
            p_status    => 'DENIED',
            p_pk_value  => 'N/A',
            p_error     => 'OPERATION BLOCKED: Weekdays and public holidays not allowed.'
        );

        RAISE_APPLICATION_ERROR(
            -20999,
            'SECURITY VIOLATION: Changes allowed only on weekends.'
        );
    END IF;
END BEFORE STATEMENT;

END trg_interactions_security;
/

## HOLIDAY

-----HOLIDAY MANAGEMENT TABLE

CREATE TABLE holidays (
    holiday_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    holiday_date   DATE NOT NULL UNIQUE,
    description    VARCHAR2(200)
);

-- insert

INSERT INTO holidays (holiday_date, description)
VALUES (ADD_MONTHS(TRUNC(SYSDATE,'MM'),1), 'Month Opening Day');

INSERT INTO holidays (holiday_date, description)
VALUES (ADD_MONTHS(TRUNC(SYSDATE,'MM'),1) + 5, 'Public Celebration Day');

CREATE OR REPLACE FUNCTION check_restrictions RETURN BOOLEAN
IS
    v_day     VARCHAR2(10);
    v_count   NUMBER;
BEGIN
    -- Get weekday
    v_day := TO_CHAR(SYSDATE, 'DY','NLS_DATE_LANGUAGE=ENGLISH');

    -- 1. Block weekdays (Mon-Fri)
    IF v_day IN ('MON','TUE','WED','THU','FRI') THEN
        RETURN FALSE;
    END IF;

    -- 2. Block Public Holidays (upcoming month only)
    SELECT COUNT(*) INTO v_count
    FROM holidays
    WHERE holiday_date = TRUNC(SYSDATE);

    IF v_count > 0 THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE; -- Weekend allowed
END;
/

## audit

CREATE TABLE audit_log (
    audit_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name     VARCHAR2(50),
    operation_type VARCHAR2(10),
    user_name      VARCHAR2(50),
    attempt_time   DATE DEFAULT SYSDATE,
    status         VARCHAR2(20),
    error_message  VARCHAR2(400),
    pk_value       VARCHAR2(50)
);

---audit_log
CREATE OR REPLACE FUNCTION log_action (
    p_table      VARCHAR2,
    p_operation  VARCHAR2,
    p_status     VARCHAR2,
    p_pk_value   VARCHAR2,
    p_error      VARCHAR2 DEFAULT NULL
) RETURN NUMBER
IS
    v_id NUMBER;
BEGIN
    INSERT INTO audit_log (table_name, operation_type, user_name, status, error_message, pk_value)
    VALUES (p_table, p_operation, USER, p_status, p_error, p_pk_value)
    RETURNING audit_id INTO v_id;

    RETURN v_id;
END;
/

CREATE OR REPLACE TRIGGER trg_interactions_audit
AFTER INSERT OR UPDATE OR DELETE ON interactions
FOR EACH ROW
BEGIN
    log_action(
        p_table     => 'INTERACTIONS',
        p_operation => CASE 
                           WHEN INSERTING THEN 'INSERT'
                           WHEN UPDATING THEN 'UPDATE'
                           WHEN DELETING THEN 'DELETE'
                       END,
        p_status    => 'SUCCESS',
        p_pk_value  => NVL(:NEW.interaction_id, :OLD.interaction_id)
    );
END;
/

## TEST Trigger

--TEST 1: Trigger blocks INSERT on weekday (DENIED)
--Run on Monday–Friday:

INSERT INTO interactions (interaction_id, client_id, staff_id, type_id, summary)
VALUES (999, 1, 1, 1, 'Weekday attempt');

--? Raises error
--? Logged as DENIED


--TEST 2: Trigger ALLOWS INSERT on weekend (ALLOWED)
--Run on Saturday or Sunday:

INSERT INTO interactions (interaction_id, client_id, staff_id, type_id, summary)
VALUES (1000, 1, 1, 1, 'Weekend allowed');

--? Insert succeeds
--? Logged as SUCCESS



--TEST 3: Trigger blocks on PUBLIC HOLIDAY
--Set system date or use a holiday entry for today:

INSERT INTO interactions (interaction_id, client_id, staff_id, type_id, summary)
VALUES (2000, 1, 1, 1, 'Holiday attempt');
--? DENIED
--? Logged with holiday violation



--TEST 4: View audit log
SELECT *
FROM audit_log
ORDER BY attempt_time DESC;














- Full SQL script: `BusinessInteractionManager_full.sql`
- Presentation: `/presentation/mon_26989_claude_BIM_presentation.pptx`
- BI queries: `/BI/dashboard_queries.sql`

## Screenshots (placeholders in /docs)
- ER diagram: `/docs/ERD.png`
- SQL Developer structure:
  
- Sample data: `/docs/sample_data.png`
- Procedures/triggers editor: `/docs/procedure_trigger.png`
- Audit log entries: `/docs/audit_log.png`

## BI: KPIs & Dashboards
KPIs:
- Total interactions per staff (weekly/monthly)
- Pending follow-ups
- Number of denied operations (security)
- Average follow-up turnaround

---

