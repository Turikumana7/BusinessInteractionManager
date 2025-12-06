
-- CLIENTS Table
CREATE TABLE CLIENTS (
    client_id NUMBER(10) PRIMARY KEY,
    full_name VARCHAR2(100),
    email VARCHAR2(120),
    phone VARCHAR2(20),
    company VARCHAR2(120),
    created_at DATE
);

-- STAFF Table
CREATE TABLE STAFF (
    staff_id NUMBER(10) PRIMARY KEY,
    full_name VARCHAR2(100),
    role VARCHAR2(50),
    email VARCHAR2(100)
);

-- INTERACTION_TYPES Table
CREATE TABLE INTERACTION_TYPES (
    type_id NUMBER(10) PRIMARY KEY,
    type_name VARCHAR2(50)
);

-- INTERACTIONS Table
CREATE TABLE INTERACTIONS (
    interaction_id NUMBER(10) PRIMARY KEY,
    client_id NUMBER(10) REFERENCES CLIENTS(client_id),
    staff_id NUMBER(10) REFERENCES STAFF(staff_id),
    type_id NUMBER(10) REFERENCES INTERACTION_TYPES(type_id),
    interaction_date DATE,
    summary VARCHAR2(500),
    action_required VARCHAR2(200),
    next_followup DATE
);

-- FOLLOWUP_ACTIONS Table
CREATE TABLE FOLLOWUP_ACTIONS (
    followup_id NUMBER(10) PRIMARY KEY,
    interaction_id NUMBER(10) REFERENCES INTERACTIONS(interaction_id),
    followup_date DATE,
    status VARCHAR2(50),
    notes VARCHAR2(300)
);
