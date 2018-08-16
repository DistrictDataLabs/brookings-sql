import pyodbc
import pandas as pd

config = dict(
    driver = '{ODBC Driver 17 for SQL Server}',
    server = 'tcp:brkressql01.database.windows.net',
    database = 'BRKRes01',
    username = '<your username>' ,
    password = '<your password>')

conn_str = ('DRIVER={driver};'+
    'SERVER={server};'+
    'DATABASE={database};'+
    'UID={username};'+
    'PWD={password}')

cnxn = pyodbc.connect(conn_str.format(**config))

# cnxn = pyodbc.connect('DRIVER={ODBC DRIVER 17 for SQL Server};SERVER='+
#     server +';DATABASE=' + database +
#     ';UID=' + username +
#     ';PWD=' + password)

#cnxn = pyodbc.connect('DSN={SQLBrookings};Database=BRKRes01;UID=<your username>;PWD=<your password>')
cursor = cnxn.cursor()

cursor.execute("select top 10 * from CRS1;")
#[column[0] for column in cursor.description]
pd.read_sql_query("select top 10 * from CRS1", cnxn)

for entry in cursor:
    print(entry)

donors = pd.read_sql('select * from Donors', cnxn)

query = '''SELECT
	 YEAR, SUM(Value) AS Total 
FROM CRS1 
WHERE
 CRS1.DONOR IN (SELECT DONOR FROM Donors WHERE DDescription='United States') AND
 CRS1.RECIPIENT IN (SELECT RECIPIENT FROM Recipients WHERE RDescription='India') AND
 CRS1.SECTOR IN (SELECT SECTOR from Sectors WHERE SDescription='Total All Sectors')
GROUP BY YEAR ORDER BY YEAR;'''

test = pd.read_sql(query, cnxn)
test.head()


# Find available tables
for table_name in cursor.tables(tableType='TABLE'):
    print(table_name)

# Find fields in table CRS1
pd.read_sql_query('select top 1 * from CRS1', cnxn).columns

# Upload a table to the DATABASE

import seaborn as sns
iris = sns.load_dataset('iris')
import sqlalchemy
import urllib
params = urllib.parse.quote_plus(conn_str.format(**config))
engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect={}".format(params), echo=False)
iris.to_sql('Iris', engine, if_exists='replace', index = False)
pd.io.sql.get_schema(iris.reset_index(),'Iris')


cursor.execute('drop table Iris')
cursor.commit()
cnxn.close()
