create or replace table warehouse_size_recommendation (bytes_scanned_lower integer, bytes_scanned_upper integer,  recommended_size varchar);
insert into warehouse_size_recommendation values

 (0,            1000000000      , 'X-Small')
,(1000000000,   10000000000     , 'Small')
,(10000000000,  20000000000     , 'Medium')
,(20000000000,  50000000000     , 'Large')
,(50000000000,  100000000000    , 'X-Large')
,(100000000000, 1000000000000   , '2X-Large')
;