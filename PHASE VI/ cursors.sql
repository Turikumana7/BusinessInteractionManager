--Explicit Cursor Test
--This will print ALL 10 records you inserted.

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_interactions IS
        SELECT interaction_id, client_id, next_followup
        FROM interactions
        ORDER BY next_followup;

    v_row c_interactions%ROWTYPE;
BEGIN
    OPEN c_interactions;

    LOOP
        FETCH c_interactions INTO v_row;
        EXIT WHEN c_interactions%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
              'Interaction ID: ' || v_row.interaction_id
           || ' | Client ID: ' || v_row.client_id
           || ' | Follow-Up: ' || TO_CHAR(v_row.next_followup,'DD-MON-YYYY')
        );
    END LOOP;

    CLOSE c_interactions;
END;
/



--Cursor for UPCOMING Follow-ups (only future dates)
--This uses SYSDATE < NEXT_FOLLOWUP, perfect for your table.

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_upcoming IS
        SELECT interaction_id, client_id, next_followup
        FROM interactions
        WHERE next_followup >= SYSDATE
        ORDER BY next_followup;

    v_data c_upcoming%ROWTYPE;
BEGIN
    OPEN c_upcoming;

    LOOP
        FETCH c_upcoming INTO v_data;
        EXIT WHEN c_upcoming%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'UPCOMING → Interaction ' || v_data.interaction_id ||
            ' for Client ' || v_data.client_id ||
            ' on ' || TO_CHAR(v_data.next_followup,'DD-MON-YYYY')
        );
    END LOOP;

    CLOSE c_upcoming;
END;
/
--my dates are (10–30 Nov 2025) means  i can change date to see who is next



--Bulk Collect Cursor Test ( 10 records)
--Loads them all into memory and prints them.

SET SERVEROUTPUT ON;

DECLARE
    TYPE t_list IS TABLE OF interactions%ROWTYPE;
    v_list t_list;
BEGIN
    SELECT *
    BULK COLLECT INTO v_list
    FROM interactions
    ORDER BY next_followup;

    DBMS_OUTPUT.PUT_LINE('TOTAL ROWS: ' || v_list.COUNT);

    FOR i IN 1 .. v_list.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Bulk → Interaction ' || v_list(i).interaction_id ||
            ' | Client ' || v_list(i).client_id ||
            ' | Next: ' || TO_CHAR(v_list(i).next_followup,'DD-MON-YYYY')
        );
    END LOOP;
END;
/

