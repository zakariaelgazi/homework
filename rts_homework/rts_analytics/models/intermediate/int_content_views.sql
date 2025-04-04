WITH events AS (
    SELECT * FROM {{ ref('stg_events') }}
),
content_views AS (
    SELECT
        content_title_pretty,
        content_page_type,
        COUNT(*) AS view_count,
        COUNT(DISTINCT session_id) AS unique_session_count,
        COUNT(DISTINCT cookie_id) AS unique_user_count,
        MIN(event_date) AS first_view_date,
        MAX(event_date) AS last_view_date
    FROM events
    WHERE content_title_pretty IS NOT NULL
    GROUP BY content_title_pretty, content_page_type
)
SELECT * FROM content_views