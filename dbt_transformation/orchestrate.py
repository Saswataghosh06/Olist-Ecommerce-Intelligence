import subprocess
import sys
from datetime import datetime

def run_pipeline():
    print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] 🚀 Initiating Medallion Architecture Pipeline...")
    
    # The exact path to your dbt project
    dbt_project_path = r"D:\O-List Ecommerce DBT pipeline\dbt_transformation\olist_analytics"
    
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] -> Waking up Databricks and running dbt build...\n")
    print("=== dbt Execution Logs (Streaming) ===")
    
    try:
        # Popen allows us to stream the output to the terminal in real-time
        process = subprocess.Popen(
            ["uv", "run", "dbt", "build"],
            cwd=dbt_project_path,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            shell=True 
        )
        
        # Print each line to the terminal the exact second dbt generates it
        for line in process.stdout:
            print(line, end="")
            
        process.wait() # Wait for the pipeline to finish entirely
        
        if process.returncode == 0:
            print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] ✅ Pipeline completed successfully!")
        else:
            print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] ❌ Pipeline failed! (See logs above)")
            
    except KeyboardInterrupt:
        print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] 🛑 Process manually stopped by user (Ctrl+C).")

if __name__ == "__main__":
    run_pipeline()