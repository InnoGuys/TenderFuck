import sqlite3
import pandas as pd

f = open('databases/scu.db', 'w')  # Create file if not exists
f.close()

con = sqlite3.connect('databases/scu.db')
wb = pd.read_excel('dirty_data/scu.xlsx', sheet_name=None)
for table, df in wb.items():
    df.to_sql(table, con, if_exists="replace")

con.commit()
con.close()

print("SCU moved.")

f = open('databases/contracts.db', 'w')  # Create file if not exists
f.close()

con = sqlite3.connect('databases/contracts.db')
wb = pd.read_excel('dirty_data/contracts.xlsx', sheet_name=None)

for table, df in wb.items():
    df.to_sql(table, con, if_exists="replace")

con.commit()
con.close()

print("Contracts moved.")
