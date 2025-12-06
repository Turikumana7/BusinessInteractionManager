
-- =========================================
--  FUNCTIONS (VALIDATION / LOOKUP / CALCULATION)
-- =========================================

-- 1) validate_email - returns 1 for valid, 0 otherwise
CREATE OR REPLACE FUNCTION validate_email(p_email IN VARCHAR2) RETURN NUMBER IS
BEGIN
  IF p_email IS NULL THEN
    RETURN 0;
  ELSIF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- log error
    INSERT INTO error_log(err_id, module_name, err_code, err_msg)
    VALUES (seq_audit.NEXTVAL, 'validate_email', SQLCODE, SUBSTR(SQLERRM,1,200));
    RETURN 0;
END validate_email;
/

-- 2) count_interactions - calculation
CREATE OR REPLACE FUNCTION count_interactions(p_client_id IN NUMBER) RETURN NUMBER IS
  v_total NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_total FROM interactions WHERE client_id = p_client_id;
  RETURN v_total;
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg)
    VALUES (seq_audit.NEXTVAL, 'count_interactions', SQLCODE, SUBSTR(SQLERRM,1,200));
    RETURN NULL;
END count_interactions;
/

-- 3) get_next_followup - lookup
CREATE OR REPLACE FUNCTION get_next_followup(p_interaction_id IN NUMBER) RETURN DATE IS
  v_dt DATE;
BEGIN
  SELECT next_followup INTO v_dt FROM interactions WHERE interaction_id = p_interaction_id;
  RETURN v_dt;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg)
    VALUES (seq_audit.NEXTVAL, 'get_next_followup', SQLCODE, SUBSTR(SQLERRM,1,200));
    RETURN NULL;
END get_next_followup;
/

-- =========================================
--  PROCEDURES (INSERT/UPDATE/DELETE) with IN/OUT and EXCEPTION HANDLING
-- =========================================

-- Procedure: add_client (IN params + OUT client_id)
CREATE OR REPLACE PROCEDURE add_client(
  p_full_name IN VARCHAR2,
  p_email     IN VARCHAR2,
  p_phone     IN VARCHAR2,
  p_company   IN VARCHAR2,
  p_client_id OUT NUMBER
) AS
BEGIN
  IF validate_email(p_email) = 0 THEN
    RAISE_APPLICATION_ERROR(-20001,'Invalid email format');
  END IF;

  INSERT INTO clients(client_id, full_name, email, phone, company, created_at)
  VALUES (seq_clients.NEXTVAL, p_full_name, p_email, p_phone, p_company, SYSDATE)
  RETURNING client_id INTO p_client_id;

  INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
  VALUES (seq_audit.NEXTVAL,'CLIENTS','INSERT',SYSDATE,USER,'ALLOWED','New client added');

  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'add_client',SQLCODE,'Duplicate client');
    RAISE;
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'add_client',SQLCODE,SUBSTR(SQLERRM,1,200));
    ROLLBACK;
    RAISE;
END add_client;
/

-- Procedure: update_interaction_summary (UPDATE)
CREATE OR REPLACE PROCEDURE update_interaction_summary(
  p_interaction_id IN NUMBER,
  p_summary        IN VARCHAR2
) AS
BEGIN
  UPDATE interactions SET summary = p_summary WHERE interaction_id = p_interaction_id;
  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20010,'Interaction not found');
  END IF;

  INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
  VALUES (seq_audit.NEXTVAL,'INTERACTIONS','UPDATE',SYSDATE,USER,'ALLOWED','Summary updated');

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'update_interaction_summary',SQLCODE,SUBSTR(SQLERRM,1,200));
    ROLLBACK;
    RAISE;
END update_interaction_summary;
/

-- Procedure: delete_followup (DELETE)
CREATE OR REPLACE PROCEDURE delete_followup(
  p_followup_id IN NUMBER
) AS
BEGIN
  DELETE FROM followup_actions WHERE followup_id = p_followup_id;
  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20020,'Follow-up not found');
  END IF;

  INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
  VALUES (seq_audit.NEXTVAL,'FOLLOWUP_ACTIONS','DELETE',SYSDATE,USER,'ALLOWED','Follow-up deleted');

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'delete_followup',SQLCODE,SUBSTR(SQLERRM,1,200));
    ROLLBACK;
    RAISE;
