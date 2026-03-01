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
)

select
    order_date,
    sum(amount)      as total_revenue,
    count(*)         as order_count
from completed_orders
group by order_date

