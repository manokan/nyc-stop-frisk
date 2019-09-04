## NYC's Stop and Frisk

This a challenging public dataset to clean, parse, and visualize. I hope to do that in some detail. My first port of call, if you will, is my blog at [DataTellsMe.com](https://datatellsme.com) from where I will be updating this repo. 

StopFrisk_process_rawData.R contains the link for downloading the raw data and code for reading it into R and doing some basic processing. The resulting file, at ~200MB+, is still too large for free cloud hosting. Each of the folders, however, contains a CSV file of the subsetted data required for that task. 

NB: Subsequent to an extensive revamp of the stop-and-frisk program,  the variables reported are significantly different from 2017 onwards, and the number of observations (stops) in 2017 and 2018 are relatively small. At a later date I may match post- and pre-2016 variables; for now I am simply dropping 2017 and 2018. Data from 2003 to 2016 is sufficient as a valuable data analytics learning experience - both as an R programming exercise and for gaining sociological insights into policy choices and outcomes.