END delete_followup;
/

-- Procedure: add_interaction_using_pkg example below in package

-- =========================================
--  CURSORS & BULK OPERATIONS
-- =========================================

-- Example explicit cursor procedure to process upcoming followups
CREATE OR REPLACE PROCEDURE process_upcoming_followups IS
  CURSOR c_followups IS
    SELECT interaction_id, client_id, next_followup FROM interactions WHERE next_followup IS NOT NULL AND next_followup <= SYSDATE+7 ORDER BY next_followup;
  v_rec c_followups%ROWTYPE;
BEGIN
  OPEN c_followups;
  LOOP
    FETCH c_followups INTO v_rec;
    EXIT WHEN c_followups%NOTFOUND;
    -- Example processing: log to audit
    INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
    VALUES (seq_audit.NEXTVAL,'INTERACTIONS','PROCESS',SYSDATE,USER,'INFO','Processing followup for interaction '||v_rec.interaction_id);
  END LOOP;
  CLOSE c_followups;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'process_upcoming_followups',SQLCODE,SUBSTR(SQLERRM,1,200));
    ROLLBACK;
    RAISE;
END process_upcoming_followups;
/

-- Bulk collect example
CREATE OR REPLACE PROCEDURE bulk_notify_followups IS
  TYPE t_int IS TABLE OF interactions.interaction_id%TYPE;
  v_ids t_int;
BEGIN
  SELECT interaction_id BULK COLLECT INTO v_ids FROM interactions WHERE next_followup IS NOT NULL AND next_followup <= SYSDATE+3;
  IF v_ids.COUNT > 0 THEN
    FOR i IN 1..v_ids.COUNT LOOP
      INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
      VALUES (seq_audit.NEXTVAL,'INTERACTIONS','NOTIFY',SYSDATE,USER,'INFO','Notify for interaction '||v_ids(i));
    END LOOP;
  END IF;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'bulk_notify_followups',SQLCODE,SUBSTR(SQLERRM,1,200));
    ROLLBACK;
    RAISE;
END bulk_notify_followups;
/

-- =========================================
--  WINDOW FUNCTIONS (ANALYTICS QUERIES)
-- =========================================

-- 1) Ranking staff by number of interactions
-- Use as a query (not a stored object)
-- SELECT staff_id, COUNT(*) total_interactions, RANK() OVER (ORDER BY COUNT(*) DESC) interaction_rank
-- FROM interactions GROUP BY staff_id;

-- 2) Row number per client
-- SELECT client_id, interaction_id, ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY interaction_date) AS seq_num FROM interactions;

-- 3) LAG / LEAD example
-- SELECT interaction_id, interaction_date, LAG(interaction_date) OVER (ORDER BY interaction_date) prev_date, LEAD(interaction_date) OVER (ORDER BY interaction_date) next_date FROM interactions;

-- =========================================
--  PACKAGES (SPEC + BODY)
-- =========================================

CREATE OR REPLACE PACKAGE interaction_pkg IS
  PROCEDURE add_interaction(
    p_client_id IN NUMBER,
    p_staff_id  IN NUMBER,
    p_type_id   IN NUMBER,
    p_summary   IN VARCHAR2,
    p_next_followup IN DATE,
    p_out_id OUT NUMBER
  );
  FUNCTION total_interactions(p_client_id IN NUMBER) RETURN NUMBER;
  PROCEDURE safe_add_interaction(
    p_client_id IN NUMBER,
    p_staff_id  IN NUMBER,
    p_type_id   IN NUMBER,
    p_summary   IN VARCHAR2,
    p_next_followup IN DATE,
    p_message OUT VARCHAR2
  );
END interaction_pkg;
/

