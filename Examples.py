import pyodbc


#cnxn = pyodbc.connect(
#  r'DRIVER={ODBC DRIVER 17 for SQL Server};'
#  r'SERVER=brkressql01.database.windows.net;'
#  r'DATABASE=BRKRes01;
#  r'UID=<your username>'
#  r'PWD=<your password>'
#)
cnxn = pyodbc.connect('DSN={SQLBrookings};Database=BRKRes01;UID=<your username>;PWD=<your password>')
cursor = cnxn.cursor()

