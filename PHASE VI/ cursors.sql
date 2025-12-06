---- Explicit Cursor – List All Upcoming Follow-Ups

DECLARE
    CURSOR c_followups IS
        SELECT interaction_id, client_id, next_followup
        FROM interactions
        WHERE next_followup >= SYSDATE
        ORDER BY next_followup;

    v_row c_followups%ROWTYPE;
BEGIN
    OPEN c_followups;

    LOOP
        FETCH c_followups INTO v_row;
        EXIT WHEN c_followups%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Interaction ' || v_row.interaction_id ||
            ' for client ' || v_row.client_id ||
            ' due on ' || v_row.next_followup
        );
    END LOOP;

    CLOSE c_followups;
END;
/

----Bulk Collect Cursor

DECLARE
    TYPE t_interactions IS TABLE OF interactions%ROWTYPE;
    v_list t_interactions;
BEGIN
    SELECT * BULK COLLECT INTO v_list
    FROM interactions
    WHERE next_followup <= SYSDATE + 7;

    FOR i IN 1..v_list.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Upcoming follow-up: ' || v_list(i).interaction_id
        );
    END LOOP;
END;
/