CREATE OR REPLACE PACKAGE BODY interaction_pkg IS

  PROCEDURE add_interaction(
    p_client_id IN NUMBER,
    p_staff_id  IN NUMBER,
    p_type_id   IN NUMBER,
    p_summary   IN VARCHAR2,
    p_next_followup IN DATE,
    p_out_id OUT NUMBER
  ) IS
  BEGIN
    p_out_id := seq_interactions.NEXTVAL;
    INSERT INTO interactions(interaction_id, client_id, staff_id, type_id, interaction_date, summary, action_required, next_followup)
    VALUES (p_out_id, p_client_id, p_staff_id, p_type_id, SYSDATE, p_summary, NULL, p_next_followup);

    INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
    VALUES (seq_audit.NEXTVAL,'INTERACTIONS','INSERT',SYSDATE,USER,'ALLOWED','Interaction added by package');

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'interaction_pkg.add_interaction',SQLCODE,SUBSTR(SQLERRM,1,400));
      ROLLBACK;
      RAISE;
  END add_interaction;

  FUNCTION total_interactions(p_client_id IN NUMBER) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_total FROM interactions WHERE client_id = p_client_id;
    RETURN v_total;
  EXCEPTION
    WHEN OTHERS THEN
      INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'interaction_pkg.total_interactions',SQLCODE,SUBSTR(SQLERRM,1,400));
      RETURN NULL;
  END total_interactions;

  PROCEDURE safe_add_interaction(
    p_client_id IN NUMBER,
    p_staff_id  IN NUMBER,
    p_type_id   IN NUMBER,
    p_summary   IN VARCHAR2,
    p_next_followup IN DATE,
    p_message OUT VARCHAR2
  ) IS
    v_id NUMBER;
  BEGIN
    add_interaction(p_client_id, p_staff_id, p_type_id, p_summary, p_next_followup, v_id);
    p_message := 'Interaction added, id='||v_id;
  EXCEPTION
    WHEN OTHERS THEN
      p_message := 'Error: '||SUBSTR(SQLERRM,1,200);
  END safe_add_interaction;

END interaction_pkg;
/

-- =========================================
--  TRIGGERS (BUSINESS RULE + AUDIT)
-- =========================================

-- Utility function: is_operation_allowed (1 allowed, 0 denied)
CREATE OR REPLACE FUNCTION is_operation_allowed RETURN NUMBER IS
  v_day VARCHAR2(3);
  v_cnt NUMBER := 0;
BEGIN
  v_day := TO_CHAR(TRUNC(SYSDATE),'DY','NLS_DATE_LANGUAGE=ENGLISH');
  IF v_day IN ('MON','TUE','WED','THU','FRI') THEN
    RETURN 0;
  END IF;

  SELECT COUNT(*) INTO v_cnt FROM holidays WHERE TRUNC(holiday_date) = TRUNC(SYSDATE);
  IF v_cnt > 0 THEN
    RETURN 0;
  END IF;

  RETURN 1;
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'is_operation_allowed',SQLCODE,SUBSTR(SQLERRM,1,200));
    RETURN 0;
END is_operation_allowed;
/

-- Row-level trigger to enforce business rules and audit
CREATE OR REPLACE TRIGGER trg_interactions_restrict
BEFORE INSERT OR UPDATE OR DELETE ON interactions
FOR EACH ROW
DECLARE
  v_allowed NUMBER;
BEGIN
  v_allowed := is_operation_allowed;
  IF v_allowed = 0 THEN
    INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
    VALUES (seq_audit.NEXTVAL,'INTERACTIONS',ORA_SYSEVENT,SYSDATE,USER,'DENIED','Business-rule: Weekday/Holiday restriction');
    RAISE_APPLICATION_ERROR(-20050,'DML operations on INTERACTIONS are not allowed on weekdays or holidays.');
  ELSE
    INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
    VALUES (seq_audit.NEXTVAL,'INTERACTIONS',ORA_SYSEVENT,SYSDATE,USER,'ALLOWED','DML allowed');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO error_log(err_id, module_name, err_code, err_msg) VALUES (seq_audit.NEXTVAL,'trg_interactions_restrict',SQLCODE,SUBSTR(SQLERRM,1,200));
    RAISE;
END trg_interactions_restrict;
/

-- Compound trigger example for statement-level auditing (interactions)
CREATE OR REPLACE TRIGGER trg_compound_interactions
FOR INSERT OR UPDATE OR DELETE ON interactions
COMPOUND TRIGGER
  TYPE t_audit IS RECORD (table_name VARCHAR2(30), operation VARCHAR2(10), username VARCHAR2(50), status VARCHAR2(20), reason VARCHAR2(200));
  TYPE t_audit_tab IS TABLE OF t_audit INDEX BY PLS_INTEGER;
  g_audits t_audit_tab;
