import pandas as pd
import matplotlib.pyplot as plt
import os

# Load data from CSV file - use relative path
current_dir = os.path.dirname(os.path.abspath(__file__))
data_path = os.path.join(current_dir, "../../data/Online_Retail.csv")
df = pd.read_csv(data_path)

# Create revenue data
df['TotalRevenue'] = df['Quantity'] * df['UnitPrice']
sales_by_country = df.groupby('Country')['TotalRevenue'].sum().sort_values(ascending=False).head(10)

# Calculations
total = sales_by_country.sum()
percentages = (sales_by_country.values / total) * 100

plt.figure(figsize=(13, 8))

# Create pie chart (return only wedges and texts)
wedges, texts = plt.pie(sales_by_country.values, 
                       labels=None,
                       startangle=90,
                       colors=plt.cm.Set3.colors)  # different colors

# Compact legend
legend_labels = [f'{country} ({percent:.1f}%)' 
                for country, percent in zip(sales_by_country.index, percentages)]

plt.legend(wedges, legend_labels,
          title=f"Countries (Total Revenue: ${total:,.0f})",
          loc="center left",
          bbox_to_anchor=(1, 0, 0.5, 1),
          frameon=True,
          fancybox=True,
          shadow=True)

plt.title('Revenue Distribution by Country (TOP-10)', fontsize=14, fontweight='bold')
plt.axis('equal')
plt.tight_layout()

# Save chart to correct folder
chart_path = os.path.join(current_dir, "chart_sales_by_country.png")
plt.savefig(chart_path, dpi=300, bbox_inches='tight')
plt.show()

# Save results to CSV in correct folder
result_path = os.path.join(current_dir, "result_2.csv")
sales_by_country.to_csv(result_path, header=['Total_Revenue'])

print(f"Chart saved to: {chart_path}")
print(f"Results saved to: {result_path}")