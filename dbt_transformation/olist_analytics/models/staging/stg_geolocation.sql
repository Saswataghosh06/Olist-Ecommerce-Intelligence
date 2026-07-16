WITH raw_geo AS (
    SELECT * FROM {{ source('olist_raw', 'olist_geolocation_dataset') }}
),

deduplicated_geo AS (
    -- Group ONLY by zip_code to guarantee true uniqueness
    SELECT
        geolocation_zip_code_prefix AS zip_code,
        AVG(geolocation_lat) AS latitude,
        AVG(geolocation_lng) AS longitude
    FROM raw_geo
    GROUP BY 1
)

SELECT * FROM deduplicated_geo