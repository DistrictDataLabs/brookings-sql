library(odbc)

odbcListDataSources()

cnxn <- dbConnect(odbc(), server="brkressql01.database.windows.net",
                  driver = "ODBC Driver 17 for SQL Server",
                  database="BRKRes01",
                  UID = "<your username>",
                  PWD = "<your password>")


head(dbListTables(cnxn)) # Show available tables

dbListFields(cnxn,'Cars') # Show fields in Cars

D <- dbGetQuery(cnxn, "select * from Cars")
res <- dbSendQuery(cnxn, 'select * from Cars')
d <- dbFetch(res)


# See cash flows from US to India
query <- "SELECT YEAR, SUM(Value) AS Total 
    FROM CRS1 
    WHERE
      CRS1.DONOR IN (SELECT DONOR FROM Donors WHERE DDescription='United States') AND
      CRS1.RECIPIENT IN (SELECT RECIPIENT FROM Recipients WHERE RDescription='India') AND
      CRS1.SECTOR IN (SELECT SECTOR from Sectors WHERE SDescription='Total All Sectors')"

rs <- dbSendQuery(cnxn, query)
dat <- list()
i <- 0
while(!dbHasCompleted(rs)){
  i <- i+1
  dat[[i]] <- dbFetch(rs, n = 100)
}
final_dat <- do.call(rbind, dat)
dbClearResult(rs)
                  

# Using the tidyverse -----------------------------------------------------
library(tidyverse)
crs <- tbl(cnxn,'CRS1')
donors <- tbl(cnxn, 'Donors')
recipients <- tbl(cnxn, 'Recipients')
sectors <- tbl(cnxn, 'Sectors')

D <- crs %>% 
  semi_join(filter(donors, DDescription=='United States'),by='DONOR') %>% 
  semi_join(filter(recipients, RDescription=='India'), by='RECIPIENT') %>% 
  semi_join(filter(sectors, SDescription=='Total All Sectors'), by='SECTOR') %>% 
  collect(n = Inf)

D %>% group_by(YEAR) %>% summarize(Total = sum(Value)) %>%  arrange(YEAR)


dbDisconnect(cnxn)

