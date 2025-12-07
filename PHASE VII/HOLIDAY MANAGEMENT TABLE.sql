-----HOLIDAY MANAGEMENT TABLE

CREATE TABLE holidays (
    holiday_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    holiday_date   DATE NOT NULL UNIQUE,
    description    VARCHAR2(200)
);

-- insert

INSERT INTO holidays (holiday_date, description)
VALUES (ADD_MONTHS(TRUNC(SYSDATE,'MM'),1), 'Month Opening Day');

INSERT INTO holidays (holiday_date, description)
VALUES (ADD_MONTHS(TRUNC(SYSDATE,'MM'),1) + 5, 'Public Celebration Day');
