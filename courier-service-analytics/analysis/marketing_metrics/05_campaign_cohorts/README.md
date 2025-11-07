# 05 — Campaign Cohorts

### Goal
Calculate retention rates for users from each marketing campaign on specific days (0, 1, 7).

### Metrics
- `retention` — retention rate for campaign cohorts
- `ads_campaign` — marketing campaign identifier
- `day_number` — specific retention day (0, 1, 7)
- `start_date` — cohort start date (2022-09-01)
- `cohort_size` — number of users in campaign cohort

### Insights
- Campaign #1 shows significantly higher retention rates
- Day 1 retention: 42% (Campaign #1) vs 17% (Campaign #2)
- Day 7 retention: 22% (Campaign #1) vs 9% (Campaign #2)
- Retention difference explains ROI variance between campaigns

### Visualizations
- Campaign retention comparison
- Cohort retention curves
- Retention decay analysis

![Chart](chart_campaign_retention.png)
![Chart](chart_retention_decay.png)
