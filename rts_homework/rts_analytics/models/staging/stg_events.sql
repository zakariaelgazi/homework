WITH source AS (
    SELECT * FROM main.events
),

cleaned AS (
    SELECT
        BUSINESS_UNIT,
        BACKEND_SYSTEM,
        PRODUCT,
        TYPE,
        COOKIE_ID,
        CAST(EVENT_ARRIVAL_TIME_CET AS timestamp) AS event_timestamp,
        DATE(event_timestamp) as event_date,
        SESSION_ID,
        SESSION_RANK,
        URL,
        REFERRER,
        USER_AGENT,
        TIMESTAMP::bigint / 1000 AS unix_timestamp,
        to_timestamp(TIMESTAMP::bigint / 1000) AS event_datetime,
        LANGUAGE,
        CONTENT_PAGE_TYPE,
        CONTENT_TITLE_PRETTY,
        COUNTRY_CODE,
        REGION_CODE,
        CITY,
        MEDIA_IS_LIVESTREAM,
        MEDIA_IS_GEOBLOCKED,
        MEDIA_FULL_LENGTH,
        SESSION_TIMEOUT_MONITOR,
        CASE 
            WHEN IS_BOT = 'true' THEN TRUE
            WHEN IS_BOT = 'false' THEN FALSE
            ELSE NULL
        END AS is_bot,
        CASE 
            WHEN SESSION_END = 'true' THEN TRUE
            WHEN SESSION_END = 'false' THEN FALSE
            ELSE NULL
        END AS session_end,
        DEVICE_TYPE,
        SCREEN_RESOLUTION,
        VIEWPORT_SIZE,
        CONTENT_CATEGORY_1,
        CONTENT_CATEGORY_2
    FROM source
)

SELECT * FROM cleaned