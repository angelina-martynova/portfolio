import os
import subprocess
import sys

def run_analysis(script_path):
    """Run a Python script and check if it executes successfully"""
    try:
        result = subprocess.run([sys.executable, script_path], 
                              capture_output=True, text=True, check=True)
        print(f"✓ Successfully executed: {script_path}")
        if result.stdout:
            print(f"Output: {result.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"✗ Error executing {script_path}: {e}")
        if e.stderr:
            print(f"Error details: {e.stderr}")

def main():
    print("Running Online Sales Analytics...")
    
    # Get the current directory
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Define paths to analysis scripts
    scripts = [
        os.path.join(current_dir, "analysis", "product_analysis", "01_top_products.py"),
        os.path.join(current_dir, "analysis", "geographic_analysis", "02_sales_by_country.py"),
        os.path.join(current_dir, "analysis", "time_analysis", "03_monthly_trends.py")
    ]
    
    # Run each analysis script
    for script in scripts:
        if os.path.exists(script):
            print(f"\n--- Running: {os.path.basename(script)} ---")
            run_analysis(script)
        else:
            print(f"\n✗ Script not found: {script}")
    
    print("\n All analyses completed!")

if __name__ == "__main__":
    main()