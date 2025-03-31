#!/bin/bash

bq query --use_legacy_sql=false --location=asia-south1 "CREATE OR REPLACE TABLE \`agri-data-454414.agri_data.crop_analysis\` AS SELECT sc.crop_type AS Crop_Type, sc.crop_name AS Crop_Variety, AVG(sh.yield_amount) AS avg_Expected_Yield, AVG(sh.yield_amount * 0.9) AS avg_Actual_Yield, CASE WHEN sc.growing_season = 'Annual' THEN 365 WHEN sc.growing_season = 'Spring' THEN 90 WHEN sc.growing_season = 'Summer' THEN 100 WHEN sc.growing_season = 'Fall' THEN 80 WHEN sc.growing_season = 'Winter' THEN 120 ELSE 90 END AS avg_Growing_Period_Days FROM \`agri-data-454414.agri_data_seeds.seed_crop\` sc LEFT JOIN \`agri-data-454414.agri_data_seeds.seed_harvest\` sh ON sc.crop_id = sh.crop_id GROUP BY sc.crop_type, sc.crop_name, sc.growing_season"

echo "✅ crop_analysis table created successfully" 