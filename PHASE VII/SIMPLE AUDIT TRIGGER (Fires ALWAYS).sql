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
