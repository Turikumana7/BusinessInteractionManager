--TEST 1: Trigger blocks INSERT on weekday (DENIED)
--Run on Monday–Friday:

INSERT INTO interactions (interaction_id, client_id, staff_id, type_id, summary)
VALUES (999, 1, 1, 1, 'Weekday attempt');

--? Raises error
--? Logged as DENIED


--TEST 2: Trigger ALLOWS INSERT on weekend (ALLOWED)
--Run on Saturday or Sunday:

INSERT INTO interactions (interaction_id, client_id, staff_id, type_id, summary)
VALUES (1000, 1, 1, 1, 'Weekend allowed');

--? Insert succeeds
--? Logged as SUCCESS



--TEST 3: Trigger blocks on PUBLIC HOLIDAY
--Set system date or use a holiday entry for today:

INSERT INTO interactions (interaction_id, client_id, staff_id, type_id, summary)
VALUES (2000, 1, 1, 1, 'Holiday attempt');
--? DENIED
--? Logged with holiday violation



--TEST 4: View audit log
SELECT *
FROM audit_log
ORDER BY attempt_time DESC;
