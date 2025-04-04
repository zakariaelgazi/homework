WITH geo_distribution AS (
    SELECT * FROM {{ ref('int_geographic_distribution') }}
),
audience_geo AS (
    SELECT
        geo.country_name,
        geo.city,
        geo.view_count,
        geo.unique_session_count,
        geo.unique_user_count,
        geo.first_view_date,
        geo.last_view_date,
        CASE 
            WHEN geo.unique_user_count > 0 THEN ROUND((geo.view_count / geo.unique_user_count), 2)
            ELSE 0
        END AS views_per_user,
        CASE
            WHEN geo.unique_user_count > 10 THEN 'High'
            WHEN geo.unique_user_count > 1 THEN 'Medium'
            ELSE 'Low'
        END AS audience_size_tier
    FROM geo_distribution as geo
)
SELECT * FROM audience_geo