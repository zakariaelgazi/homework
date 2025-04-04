WITH events AS (
    SELECT * FROM {{ ref('stg_events') }}
),
geo_distribution AS (
    SELECT
        country.country_name,
        e.city,
        COUNT(*) AS view_count,
        COUNT(DISTINCT e.session_id) AS unique_session_count,
        COUNT(DISTINCT e.cookie_id) AS unique_user_count,
        MIN(e.event_date) AS first_view_date,
        MAX(e.event_date) AS last_view_date
    FROM events as e left join {{ ref('referential_countries') }} as country on e.country_code = country.country_code
    WHERE e.country_code IS NOT NULL
    GROUP BY country.country_name, e.city
)
SELECT * FROM geo_distribution