{{ config(
    materialized='table'
) }}

with completed_orders as (
    select
        order_id,
        customer_id,
        order_date,
        amount,
        status
    from {{ source('dev_public', 'orders') }}
    where upper(status) = 'COMPLETED'
),

orders_agg as (
    select
        customer_id,
        sum(amount)        as total_revenue,
        count(*)           as order_count,
        min(order_date)    as first_order_date,
        max(order_date)    as last_order_date
    from completed_orders
    group by customer_id
)

select
    o.customer_id,
    c.email,
    o.total_revenue,
    o.order_count,
    o.first_order_date,
    o.last_order_date
from orders_agg o
join {{ source('dev_public', 'customers') }} c
    on o.customer_id = c.customer_id

