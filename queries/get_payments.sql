-- !preview conn=DBI::dbConnect(duckdb::duckdb(), "jaffle_db.duckdb", read_only = TRUE)
select
order_id,
{% for payment_method in params.payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{% if not loop.is_last %},{% endif %}
{% endfor %}
from raw_payments
group by 1
