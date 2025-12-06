--Check invalid email-
BEGIN
    add_client('User', 'bad-email', '0788000000', 'ACME', NULL);
END;
/
  
--- TESTING procedure

SET SERVEROUTPUT ON;

DECLARE
    v_id NUMBER;
BEGIN
    add_client('Test User', 'test.user@mail.com', '0788123456', 'ACME', v_id);
    DBMS_OUTPUT.PUT_LINE('New Client ID: ' || v_id);
END;
/
