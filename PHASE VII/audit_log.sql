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
