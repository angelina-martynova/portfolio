# 06 — Cumulative ARPPU vs CAC

### Goal
Track cumulative revenue per paying user versus acquisition cost over time to determine payback period.

### Metrics
- `cumulative_arppu` — cumulative average revenue per paying user
- `cac` — customer acquisition cost
- `ads_campaign` — marketing campaign identifier
- `day` — day number since campaign start (0-7)
- `revenue` — daily cumulative revenue

### Insights
- Campaign #1 exceeds CAC on Day 5 (1464.25 vs 1461.99)
- Campaign #2 never reaches CAC within 7 days (1051.21 vs 1068.38)
- Campaign #1 shows faster payback period
- Cumulative ARPPU growth rate differs significantly between campaigns

### Visualizations
- ARPPU vs CAC timeline
- Payback period analysis
- Cumulative revenue growth

![Chart](chart_arppu_vs_cac_campaign1.png)
![Chart](chart_arppu_vs_cac_campaign2.png)
