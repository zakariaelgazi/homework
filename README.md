# dbt Project: RTS Data Transformation

## Overview

This dbt project transforms raw event data from RTS (Radio Télévision Suisse) to create a robust and scalable data model for analysis and reporting. The project leverages Snowflake for data storage and Looker Studio for visualization.
This project transforms raw event data from RTS (Radio Télévision Suisse) into aggregated datamarts tailored to business needs. The focus is on creating user-friendly tables that are easy to interpret and directly usable for reporting, ensuring quick access to insights on the front end. This approach minimizes the need for complex data reconstruction, making it simpler for future collaborators to understand and extend the project.

Key decisions include:

* Prioritizing aggregated datamarts for fast and efficient reporting.
* Designing tables that are intuitive and aligned with business requirements.

## Project Structure

*   **models/**: Contains the dbt models.
    *   **staging/**: Models that clean and standardize raw data.
    *   **intermediate/**: Models that perform intermediate transformations and aggregations.
    *   **marts/**: Models that create the final fact tables for reporting.

## Installation

1.  **Install dbt:**

    ```
    pip install dbt-snowflake dbt-core  # or your adapter
    ```
2.  **Configure `profiles.yml`:**

    *   Ensure your `profiles.yml` is correctly configured to connect to your Snowflake database.
    *   Example:

        ```
        your_profile_name:
          target: dev
          outputs:
            dev:
              type: snowflake
              account: your_account
              user: your_user
              password: your_password
              database: your_database
              schema: your_schema
              warehouse: your_warehouse
              threads: 4
              role: your_role
        ```

## Usage

1.  **Clone the repository:**

    ```
    git clone <repository_url>
    cd <repository_directory>
    ```
2.  **Run dbt:**

    *   **dbt run:** Executes all models in the project.

        ```
        dbt build
        ```
    *   **dbt docs generate:**  Generates a documentation website for your project.

        ```
        dbt docs generate
        ```
    *   **dbt docs serve:**  Serves the documentation website locally.

        ```
        dbt docs serve
        ```

## Data Model Documentation

### Staging Models

*   **`stg_events`:**
    *   **Source**: Raw event data from Snowflake.
    *   **Purpose**: Cleans and standardizes the raw data, parsing timestamps, handling missing values, and casting data types.
    *   **Key Transformations**:
        *   Converts date and time fields to appropriate data types.
        *   Handles missing values and inconsistencies in the raw data.

### Intermediate Models

*   **`int_sessions`:**
    *   **Source**: `stg_events`
    *   **Purpose**: Aggregates event data into session-level information.
    *   **Key Metrics**:
        *   `session_start_time`:  Start time of the session.
        *   `session_end_time`: End time of the session.
        *   `events_count`: Total number of events in the session.
        *   `country_code`: Country code of the session.
        *   `region_code`: Region code of the session.
        *   `city`: City of the session.
        *   `is_bot`: Flag indicating if the session was from a bot.
        *   `session_completed`: Flag indicating if the session was completed.
*   **`int_content_views`:**
    *   **Source**: `stg_events`
    *   **Purpose**: Aggregates event data to determine content views.
    *   **Key Metrics**:
        *   `content_title_pretty`: Title of the content.
        *   `content_page_type`: Type of content page.
        *   `view_count`: Number of views for the content.
        *   `unique_session_count`: Number of unique sessions that viewed the content.
        *   `unique_user_count`: Number of unique users that viewed the content.
        *   `first_view_date`: Date of the first view.
        *   `last_view_date`: Date of the last view.
*   **`int_geographic_distribution`:**
    *   **Source**: `stg_events`
    *   **Purpose**: Aggregates event data to analyze geographic distribution.
    *   **Key Metrics**:
        *   `country_name`: Name of the country.
        *   `city`: City of the event.
        *   `view_count`: Number of views from the location.
        *   `unique_session_count`: Number of unique sessions from the location.
        *   `unique_user_count`: Number of unique users from the location.
        *   `first_view_date`: Date of the first view from the location.
        *   `last_view_date`: Date of the last view from the location.

### Marts Models

*   **`fact_content_analytics`:**
    *   **Source**: `int_content_views`
    *   **Purpose**: Provides analytics for content performance.
    *   **Key Metrics**:
        *   `content_title_pretty`: Title of the content.
        *   `content_page_type`: Type of content page.
        *   `view_count`: Number of views for the content.
        *   `unique_session_count`: Number of unique sessions.
        *   `unique_user_count`: Number of unique users.
        *   `first_view_date`: Date of the first view.
        *   `last_view_date`: Date of the last view.
        *   `content_type_fr`: Content type in French.
        *   `views_per_session`: Views per session.
        *   `popularity_tier`: Tier based on view count.
*   **`fact_summary_metrics`:**
    *   **Source**: `stg_events`
    *   **Purpose**: Summarizes key metrics from the events data.
    *   **Key Metrics**:
        *   `total_page_views`: Total number of page views.
        *   `unique_sessions`: Number of unique sessions.
        *   `unique_users`: Number of unique users.
        *   `unique_pages_viewed`: Number of unique pages viewed.
        *   `unique_contents_viewed`: Number of unique contents viewed.
        *   `video_views`: Number of video views.
        *   `live_tv_views`: Number of live TV views.
        *   `show_page_views`: Number of show page views.
        *   `livestream_views`: Number of livestream views.
        *   `avg_session_duration_seconds`: Average session duration in seconds.
        *   `countries_count`: Number of countries.
        *   `swiss_sessions`: Number of sessions from Switzerland.
        *   `international_sessions`: Number of sessions from outside Switzerland.
*   **`fact_audiance_geography`:**
    *   **Source**: `int_geographic_distribution`
    *   **Purpose**: Analyzes audience geography.
    *   **Key Metrics**:
        *   `country_name`: Name of the country.
        *   `city`: City of the view.
        *   `view_count`: Number of views from the location.
        *   `unique_session_count`: Number of unique sessions.
        *   `unique_user_count`: Number of unique users.
        *   `first_view_date`: Date of the first view.
        *   `last_view_date`: Date of the last view.
        *   `views_per_user`: Views per user.
        *   `audience_size_tier`: Tier based on user count.
*   **`fact_user_engagement`:**
    *   **Source**: `int_content_views`
    *   **Purpose**: Aggregates data to understand user engagement with content.
    *   **Key Metrics**:
        *   `content_title_pretty`: Title of the content.
        *   `content_page_type`: Type of content page.
        *   `view_count`: Total views per content item.
        *   `unique_session_count`: Number of unique sessions.
        *   `unique_user_count`: Number of unique users.
        *   `first_view_date`: Date of the first view.
        *   `last_view_date`: Date of the last view.
        *   `content_type_fr`: Content type in French.
        *   `views_per_session`: Average session duration on content pages.
        *   `popularity_tier`: Tier based on view count.

## Reporting made with Looker Studio

<img width="717" alt="Capture d’écran 2025-04-04 à 08 31 36" src="https://github.com/user-attachments/assets/bac5e0f9-e97d-406a-adcb-4adf5f458478" />
<img width="677" alt="Capture d’écran 2025-04-04 à 08 32 04" src="https://github.com/user-attachments/assets/706eb26e-b5d5-44b7-9c37-0944fb4da7f1" />
<img width="620" alt="Capture d’écran 2025-04-04 à 08 32 42" src="https://github.com/user-attachments/assets/a8f79e49-a2fb-44e3-b2cd-2632067ebfa2" />


