-----Function

SET SERVEROUTPUT ON;

DECLARE
    v_total NUMBER;
BEGIN
    v_total := count_interactions(1);

    DBMS_OUTPUT.PUT_LINE('Function Output = ' || v_total);

    IF v_total IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('TEST RESULT: FAIL (Returned NULL)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST RESULT: PASS (Function executed successfully)');
    END IF;
END;
/
