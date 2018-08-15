/* Important information for users

You have to define the DSN, or Data Source Name, on your computer before you can
use Stata to connect to the Database. On Windows, you can use the ODBC Data Sources app to 
define your data sources, which are associated with particular SQL drivers. 

In my experience, Stata connectivity does not work well on Macs or Linux machines
since the DSNs aren't properly read by Stata in those environments

You can see the available DSNs using "odbc list"
*/

clear
set more off
odbc list
odbc query, connectionstring("DSN=SQLBrookings;Database=BRKRes01;") u("<your username>") p("<your password>")
***********************************************************************************************************
local connstr "DSN=SQLBrookings;Database=BRKRes01;" /* Using macros */
odbc describe CRS1, connectionstring("`connstr'")

/* Load a table from the database */
local connstr "DSN=SQLBrookings;Database=BRKRes01;"
odbc load , table("Donors") connectionstring("`connstr'") clear

/* Execute a more complicated query and load the resultant table in Stata */
local connstr "DSN=SQLBrookings;Database=BRKRes01;"
local query1 "select Recipients.RDescription, CRS1.YEAR, CRS1.Value from CRS1 INNER JOIN Recipients on CRS1.RECIPIENT=Recipients.RECIPIENT WHERE Recipients.RDescription='India'"
odbc load Country="RDescription" Year="YEAR" Amount="Value" , exec("`query1'") clear connectionstring("`connstr'")

/* Execute a SQL command and see the results on screen */
odbc exec("select Recipients.RDescription, CRS1.Value from CRS1 INNER JOIN Recipients on CRS1.RECIPIENT=Recipients.RECIPIENT WHERE Recipients.RDescription='India';"),connectionstring("DSN=SQLBrookings;Database=BRKRes01;") 

/* Uploading your own data */
sysuse auto.dta, clear
local connstr "DSN=SQLBrookings;Database=BRKRes01;"
odbc insert make price mpg rep78 displacement gear_ratio, table("Auto") connectionstring("`connstr'") create sql
odbc describe Auto, connectionstring("`connstr'")
