# Data Dictionary (sample)
| Table | Column | Type | Constraints | Purpose |
|-------|--------|------|-------------|---------|
| CLIENTS | CLIENT_ID | NUMBER(10) | PK | Unique client ID |
| CLIENTS | FULL_NAME | VARCHAR2(100) |  | Name |
| STAFF | STAFF_ID | NUMBER(10) | PK | Staff identifier |
| INTERACTIONS | INTERACTION_ID | NUMBER(10) | PK | Interaction record |
| FOLLOWUP_ACTIONS | FOLLOWUP_ID | NUMBER(10) | PK | Follow-up steps |
| HOLIDAYS | HOLIDAY_DATE | DATE | UNIQUE | Restricted dates |
| AUDIT_LOG | AUDIT_ID | NUMBER | PK | Audit records |
