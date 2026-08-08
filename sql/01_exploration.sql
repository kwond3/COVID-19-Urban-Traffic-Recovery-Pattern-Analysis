-- ============================================================
-- 01_exploration.sql
-- COVID-19 Urban Traffic Recovery Analysis
-- Initial data exploration and city-level trend analysis
-- ============================================================

-- ------------------------------------------------------------
-- 1. Atlanta: Pre- vs. Post-Lockdown Traffic by Hour
-- ------------------------------------------------------------

WITH atlanta_pre_post AS (
    SELECT
        EXTRACT(HOUR FROM date_time) AS hour,

        ROUND(
            AVG(
                CASE
                    WHEN DATE(date_time) < '2020-03-15'
                    THEN percent_congestion
                END
            ),
            2
        ) AS pre_lockdown,

        ROUND(
            AVG(
                CASE
                    WHEN DATE(date_time) >= '2020-03-15'
                    THEN percent_congestion
                END
            ),
            2
        ) AS post_lockdown

    FROM `bigquery-public-data.covid19_geotab_mobility_impact.city_congestion`

    WHERE city_name = 'Atlanta'

    GROUP BY hour
    ORDER BY hour
)

SELECT *
FROM atlanta_pre_post;


-- ------------------------------------------------------------
-- 2. Check Available Cities
-- ------------------------------------------------------------

SELECT DISTINCT
    city_name
FROM `bigquery-public-data.covid19_geotab_mobility_impact.city_congestion`
ORDER BY city_name;


-- ------------------------------------------------------------
-- 3. Weekly Average Congestion by City
-- ------------------------------------------------------------

WITH weekly_congestion AS (
    SELECT
        city_name,
        DATE_TRUNC(DATE(date_time), WEEK) AS week,
        AVG(percent_congestion) AS avg_congestion

    FROM `bigquery-public-data.covid19_geotab_mobility_impact.city_congestion`

    GROUP BY city_name, week
)

SELECT *
FROM weekly_congestion
ORDER BY city_name, week;


-- ------------------------------------------------------------
-- 4. Baseline Congestion by City
--    Baseline = Average congestion before 2020-03-01
-- ------------------------------------------------------------

SELECT
    city_name,
    AVG(percent_congestion) AS baseline_avg

FROM `bigquery-public-data.covid19_geotab_mobility_impact.city_congestion`

WHERE DATE(date_time) < '2020-03-01'

GROUP BY city_name
ORDER BY city_name;


-- ------------------------------------------------------------
-- 5. Weekly Congestion Comparison Across 8 Cities
-- ------------------------------------------------------------

SELECT
    DATE_TRUNC(DATE(date_time), WEEK) AS week,

    AVG(CASE WHEN city_name = 'Atlanta'
        THEN percent_congestion END) AS Atlanta,

    AVG(CASE WHEN city_name = 'Chicago'
        THEN percent_congestion END) AS Chicago,

    AVG(CASE WHEN city_name = 'Seattle'
        THEN percent_congestion END) AS Seattle,

    AVG(CASE WHEN city_name = 'New York'
        THEN percent_congestion END) AS New_York,

    AVG(CASE WHEN city_name = 'Washington'
        THEN percent_congestion END) AS Washington,

    AVG(CASE WHEN city_name = 'Los Angeles'
        THEN percent_congestion END) AS Los_Angeles,

    AVG(CASE WHEN city_name = 'San Francisco'
        THEN percent_congestion END) AS San_Francisco,

    AVG(CASE WHEN city_name = 'Ciudad de México'
        THEN percent_congestion END) AS Ciudad_de_Mexico

FROM `bigquery-public-data.covid19_geotab_mobility_impact.city_congestion`

GROUP BY week
ORDER BY week;
