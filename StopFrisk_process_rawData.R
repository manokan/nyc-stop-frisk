library(data.table)

# Download NYC's Stop and Frisk CSV files from 2003 to 2016 at:   
# https://www1.nyc.gov/site/nypd/stats/reports-analysis/stopfrisk.page

# If files are not at the link, search NYC Open Data portal.

# 2017 & 2018 are omitted; variables differ significantly from prior years. See the readme for more on this decision.

files <- paste0("path/to/files/sqf-", 2003:2016,".csv") # change path to location of CSV files

# Caution: Next step generates a 3.7GB list 
sqf <-  lapply(files, fread) #  size = ~3.7GB 

# Examining/understanding variables in data frames for all 14 years in list
Reduce(union, lapply(sqf, names)) #  126 total unique variables
Reduce(intersect, lapply(sqf, names)) # 101 vars common to all data tables

# setdiff() on above shows the difference is in the case of three variable names; equalizing case by changing all to lower case:

for (i in 1:14) {
  names(sqf[[i]]) <- tolower(names(sqf[[i]]))
}

# Convert list of data tables into single data.table; new size = ~4.2GB
sqf <- rbindlist(sqf, use.names = TRUE, fill = TRUE)

saveRDS(sqf, "sqf.rds")

# subset for StopFrisk_by_Year - first visualization in this repo

SnFbyYear <- sqf[complete.cases(year), .N, by = year] # nix NAs

fwrite(SnFbyYear, "SnFbyYear.csv")

rm(list = ls())

