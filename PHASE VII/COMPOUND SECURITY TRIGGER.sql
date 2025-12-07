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
