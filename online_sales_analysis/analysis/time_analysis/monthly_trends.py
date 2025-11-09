import pandas as pd
import matplotlib.pyplot as plt
import os

# Load data from CSV file - use relative path
current_dir = os.path.dirname(os.path.abspath(__file__))
data_path = os.path.join(current_dir, "../../data/Online_Retail.csv")
df = pd.read_csv(data_path)

# Convert InvoiceDate to datetime and create 'Month' column
df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])
df['Month'] = df['InvoiceDate'].dt.to_period('M')

# Group by months and count unique invoices (orders)
monthly_trends = df.groupby('Month')['InvoiceNo'].nunique()

# Build line chart
plt.figure(figsize=(12, 6))
monthly_trends.plot(kind='line', marker='o')
plt.title('Monthly Order Quantity Dynamics')
plt.xlabel('Month')
plt.ylabel('Number of Orders')
plt.grid(True)
plt.tight_layout()

# Save chart to correct folder
chart_path = os.path.join(current_dir, "chart_monthly_trends.png")
plt.savefig(chart_path, dpi=300, bbox_inches='tight')
plt.show()

# Save results to CSV in correct folder
result_path = os.path.join(current_dir, "result_3.csv")
monthly_trends.to_csv(result_path, header=['Order_Count'])

print(f"Chart saved to: {chart_path}")
print(f"Results saved to: {result_path}")