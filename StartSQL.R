library(odbc)

odbcListDataSources()

cnxn <- dbConnect(odbc(), server="brkressql01.database.windows.net",
                  driver = "ODBC Driver 17 for SQL Server",
                  database="BRKRes01",
                  UID = "<your username>",
                  PWD = "<your password>")


head(dbListTables(cnxn))
dbGetQuery(cnxn, "select * from Cars")
res <- dbSendQuery(cnxn, 'select * from Cars')
d <- dbFetch(res)
dbListFields(cnxn,'Cars')


# See cash flows from US 
rs <- dbSendQuery(cnxn, 
                  "select * from CRS1 
	                  INNER JOIN Donors on CRS1.DONOR=Donors.DONOR
                  WHERE Donors.DDescription='United States' ORDER BY YEAR;")
dat <- list()
i <- 0
while(!dbHasCompleted(rs)){
  i <- i+1
  dat[[i]] <- dbFetch(rs, n = 1000)
}
final_dat <- do.call(rbind, dat)
dbClearResult(rs)
                  
dbDisconnect(cnxn)

