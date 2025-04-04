WITH events AS (
    SELECT * FROM {{ ref('stg_events') }}
),
daily_metrics AS (
    SELECT
        COUNT(*) AS total_page_views,
        COUNT(DISTINCT session_id) AS unique_sessions,
        COUNT(DISTINCT cookie_id) AS unique_users,
        COUNT(DISTINCT url) AS unique_pages_viewed,
        COUNT(DISTINCT content_title_pretty) AS unique_contents_viewed,
        SUM(CASE WHEN content_page_type = 'VIDEO' THEN 1 ELSE 0 END) AS video_views,
        SUM(CASE WHEN content_page_type = 'liveTV' THEN 1 ELSE 0 END) AS live_tv_views,
        SUM(CASE WHEN content_page_type = 'show' THEN 1 ELSE 0 END) AS show_page_views,
        SUM(CASE WHEN media_is_livestream = 'true' THEN 1 ELSE 0 END) AS livestream_views,
        AVG(session_timeout_monitor) AS avg_session_duration_seconds,
        COUNT(DISTINCT country_code) AS countries_count,
        COUNT(DISTINCT CASE WHEN country_code = 'CH' THEN session_id ELSE NULL END) AS swiss_sessions,
        COUNT(DISTINCT CASE WHEN country_code != 'CH' AND country_code IS NOT NULL THEN session_id ELSE NULL END) AS international_sessions
    FROM events
    WHERE is_bot = FALSE OR is_bot IS NULL
)
SELECT * FROM daily_metrics