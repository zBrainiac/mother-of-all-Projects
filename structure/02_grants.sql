-- ✅ VALID: Grant to specific role
GRANT SELECT ON TABLE my_table TO ROLE analyst;

-- ✅ VALID: Grant to a specific role with uppercase
GRANT USAGE ON DATABASE my_db TO ROLE ADMIN;

-- ✅ VALID: Grant to a role with extra spacing
GRANT     INSERT     ON     SCHEMA my_schema     TO     ROLE dev;

-- ❌ INVALID: Grant to PUBLIC directly
GRANT SELECT ON TABLE sensitive_table TO PUBLIC;

-- ❌ INVALID: Grant usage on schema to PUBLIC
GRANT USAGE ON SCHEMA finance_schema TO PUBLIC;

-- ❌ INVALID: Grant all on future tables to PUBLIC
GRANT ALL ON FUTURE TABLES IN SCHEMA finance_schema TO PUBLIC;

-- ❌ INVALID: Grant execute on procedure to PUBLIC
GRANT EXECUTE ON PROCEDURE my_proc() TO PUBLIC;

-- ❌ INVALID: With mixed casing
GrAnT SeLeCt On Table logs TO PuBlIc;

-- ❌ INVALID: With comments before
-- The next line is bad practice
GRANT USAGE ON DATABASE internal_db TO PUBLIC;

-- ✅ VALID: Commented out line
-- GRANT ALL ON DATABASE sensitive_db TO PUBLIC;

-- ✅ VALID: Another comment line
--GRANT USAGE ON SCHEMA confidential TO PUBLIC;
