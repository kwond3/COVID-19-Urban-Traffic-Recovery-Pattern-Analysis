-- ============================================================
-- 02_data_quality_check.sql
-- COVID-19 Urban Traffic Recovery Analysis
-- Data completeness check for commercial traffic data
-- ============================================================


-- ------------------------------------------------------------
-- 1. Weekly Commercial Traffic by Country/Region
-- ------------------------------------------------------------

WITH weekly_commercial AS (
    SELECT
        country_iso_code_2,
        DATE_TRUNC(date, WEEK) AS week,

        AVG(percent_of_baseline_commercial) AS commercial,
        AVG(percent_of_baseline_industrial) AS industrial,
        AVG(percent_of_baseline_warehouse) AS warehouse,
        AVG(percent_of_baseline_grocery_store) AS grocery,
        AVG(percent_of_baseline_other_retail) AS other_retail

    FROM `bigquery-public-data.covid19_geotab_mobility_impact.commercial_traffic`

    WHERE country_iso_code_2 IS NOT NULL

    GROUP BY country_iso_code_2, week
)


-- ------------------------------------------------------------
-- 2. Check Data Availability for Selected Locations
-- ------------------------------------------------------------

SELECT
    country_iso_code_2,

    COUNT(*) AS total_records,

    COUNT(commercial) AS commercial_records,
    COUNT(industrial) AS industrial_records,
    COUNT(warehouse) AS warehouse_records,
    COUNT(grocery) AS grocery_records,
    COUNT(other_retail) AS other_retail_records

FROM weekly_commercial

WHERE country_iso_code_2 IN (
    'US-GA',
    'US-IL',
    'US-WA',
    'US-NY',
    'US-DC',
    'US-CA',
    'MX-CMX'
)

GROUP BY country_iso_code_2

ORDER BY country_iso_code_2;
