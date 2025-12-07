# Business Interaction Manager (BIM)

**Student:** Turikumana Jean Claude  
**Student ID:** 26989  
**Group:** MONDAY  
**Date:** December 2025

## Project Overview
This project implements an Oracle PL/SQL-driven Business Interaction Manager with:
- Database schema, PL/SQL modules, triggers and auditing
- Business-rule enforcement (weekday/holiday restrictions)
- BI-ready analytics and dashboards

## Problem Statement
Manual tracking of client interactions causes delays, missed follow-ups, and weak audit trails. BIM centralizes interaction logging, enforces rules, and provides analytical insights.

## Key Objectives
- Record client/staff interactions and follow-ups
- Enforce business rules via database triggers
- Maintain comprehensive audit logs
- Provide BI analytics (window functions, KPIs)

## Quick Start
1. Run `BusinessInteractionManager_full.sql` in your PDB.
2. Verify tables and sample data in SQL Developer.
3. Execute provided test blocks in `/docs/TestResults.md`.
4. Review presentation `/presentation/mon_26989_claude_BIM_presentation.pptx`.

## Links
- Full SQL script: `BusinessInteractionManager_full.sql`
- Presentation: `/presentation/mon_26989_claude_BIM_presentation.pptx`
- BI queries: `/BI/dashboard_queries.sql`

## Screenshots (placeholders in /docs)
- ER diagram: `/docs/ERD.png`
- SQL Developer structure: `/docs/sql_developer_structure.png`
- Sample data: `/docs/sample_data.png`
- Procedures/triggers editor: `/docs/procedure_trigger.png`
- Audit log entries: `/docs/audit_log.png`

## Data Dictionary (sample)
| Table | Column | Type | Constraints | Purpose |
|-------|--------|------|-------------|---------|
| CLIENTS | CLIENT_ID | NUMBER(10) | PK | Unique client identifier |
| CLIENTS | FULL_NAME | VARCHAR2(100) |  | Client name |
| STAFF | STAFF_ID | NUMBER(10) | PK | Staff identifier |
| INTERACTIONS | INTERACTION_ID | NUMBER(10) | PK | Interaction record |
| FOLLOWUP_ACTIONS | FOLLOWUP_ID | NUMBER(10) | PK | Follow-up steps |
| HOLIDAYS | HOLIDAY_DATE | DATE | UNIQUE | Restricted dates |
| AUDIT_LOG | AUDIT_ID | NUMBER | PK | Audit records |

## BI: KPIs & Dashboards
KPIs:
- Total interactions per staff (weekly/monthly)
- Pending follow-ups
- Number of denied operations (security)
- Average follow-up turnaround

Stakeholders:
- Management, Support Leads, Compliance

Reporting frequency:
- Daily (audit), Weekly (operational KPIs), Monthly (executive summary)

---

