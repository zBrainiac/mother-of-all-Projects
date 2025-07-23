README - Execution Order and Naming Convention
==============================================

This directory contains SQL or infrastructure files that are executed in **alphabetical order**, which follows this pattern:

    0-9 → A-Z

This means that file execution order depends on their **prefixes**, so careful naming is important to ensure the correct sequence.

------------------------------------------------------------
Recommended Naming Convention for File Execution
------------------------------------------------------------

To guarantee proper execution of dependent components (e.g., tables before views), please follow the suggested prefix structure:

  00_  Network infrastructure setup and supporting processes
       - Example: 00_network_setup.sql

  10_  Database creation or configuration
       - Example: 10_create_database.sql

  20_  Schema definitions
       - Example: 20_define_schemas.sql

  30_  Table objects and base data structures
       - Example: 30_create_tables.sql

  40_  Table-dependent objects like views, materialized views, etc.
       - Example: 40_create_views.sql

------------------------------------------------------------
Important Notes
------------------------------------------------------------

- Prefixes should always be **two-digit numbers** (e.g., 00, 10, 20) followed by an underscore.
- Do **not** use alphabetical prefixes (e.g., `A_`, `B_`) if execution order matters — stick with numeric prefixes.
- Use additional numbering (e.g., `30_01_`, `30_02_`) if you need fine-grained control within a group.

This convention helps ensure reliable and repeatable execution when processing files in sequence using scripts or automation tools.