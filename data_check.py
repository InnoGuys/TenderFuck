# import sqlite3
#
# con = sqlite3.connect('databases/scu.db')
# # print("contacts row count: " + str(con.cursor().rowcount))
# con.commit()
# con.close()
# print("SCU data closed.")
#
# con = sqlite3.connect('databases/contracts.db')
# # print("contacts row count: " + str(con.cursor().rowcount))
# con.commit()
# con.close()
# print("Contracts data closed.")


import sqlalchemy as db

engine = db.create_engine('sqlite:///databases/scu.db')
connection = engine.connect()
metadata = db.MetaData()
table = db.Table('Запрос1', metadata, autoload=True, autoload_with=engine)
print(table.columns.keys())
print(repr(metadata.tables['Запрос1']))

print("\nSCU end.\n")


engine = db.create_engine('sqlite:///databases/contracts.db')
connection = engine.connect()
metadata = db.MetaData()
table = db.Table('Запрос1', metadata, autoload=True, autoload_with=engine)
print(table.columns.keys())
print(repr(metadata.tables['Запрос1']))

print("\nContracts end.\n")


