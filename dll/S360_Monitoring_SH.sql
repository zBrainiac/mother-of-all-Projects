/*
S360_Monitoring_SH.sql

This script is used to prepare the Monitoring module for the Snowflake 360 package.

To initialize the script, set the acct_name and deployment variables to the
appropriate values, then execute all the USE and SET statements prior to the first slide.
*/

use database finance;
use schema customer;
use warehouse xsmall;

set acct_name = '<Salesforce account name>'; -- Salesforce account name
set deployment = '<deployment name>'; -- customer deployment (snowhouse_import schema)

set accts = (
    select to_json(array_agg(s.snowflake_account_id))
    from finance.customer.contract c
    join finance.customer.subscription s on c.salesforce_contract_id = s.salesforce_contract_id
    where c.salesforce_account_name = $acct_name
      and s.snowflake_deployment = $deployment
      and (c.contract_end_date > current_timestamp() or s.subscription_end_date > current_timestamp())
);


/*
---------------------------------------------------------------------------
Slide: Cloud Services Utilization

Insights to derive: When cloud service credits are above 10% of total credits
  for a billing period, they are billable to the customer. Cloud services
  credits should ideally stay below 10%.
---------------------------------------------------------------------------
*/


-- Metric Cloud Services Usage

select usage_date,
    sum(credits) as total_credits,
    sum(gs_credits) as cloud_credits,
    cloud_credits / total_credits as cloud_credit_ratio,
    case when cloud_credit_ratio <= .1 then 0
        else cloud_credits - (total_credits * .1) end cloud_credits_billed
from finance.metering_usage.warehouse_compute
where account_id in (select value::int from table(flatten(input => parse_json($accts))))
and usage_date >= dateadd(day,-100,current_date())
group by usage_date
order by usage_date;