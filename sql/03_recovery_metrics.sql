-- ============================================================
-- 03_recovery_metrics.sql
-- COVID-19 Urban Traffic Recovery Analysis
-- Calculation of city-level traffic recovery metrics
-- ============================================================


-- ------------------------------------------------------------
-- 1. Weekly Average Congestion by City
-- ------------------------------------------------------------

WITH weekly_congestion AS (
    SELECT
        DATE_TRUNC(DATE(date_time), WEEK) AS week,
        city_name,
        AVG(percent_congestion) AS avg_congestion

    FROM `bigquery-public-data.covid19_geotab_mobility_impact.city_congestion`

    GROUP BY week, city_name
),


-- ------------------------------------------------------------
-- 2. Post-Recovery Average Congestion
--    Average congestion from January 2022 onward
-- ------------------------------------------------------------

post_recovery AS (
    SELECT
        city_name,
        AVG(percent_congestion) AS avg_congestion

    FROM `bigquery-public-data.covid19_geotab_mobility_impact.city_congestion`

    WHERE date_time >= '2022-01-01'

    GROUP BY city_name
),


-- ------------------------------------------------------------
-- 3. Identify Traffic Trough
--    Minimum weekly average congestion before 2021
-- ------------------------------------------------------------

trough AS (
    SELECT
        city_name,
        MIN(avg_congestion) AS minimum

    FROM weekly_congestion

    WHERE week < '2021-01-01'

    GROUP BY city_name
),


-- ------------------------------------------------------------
-- 4. Calculate Pre-COVID Baseline
--    Average weekly congestion before 2020-03-01
-- ------------------------------------------------------------

baseline AS (
    SELECT
        city_name,
        AVG(avg_congestion) AS baseline_avg

    FROM weekly_congestion

    WHERE week < '2020-03-01'

    GROUP BY city_name
),


-- ------------------------------------------------------------
-- 5. Calculate Recovery Metrics
-- ------------------------------------------------------------

recovery_metrics AS (
    SELECT
        p.city_name,

        -- Increase from the traffic trough
        ROUND(
            ((p.avg_congestion - t.minimum) / t.minimum) * 100,
            1
        ) AS increase_perc,

        -- Recovery relative to the pre-COVID baseline
        ROUND(
            (p.avg_congestion / b.baseline_avg) * 100,
            1
        ) AS recovery_vs_baseline,

        -- Traffic reduction from the pre-COVID baseline
        ROUND(
            (1 - t.minimum / b.baseline_avg) * 100,
            1
        ) AS drop_perc

    FROM post_recovery p

    JOIN trough t
        ON p.city_name = t.city_name

    JOIN baseline b
        ON p.city_name = b.city_name
)


-- ------------------------------------------------------------
-- 6. Final Result
-- ------------------------------------------------------------

SELECT *
FROM recovery_metrics
ORDER BY city_name;
