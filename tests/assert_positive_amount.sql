-- Fail if any orders have a non-positive amount
select
    *
from {{ source('dev_public', 'orders') }}
where amount <= 0

