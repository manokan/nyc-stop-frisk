## NYC's Stop and Frisk

This a challenging public dataset to clean, parse, and visualize. I hope to do that in some detail. 

StopFrisk_process_rawData.R contains the link for downloading the raw data and code for reading it into R and doing some basic processing. The resulting file, at ~200MB+, is still too large for free cloud hosting. Each of the folders, however, contains a CSV file of the subsetted data required for that task. 

NB: There appears to have been an extensive revamp of the stop-and-frisk program variables reported from 2017 onwards. The number of observations (people stopped) in 2017 and 2018 are relatively small. At a later date I may match post- and pre-2016 variables; for now I am simply dropping 2017 and 2018. Data from 2003 to 2016 is, for me, is more than sufficient as a challenging data analytics learning experience and R programming exercise. 
