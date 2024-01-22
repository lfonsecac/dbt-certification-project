-- country_code_length_3.sql
-- Return country codes where the length of the code is different than 3
select
    country_name,
    country_code
from {{ ref('stg_country_codes' )}}
where length(country_code) != 3