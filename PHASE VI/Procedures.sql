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

    -- Insert new client
    INSERT INTO clients (client_id, full_name, email, phone, company, created_at)
    VALUES (clients_seq.NEXTVAL, p_full_name, p_email, p_phone, p_company, SYSDATE)
    RETURNING client_id INTO p_client_id;

    COMMIT;

EXCEPTION
    WHEN email_invalid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email format is invalid.');
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, 'Client already exists.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error adding client: ' || SQLERRM);
END;
/

---update

CREATE OR REPLACE PROCEDURE update_interaction_summary (
    p_interaction_id IN NUMBER,
    p_summary        IN VARCHAR2
)
IS
BEGIN
    UPDATE interactions
    SET summary = p_summary
    WHERE interaction_id = p_interaction_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Interaction not found.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error updating summary: ' || SQLERRM);
END;
/

---DELET

CREATE OR REPLACE PROCEDURE delete_followup (
    p_followup_id IN NUMBER
)
IS
BEGIN
    DELETE FROM followup_actions
    WHERE followup_id = p_followup_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Follow-up ID does not exist.');
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20021, 'Error deleting follow-up: ' || SQLERRM);
END;
/
 
 