import sqlite3
import pandas as pd

f = open('databases/scu.sqlite3', 'w')  # Create file if not exists
f.close()

con = sqlite3.connect('databases/scu.sqlite3')
wb = pd.read_excel('dirty_data/scu.xlsx', sheet_name=None)
for table, df in wb.items():
    df.to_sql(table, con, if_exists="replace")

con.commit()
con.close()

print("SCU moved.")

f = open('databases/contracts.sqlite3', 'w')  # Create file if not exists
f.close()

con = sqlite3.connect('databases/contracts.sqlite3')
wb = pd.read_excel('dirty_data/contracts.xlsx', sheet_name=None)

for table, df in wb.items():
    df.to_sql(table, con, if_exists="replace")

con.commit()
con.close()

print("Contracts moved.")
