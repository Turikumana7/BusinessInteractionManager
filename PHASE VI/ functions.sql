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


-----Function TEST 1 CHECKING EMAIL

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

-----Function TEST 1 CHECKING NUMBER OF interactions

DECLARE
    v_total NUMBER;
BEGIN
    v_total := count_interactions(1);
    DBMS_OUTPUT.PUT_LINE('Total Interactions = ' || v_total);
END;
/

-----Function TEST 1 CHECKING get next followup


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
