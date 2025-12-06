-- Basic retrieval
SELECT * FROM CLIENTS;
SELECT * FROM STAFF;
SELECT * FROM INTERACTIONS;

-- Joins
SELECT i.interaction_id, c.full_name AS client, s.full_name AS staff, t.type_name, i.summary
FROM INTERACTIONS i
JOIN CLIENTS c ON i.client_id = c.client_id
JOIN STAFF s ON i.staff_id = s.staff_id
JOIN INTERACTION_TYPES t ON i.type_id = t.type_id;

-- Aggregations
SELECT staff_id, COUNT(*) AS interactions_count
FROM INTERACTIONS
GROUP BY staff_id;

-- Subqueries
SELECT full_name, email
FROM CLIENTS
WHERE client_id IN (SELECT client_id FROM INTERACTIONS WHERE type_id = 1);

-- Data completeness check
SELECT COUNT(*) FROM CLIENTS WHERE full_name IS NULL;
SELECT COUNT(*) FROM INTERACTIONS WHERE summary IS NULL;

-- Foreign key integrity test (should fail if FK violated)
-- Example: Uncomment to test violation
-- INSERT INTO INTERACTIONS VALUES (11,999,1,1,SYSDATE,'Invalid client','None',SYSDATE);
