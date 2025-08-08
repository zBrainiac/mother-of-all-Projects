-- ✅ VALID: Grant to specific role
GRANT SELECT ON TABLE RAW_IOT TO ROLE dk_aviation_audit;

-- ✅ VALID: Grant to a specific role with uppercase
GRANT USAGE ON DATABASE DataOps TO ROLE accountadmin;

-- ❌ INVALID: Grant to PUBLIC directly
GRANT SELECT ON TABLE RAW_IOT TO ROLE PUBLIC;

-- ❌ INVALID: Grant usage on schema to PUBLIC
GRANT USAGE ON SCHEMA IOT_DOMAIN_v001 TO PUBLIC;

-- ❌ INVALID: Grant all on future tables to PUBLIC
GRANT ALL ON FUTURE TABLES IN SCHEMA IOT_DOMAIN_v001 TO PUBLIC;

-- ❌ INVALID: With comments before
-- The next line is bad practice
GRANT USAGE ON DATABASE DataOps TO PUBLIC;

-- ✅ VALID: Commented out line
-- GRANT ALL ON DATABASE sensitive_db TO PUBLIC;

-- ✅ VALID: Another comment line
--GRANT USAGE ON SCHEMA confidential TO PUBLIC;

-- ❌ INVALID: Grant execute on procedure to PUBLIC
-- GRANT EXECUTE ON PROCEDURE my_proc() TO PUBLIC;

-- ❌ INVALID: With mixed casing
-- GrAnT SeLeCt On Table logs TO PuBlIc;