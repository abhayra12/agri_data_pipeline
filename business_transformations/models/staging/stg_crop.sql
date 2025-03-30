with source as (
    select * from {{ ref('seed_crop') }}
)

select
    crop_id,
    crop_name,
    crop_type,
    growing_season,
    water_needs
from source 