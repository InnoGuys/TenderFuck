import sqlalchemy as db

engine = db.create_engine('sqlite:///databases/scu.sqlite3')
connection = engine.connect()
metadata = db.MetaData()
table = db.Table('Запрос1', metadata, autoload=True, autoload_with=engine)
print(table.columns.keys())
print(repr(metadata.tables['Запрос1']))

print("\nSCU end.\n")


engine = db.create_engine('sqlite:///databases/contracts.sqlite3')
connection = engine.connect()
metadata = db.MetaData()
table = db.Table('Запрос1', metadata, autoload=True, autoload_with=engine)
print(table.columns.keys())
print(repr(metadata.tables['Запрос1']))

print("\nContracts end.\n")


