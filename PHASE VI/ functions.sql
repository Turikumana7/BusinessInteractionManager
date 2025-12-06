---Validate Email

CREATE OR REPLACE FUNCTION validate_email (
    p_email IN VARCHAR2
) RETURN BOOLEAN
IS
BEGIN
    RETURN REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
END;
/

--Calculate Total Interactions for a Client

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

----Lookup Next Follow-up Date

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
