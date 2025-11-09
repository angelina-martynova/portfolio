import pandas as pd
import matplotlib.pyplot as plt
import os

# Load data from CSV file - use relative path
current_dir = os.path.dirname(os.path.abspath(__file__))
data_path = os.path.join(current_dir, "../../data/Online_Retail.csv")
df = pd.read_csv(data_path)

# Group by product name and calculate total quantity
top_products = df.groupby('Description')['Quantity'].sum().sort_values(ascending=False).head(10)

# Build bar chart
plt.figure(figsize=(12, 6))
top_products.plot(kind='bar')
plt.title('TOP-10 Most Popular Products by Sales Quantity')
plt.xlabel('Product Name')
plt.ylabel('Total Quantity Sold')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()

# Save chart to correct folder
chart_path = os.path.join(current_dir, "chart_top_products.png")
plt.savefig(chart_path, dpi=300, bbox_inches='tight')
plt.show()

# Save results to CSV in correct folder
result_path = os.path.join(current_dir, "result_1.csv")
top_products.to_csv(result_path, header=['Total_Quantity'])

print(f"Chart saved to: {chart_path}")
print(f"Results saved to: {result_path}")