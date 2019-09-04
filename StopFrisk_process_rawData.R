library(data.table)

# Download NYC's Stop and Frisk CSV files from 2003 to 2016 at:   
# https://www1.nyc.gov/site/nypd/stats/reports-analysis/stopfrisk.page

# If files are not at the link, search NYC Open Data portal.

# 2017 & 2018 are omitted; variables differ significantly from prior years. See the readme for more on this decision.

files <- paste0("path/to/files/sqf-", 2003:2016,".csv") # change path to location of CSV files

# Caution: Next step generates a 3.7GB list 
sqf <-  lapply(files, fread) #  size = ~3.7GB 

# Examining variables across DTs in list
Reduce(union, lapply(sqf, names)) #  126 total variables
Reduce(intersect, lapply(sqf, names)) # 101 vars common to all DTs

# setdiff() on above shows 3 vars are mixed-case versions of 3 lower-case vars; equalizing case by changing all to lower case:

for (i in 1:14) {
  names(sqf[[i]]) <- tolower(names(sqf[[i]]))
}

# Convert list of DTs to single data.table; new size = ~4.2GB
sqf <- rbindlist(sqf, use.names = TRUE, fill = TRUE)

saveRDS(sqf, "sqf.rds")

# subset for StopFrisk_by_Year - first visualization in this repo

SnFbyYear <- sqf[complete.cases(year), .N, by = year] # nix NAs

fwrite(SnFbyYear, "SnFbyYear.csv")

rm(list = ls())

