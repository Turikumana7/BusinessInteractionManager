-- CLIENTS
INSERT INTO CLIENTS VALUES (1, 'Alice Johnson', 'alice.johnson@example.com', '0788123456', 'Acme Corp', TO_DATE('2025-01-15','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (2, 'Bob Smith', 'bob.smith@example.com', '0788234567', 'Beta LLC', TO_DATE('2025-02-20','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (3, 'Carol Lee', 'carol.lee@example.com', '0788345678', 'Gamma Inc', TO_DATE('2025-03-10','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (4, 'David Kim', 'david.kim@example.com', '0788456789', 'Delta Ltd', TO_DATE('2025-04-05','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (5, 'Eva Brown', 'eva.brown@example.com', '0788567890', 'Epsilon Co', TO_DATE('2025-05-12','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (6, 'Frank Moore', 'frank.moore@example.com', NULL, 'Zeta Corp', TO_DATE('2025-06-01','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (7, 'Grace Hall', NULL, '0788678901', 'Eta LLC', TO_DATE('2025-07-18','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (8, 'Henry Adams', 'henry.adams@example.com', '0788789012', 'Theta Inc', NULL);
INSERT INTO CLIENTS VALUES (9, 'Isla White', 'isla.white@example.com', '0788890123', 'Iota Ltd', TO_DATE('2025-09-09','YYYY-MM-DD'));
INSERT INTO CLIENTS VALUES (10,'Jack Black','jack.black@example.com','0788901234','Kappa Co', TO_DATE('2025-10-01','YYYY-MM-DD'));

-- STAFF
INSERT INTO STAFF VALUES (1, 'Claude Monday', 'Manager', 'claude.monday@example.com');
INSERT INTO STAFF VALUES (2, 'Emma Watson', 'Sales', 'emma.watson@example.com');
INSERT INTO STAFF VALUES (3, 'Liam Neeson', 'Support', 'liam.neeson@example.com');
INSERT INTO STAFF VALUES (4, 'Olivia Brown', 'Sales', 'olivia.brown@example.com');
INSERT INTO STAFF VALUES (5, 'Noah Davis', 'Support', 'noah.davis@example.com');
INSERT INTO STAFF VALUES (6, 'Sophia Wilson', 'Manager', 'sophia.wilson@example.com');
INSERT INTO STAFF VALUES (7, 'Mason Taylor', 'Sales', 'mason.taylor@example.com');
INSERT INTO STAFF VALUES (8, 'Ava Martinez', 'Support', 'ava.martinez@example.com');
INSERT INTO STAFF VALUES (9, 'Ethan Thomas', 'Sales', 'ethan.thomas@example.com');
INSERT INTO STAFF VALUES (10,'Isabella Garcia','Support','isabella.garcia@example.com');

-- INTERACTION_TYPES
INSERT INTO INTERACTION_TYPES VALUES (1, 'Call');
INSERT INTO INTERACTION_TYPES VALUES (2, 'Email');
INSERT INTO INTERACTION_TYPES VALUES (3, 'Meeting');
INSERT INTO INTERACTION_TYPES VALUES (4, 'Demo');
INSERT INTO INTERACTION_TYPES VALUES (5, 'Follow-up');
INSERT INTO INTERACTION_TYPES VALUES (6, 'Complaint');
INSERT INTO INTERACTION_TYPES VALUES (7, 'Survey');
INSERT INTO INTERACTION_TYPES VALUES (8, 'Support Ticket');
INSERT INTO INTERACTION_TYPES VALUES (9, 'Onboarding');
INSERT INTO INTERACTION_TYPES VALUES (10,'Renewal');

-- INTERACTIONS
INSERT INTO INTERACTIONS VALUES (1, 1, 1, 1, TO_DATE('2025-11-01','YYYY-MM-DD'),'Initial call with client','Send proposal', TO_DATE('2025-11-10','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (2, 2, 2, 2, TO_DATE('2025-11-02','YYYY-MM-DD'),'Follow-up email','Schedule demo', TO_DATE('2025-11-12','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (3, 3, 3, 3, TO_DATE('2025-11-03','YYYY-MM-DD'),'In-person meeting','Send contract', TO_DATE('2025-11-15','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (4, 4, 4, 4, TO_DATE('2025-11-04','YYYY-MM-DD'),'Product demo','Gather feedback', TO_DATE('2025-11-20','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (5, 5, 5, 5, TO_DATE('2025-11-05','YYYY-MM-DD'),'Follow-up','Close deal', TO_DATE('2025-11-25','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (6, 6, 6, 6, TO_DATE('2025-11-06','YYYY-MM-DD'),'Complaint received','Investigate issue', TO_DATE('2025-11-18','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (7, 7, 7, 7, TO_DATE('2025-11-07','YYYY-MM-DD'),'Survey response','Analyze feedback', TO_DATE('2025-11-22','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (8, 8, 8, 8, TO_DATE('2025-11-08','YYYY-MM-DD'),'Support ticket','Resolve ticket', TO_DATE('2025-11-23','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (9, 9, 9, 9, TO_DATE('2025-11-09','YYYY-MM-DD'),'Onboarding session','Complete setup', TO_DATE('2025-11-26','YYYY-MM-DD'));
INSERT INTO INTERACTIONS VALUES (10,10,10,10,TO_DATE('2025-11-10','YYYY-MM-DD'),'Contract renewal','Sign new contract', TO_DATE('2025-11-30','YYYY-MM-DD'));

-- FOLLOWUP_ACTIONS
INSERT INTO FOLLOWUP_ACTIONS VALUES (1,1,TO_DATE('2025-11-11','YYYY-MM-DD'),'Pending','Waiting for client response');
INSERT INTO FOLLOWUP_ACTIONS VALUES (2,2,TO_DATE('2025-11-13','YYYY-MM-DD'),'Completed','Demo scheduled successfully');
INSERT INTO FOLLOWUP_ACTIONS VALUES (3,3,TO_DATE('2025-11-16','YYYY-MM-DD'),'Pending','Contract not yet signed');
INSERT INTO FOLLOWUP_ACTIONS VALUES (4,4,TO_DATE('2025-11-21','YYYY-MM-DD'),'Completed','Feedback received');
INSERT INTO FOLLOWUP_ACTIONS VALUES (5,5,TO_DATE('2025-11-26','YYYY-MM-DD'),'Pending','Deal not closed');
INSERT INTO FOLLOWUP_ACTIONS VALUES (6,6,TO_DATE('2025-11-19','YYYY-MM-DD'),'Completed','Issue resolved');
INSERT INTO FOLLOWUP_ACTIONS VALUES (7,7,TO_DATE('2025-11-23','YYYY-MM-DD'),'Pending','Analyze survey data');
INSERT INTO FOLLOWUP_ACTIONS VALUES (8,8,TO_DATE('2025-11-24','YYYY-MM-DD'),'Completed','Ticket resolved');
INSERT INTO FOLLOWUP_ACTIONS VALUES (9,9,TO_DATE('2025-11-27','YYYY-MM-DD'),'Pending','Setup not finished');
INSERT INTO FOLLOWUP_ACTIONS VALUES (10,10,TO_DATE('2025-12-01','YYYY-MM-DD'),'Pending','Contract pending client signature');
