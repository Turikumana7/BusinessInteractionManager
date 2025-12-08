-- ADD CLIENt

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


---update

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



---Procedure: DELETE_FOLLOWUP (DELETE + IN)
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


---TESTING ADD_CLIENT

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



---TESTING update_client_phone

BEGIN
    update_client_phone(1, '0788888999');
    DBMS_OUTPUT.put_line('Phone updated successfully.');
END;
/

 
 
 ---TESTING DELETE_FOLLOWUP (DELETE + IN)
 BEGIN
    delete_followup(5);
    DBMS_OUTPUT.put_line('Follow-up deleted.');
END;
/

 

 
