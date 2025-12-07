CREATE OR REPLACE FUNCTION check_restrictions RETURN BOOLEAN
IS
    v_day     VARCHAR2(10);
    v_count   NUMBER;
BEGIN
    -- Get weekday
    v_day := TO_CHAR(SYSDATE, 'DY','NLS_DATE_LANGUAGE=ENGLISH');

    -- 1. Block weekdays (Mon-Fri)
    IF v_day IN ('MON','TUE','WED','THU','FRI') THEN
        RETURN FALSE;
    END IF;

    -- 2. Block Public Holidays (upcoming month only)
    SELECT COUNT(*) INTO v_count
    FROM holidays
    WHERE holiday_date = TRUNC(SYSDATE);

    IF v_count > 0 THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE; -- Weekend allowed
END;
/
