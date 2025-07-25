-- context:
CREATE OR REPLACE TABLE warehouse_size_recommendation (
  bytes_scanned_lower INTEGER,
  bytes_scanned_upper INTEGER,
  recommended_size VARCHAR
);

INSERT INTO warehouse_size_recommendation VALUES
 (0,            1000000000      , 'X-Small')
,(1000000000,   10000000000     , 'Small')
,(10000000000,  20000000000     , 'Medium')
,(20000000000,  50000000000     , 'Large')
,(50000000000,  100000000000    , 'X-Large')
,(100000000000, 1000000000000   , '2X-Large');
