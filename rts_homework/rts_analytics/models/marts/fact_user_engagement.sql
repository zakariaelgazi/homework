WITH content_views AS (
    SELECT * FROM {{ ref('int_content_views') }}
),

content_analytics AS (
    SELECT
        content_title_pretty,
        content_page_type,
        view_count,
        unique_session_count,
        unique_user_count,
        first_view_date,
        last_view_date,
        CASE
            WHEN content_page_type = 'VIDEO' THEN 'Vidéo'
            WHEN content_page_type = 'show' THEN 'Émission'
            WHEN content_page_type = 'liveTV' THEN 'TV en direct'
            WHEN content_page_type = 'embed' THEN 'Contenu intégré'
            WHEN content_page_type = 'showOverview' THEN 'Vue d''ensemble des émissions'
            WHEN content_page_type = 'topic' THEN 'Thématique'
            WHEN content_page_type = 'event' THEN 'Événement'
            ELSE content_page_type
        END AS content_type_fr,
        CASE 
            WHEN unique_session_count > 0 THEN ROUND((view_count::numeric / unique_session_count), 2)
            ELSE 0
        END AS views_per_session,
        CASE
            WHEN view_count > 100 THEN 'High'
            WHEN view_count > 10 THEN 'Medium'
            ELSE 'Low'
        END AS popularity_tier
    FROM content_views
)

SELECT * FROM content_analytics