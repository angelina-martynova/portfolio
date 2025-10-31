# 🚚 Courier Service Analytics

This project contains a series of SQL-based analytical tasks aimed at exploring user and courier activity, growth, and operational efficiency within a delivery service.  
All analysis and visualizations were performed in **Redash** using real-like datasets.

---

## 🧩 Project Overview

The goal of this project is to:
- analyze user and courier growth dynamics,
- evaluate engagement and delivery efficiency,
- and visualize the results through dashboards.

### 📊 Tools Used
- **SQL (PostgreSQL syntax)** for data analysis  
- **Redash** for query execution and visualization  
- **CSV datasets** for raw and aggregated data

---

## 📂 Repository Structure

| Folder | Description |
|---------|-------------|
| `data/` | Raw input datasets (users, couriers, orders, products, actions) |
| `analysis/` | SQL tasks, results, and dashboards grouped by topic |

Each analysis folder includes:
- `query.sql` — the SQL query used  
- `result.csv` — query output  
- `.png` — Redash dashboard visualizing key metrics  

---

## 🧠 Analytical Tasks

| # | Task | Focus |
|---|------|--------|
| 1 | [Users and couriers growth](analysis/01_users_and_couriers_growth/) | Growth of users and couriers over time |
| 2 | [Relative growth rates](analysis/02_relative_growth_rates/) | Daily percentage growth of new and total users/couriers |
| 3 | [Active users and couriers share](analysis/03_active_users_and_couriers_share/) | Share of paying users and active couriers |
| 4 | [Single vs multiple orders](analysis/04_users_with_single_vs_multiple_orders/) | Distribution of users by number of orders per day |
| 5 | [Order dynamics](analysis/05_order_dynamics/) | Total, first-time, and new-user orders |
| 6 | [Courier workload](analysis/06_courier_workload/) | Orders and users per active courier |
| 7 | [Average delivery time](analysis/07_average_delivery_time/) | Average delivery duration (minutes) |
| 8 | [Hourly load & cancel rate](analysis/08_hourly_load_and_cancel_rate/) | Orders and cancellations by hour |

---

## 📈 Example Dashboards

Here are a few examples of Redash visualizations created for this analysis:

| Metric | Example |
|---------|----------|
| User and courier growth | ![Example](analysis/01_users_and_couriers_growth/dashboard_total_users_vs_couriers.png) |
| Active user share | ![Example](analysis/03_active_users_and_couriers_share/dashboard_active_shares.png) |
| Hourly load | ![Example](analysis/08_hourly_load_and_cancel_rate/dashboard_hourly_load.png) |

---

## 🧭 Insights Summary

- The **user base grows faster** than couriers, showing strong demand growth.  
- The **relative growth rates** of new users are more volatile than couriers’.  
- The **average courier workload** stabilizes as courier count increases.  
- The **cancel rate peaks** during evening hours when order volume is highest.  

---

## 🪄 Author
**Angelina Martynova**  
*Data & Product Analytics Portfolio*  
📧 [Your Email] | 🌐 [LinkedIn Profile]
