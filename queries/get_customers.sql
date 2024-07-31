-- !preview conn=DBI::dbConnect(duckdb::duckdb(), "jaffle_db.duckdb", read_only = TRUE)
with customers as (
  select * from raw_customers
),
orders as (
  select * from raw_orders
),
payments as (
  select * from raw_payments
),
customer_orders as (
  select id,
         min(order_date) as first_order,
         max(order_date) as most_recent_order,
         count(id) as number_of_orders
  from orders
  group by id
),
customer_payments as (
  select orders.id,
         sum(amount) as total_amount
  from payments
  left join orders on payments.id = orders.id
  group by orders.id
),
final as (
  select
        customers.id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order,
        customer_orders.most_recent_order,
        customer_orders.number_of_orders,
        customer_payments.total_amount as customer_lifetime_value
  from customers
  left join customer_orders on customers.id = customer_orders.id
  left join customer_payments on  customers.id = customer_payments.id
)
select * from final