BEFORE STATEMENT IS
BEGIN
  NULL;
END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN
  -- reuse is_operation_allowed to decide
  IF is_operation_allowed = 0 THEN
    g_audits(g_audits.COUNT+1).table_name := 'INTERACTIONS';
    g_audits(g_audits.COUNT).operation := ORA_SYSEVENT;
    -- The RAISE will be done after adding audit entry
    NULL;
  ELSE
    -- allowed; store info for after statement
    g_audits(g_audits.COUNT+1).table_name := 'INTERACTIONS';
    g_audits(g_audits.COUNT).operation := ORA_SYSEVENT;
    g_audits(g_audits.COUNT).username := USER;
    g_audits(g_audits.COUNT).status := 'ALLOWED';
    g_audits(g_audits.COUNT).reason := 'Compound: allowed';
  END IF;
END BEFORE EACH ROW;

AFTER STATEMENT IS
BEGIN
  -- insert audit_log rows
  FOR i IN 1..g_audits.COUNT LOOP
    INSERT INTO audit_log(audit_id, table_name, operation, action_date, username, status, reason)
    VALUES (seq_audit.NEXTVAL, g_audits(i).table_name, g_audits(i).operation, SYSDATE, NVL(g_audits(i).username,USER), NVL(g_audits(i).status,'DENIED'), NVL(g_audits(i).reason,'Compound trigger entry'));
  END LOOP;
  COMMIT;
END AFTER STATEMENT;
END trg_compound_interactions;
/

-- =========================================
--  TEST CASES & VALIDATION QUERIES
-- =========================================

-- Test 1: Attempt to insert interaction (depending on current day, may be allowed/denied)
DECLARE
  v_id NUMBER;
BEGIN
  BEGIN
    interaction_pkg.add_interaction(1,1,1,'Automated test interaction',SYSDATE+7,v_id);
    DBMS_OUTPUT.PUT_LINE('Added interaction id='||v_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Add failed: '||SQLERRM);
  END;
END;
/

-- Test 2: Call add_client with invalid email (should raise)
DECLARE
  v_new_id NUMBER;
BEGIN
  BEGIN
    add_client('Bad Email','not-an-email','0788000000','XCo',v_new_id);
    DBMS_OUTPUT.PUT_LINE('Client added id='||v_new_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Expected error: '||SQLERRM);
  END;
END;
/

-- Data integrity checks
-- 1. Count clients
SELECT COUNT(*) AS clients_count FROM clients;
-- 2. Check FK consistency (no orphan interactions)
SELECT COUNT(*) AS orphan_interactions FROM interactions i WHERE NOT EXISTS (SELECT 1 FROM clients c WHERE c.client_id = i.client_id);

-- Audit log sample
SELECT * FROM audit_log ORDER BY action_date DESC FETCH FIRST 20 ROWS ONLY;

-- =========================================
--  CLEANUP / UTILITY SCRIPTS (Optional)
-- =========================================

-- To drop all created objects - use carefully (uncomment if needed)
-- DROP TRIGGER trg_interactions_restrict;
-- DROP TRIGGER trg_compound_interactions;
-- DROP PACKAGE interaction_pkg;
-- DROP FUNCTION is_operation_allowed;
-- DROP PROCEDURE process_upcoming_followups;
-- DROP PROCEDURE bulk_notify_followups;
-- DROP PROCEDURE add_client;
-- DROP PROCEDURE update_interaction_summary;
-- DROP PROCEDURE delete_followup;
-- DROP FUNCTION validate_email;
-- DROP FUNCTION count_interactions;
-- DROP FUNCTION get_next_followup;
-- DROP TABLE audit_log;
-- DROP TABLE error_log;
-- DROP TABLE holidays;
-- DROP TABLE followup_actions;
-- DROP TABLE interactions;
-- DROP TABLE interaction_types;
-- DROP TABLE staff;
-- DROP TABLE clients;
-- DROP SEQUENCE seq_clients;
-- DROP SEQUENCE seq_staff;
-- DROP SEQUENCE seq_types;
-- DROP SEQUENCE seq_interactions;
-- DROP SEQUENCE seq_followups;
-- DROP SEQUENCE seq_audit;

COMMIT;
