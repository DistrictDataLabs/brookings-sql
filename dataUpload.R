# Credit reporting system data

library(tidyverse)
CRS <- read_csv('CRS1_13082018174719891.csv')

CRS1 <- CRS[,c(seq(1,25,by=2))]
CRS2 <- CRS[,c(seq(2,25, by=2),25)]

DonorTable <- CRS %>% 
  select(1:2) %>%
  rename(DDescription = Donor) %>%
  distinct()

RecipeintTable <- CRS %>% 
  select(3:4) %>% 
  rename(RDescription = Recipient) %>% 
  distinct()

SectorTable <- CRS %>% 
  select(SECTOR, Sector) %>% 
  rename(SDescription=Sector) %>% 
  distinct()

FlowTable <- CRS %>% 
  select(FLOW, Flow) %>% 
  rename(FDescription=Flow) %>% 
  distinct()
ChannelTable <- CRS %>% 
  select(CHANNEL, Channel) %>% 
  rename(CDescription=Channel) %>% 
  distinct()
FlowType <- CRS %>% 
  select(13:14) %>% 
  rename(FTDescription = `Flow type`) %>% 
  distinct()
AidType <- CRS %>% 
  select(15:16) %>% 
  rename(ADescription=`Type of aid`) %>% 
  distinct()

library(odbc)
cnxn <- dbConnect(odbc(), server="brkressql01.database.windows.net",
                  driver = "SQL Server",
                  database="BRKRes01",
                  UID = "<your username>",
                  PWD = "<your password>")


dbdbWriteTable(cnxn, 'CRS1',CRS1, overwrite=T, temporary=F)
dbWriteTable(cnxn, 'CRS2', CRS2, temporary=F)
dbWriteTable(cnxn, 'Donors', DonorTable, temporary=F, overwrite=T)
dbWriteTable(cnxn, 'Recipients', RecipeintTable, temporary=F, overwrite=T)
dbWriteTable(cnxn, 'Sectors', SectorTable, temporary=F)
dbWriteTable(cnxn, 'Flows', FlowTable, temporary=F)
dbWriteTable(cnxn, 'Channels', ChannelTable, temporary=F)
dbWriteTable(cnxn, 'FlowType', FlowType, temporary=F)
dbWriteTable(cnxn, 'AidType', AidType, temporary=F)

