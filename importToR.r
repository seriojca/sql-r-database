sessionInfo()
#install.packages('stringr')
library(stringr)
#install.packages('tidyverse')
library(tidyverse)
#install.packages('RPostgreSQL')
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, dbname="exercitiibd", user="postgres", 
                 host = 'localhost', password="Serghei845")
tables <- dbGetQuery(con, 
                     "select table_name from information_schema.tables where table_schema = 'public'")
tables

for (i in 1:nrow(tables))
{
  # extract data from table in PostgreSQL
  temp <- dbGetQuery(con, paste("select * from ", tables[i,1], sep=""))
  # create the data frame
  assign(tables[i,1], temp)
}   

for (connection in dbListConnections(drv) ) {
  dbDisconnect(connection)
}

dbUnloadDriver(drv)

rm(con, drv, temp, i, tables, connection )

getwd()

save.image(file = 'aeroport.RData')
