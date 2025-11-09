# Online Sales Analytics

This portfolio project contains a series of Python-based analytical cases exploring sales performance, product popularity, and geographic distribution of an online retail store.  
All analysis and visualizations were built using **Python** with real e-commerce datasets.

---

## Project Overview

The goal of this repository is to demonstrate practical data analysis skills across three key domains:
- **Product Analytics** — identifying top-selling products and sales volume trends
- **Geographic Analytics** — revenue distribution across countries and markets  
- **Time Series Analytics** — seasonal patterns and order dynamics over time

### Tools Used
- **Python 3** for data analysis and visualization
- **Pandas** for data manipulation and aggregation
- **Matplotlib** for creating charts and graphs
- **CSV datasets** containing real e-commerce transaction data

---

## Repository Structure

| Folder | Description |
|---------|-------------|
| `data/` | Raw input datasets (Online_Retail.csv with invoice, product, customer data) |
| `analysis/product_analysis/` | Python scripts, results, and visualizations for product performance analysis |
| `analysis/geographic_analysis/` | Python scripts, results, and visualizations for sales distribution by country |
| `analysis/time_analysis/` | Time series analysis — monthly trends, seasonality, and order dynamics |

Each analysis folder includes:
- `query.py` — the Python script used for analysis
- `result.csv` — analysis output in CSV format  
- `.png` — visualization charts

---

## Analytical Tasks

### Product Analysis
| # | Task | Focus |
|---|------|--------|
| 1 | [Top Products by Sales Quantity](analysis/product_analysis/) | Identify 10 best-selling products by total units sold |

### Geographic Analysis  
| # | Task | Focus |
|---|------|--------|
| 1 | [Revenue Distribution by Country](analysis/geographic_analysis/) | Top 10 countries by total revenue with percentage breakdown |

### Time Series Analysis
| # | Task | Focus |
|---|------|--------|
| 1 | [Monthly Order Trends](analysis/time_analysis/) | Order volume dynamics and seasonal patterns over time |

---

## Example Visualizations

| Metric | Visualization |
|---------|----------|
| Top Products | ![Top Products](analysis/product_analysis/chart_top_products.png) |
| Revenue by Country | ![Revenue by Country](analysis/geographic_analysis/chart_sales_by_country.png) |
| Monthly Order Trends | ![Monthly Trends](analysis/time_analysis/chart_monthly_trends.png) |

---

## Key Insights

- **Product Popularity**: Low-cost home decor and gift items dominate sales volume, indicating mass-market appeal
- **Geographic Concentration**: United Kingdom represents the majority of revenue, with significant secondary markets in Netherlands, Ireland, Germany, and France  
- **Seasonal Patterns**: Clear end-of-year peak in orders (October-December) driven by holiday shopping season
- **Business Implications**: Focus marketing budget on UK market while developing targeted campaigns for European markets
