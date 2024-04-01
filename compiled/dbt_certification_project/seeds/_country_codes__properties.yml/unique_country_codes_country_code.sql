
    
    

select
    country_code as unique_field,
    count(*) as n_records

from BOARDGAME.SEEDS.country_codes
where country_code is not null
group by country_code
having count(*) > 1


