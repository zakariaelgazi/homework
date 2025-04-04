WITH events AS (
    SELECT * FROM {{ ref('stg_events') }}
),
session_data AS (
    SELECT
        session_id,
        cookie_id,
        MIN(event_datetime) AS session_start_time,
        MAX(event_datetime) AS session_end_time,
        MAX(session_rank) AS events_count,
        ARRAY_AGG(DISTINCT url) AS visited_urls,
        ARRAY_AGG(DISTINCT content_page_type) AS content_types_viewed,
        ARRAY_AGG(DISTINCT content_title_pretty) AS content_titles_viewed,
        MIN(country_code) AS country_code,
        MIN(region_code) AS region_code,
        MIN(city) AS city,
        CASE WHEN BOOLAND_AGG(is_bot) THEN TRUE ELSE FALSE END AS is_bot,
        CASE WHEN BOOLAND_AGG(session_end) THEN TRUE ELSE FALSE END AS session_completed
    FROM events
    GROUP BY session_id, cookie_id
)
SELECT * FROM session_data

{{ config(materialized='table') }}
