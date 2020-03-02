# Code to parse stop-and-frisk data and generate visualization for/at: 
http://datatellsme.com/2020/02/the-math-and-logic-of-bloombergs-collective-punishment-of-minorities/


# Download Stop & Frisk CSV zips 2003 to 2013 from:

https://www1.nyc.gov/site/nypd/stats/reports-analysis/stopfrisk.page

# Uncompress zips, note location' replace path below with path to where you saved the CSV files

files <- paste0("~/Desktop/Raw_data/NYPD_Stop_and_Frisk/", 2003:2013,".csv") 

library(data.table)
SnF <-  lapply(files, fread, select = c("datestop", "cs_descr", "ac_rept", "race")) # variables selected from data catalog at same download link above

rm(files)

SnF <- rbindlist(SnF)

# Race abbreviations and their values are from the data catalog at the link above.
race.abb <- c("A", "B", "I", "P", "Q", "W", "X", "Z", "U")
race.name <- c("ASIAN/PACIFIC ISLANDER", "BLACK", "AMERICAN INDIAN/ALASKAN NATIVE", "BLACK-HISPANIC", "WHITE-HISPANIC", "WHITE", "UNKNOWN", "OTHER", "NOT LISTED")

# Change to Title case (or leave as is if you like SHOUTING WITH ALL CAPS)
race.name <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(race.name), perl=TRUE) 

# Or, there's a package for that:
library(stringr)
race.name <- str_to_title(race.name)

# Replace race abbreviations with title case values
SnF[, race := race.name[match(SnF$race, race.abb)]]

rm(race.abb, race.name)

# The "description" vars if NYPD was acting on a description:

SnF[cs_descr=="Y", .N] # Cause for stop: Fits a Relevant Description = Yes
SnF[ac_rept=="Y", .N]  # Additional circumstances of stop: Report By Victim/Witness/Officer = Yes
SnF[cs_descr=="Y" & ac_rept=="Y", .N] # Instances where both above are true
SnF[cs_descr=="Y" | ac_rept=="Y", .N] # Unique stops where one or the other was true


# Barchart: Black & Hispanic combined : ----

SnFRace <- SnF[, .N, by = race]
setkey(SnFRace, race) # facilitates next line
SnFRace <- SnFRace[!c("Not Listed", "Unknown")] #remove small numbers
SnFRace <- SnFRace[complete.cases(SnFRace), ] # remove NAs
SnFRace[race %in% c("Black", "Black-Hispanic","White-Hispanic"), race := "Black/Hispanic"] # combine Black and *-Hispanic
SnFRace <- SnFRace[, sum(N), by = race] # add up 3 Black + *-Hispanic rows
setnames(SnFRace, "V1", "N")
setkey(SnFRace, N)
SnFRace$race <- str_wrap(SnFRace$race, width = 10) # wrap long axis labels

library(ggplot2)
library(scales) # for thousands separator
ggsave("Stop_Frisk_Disproportionate_By_Race.png",
       ggplot(SnFRace, aes(x = race, y = N)) +
         geom_bar(stat = "identity", alpha = 0.85, fill = "brown4", width = .8) +
         coord_flip() +
         scale_x_discrete(limits = SnFRace$race[order(SnFRace$N)]) +
         scale_y_continuous(
           labels = comma,
           breaks = c(75000,500000, 1000000, 2000000, 3000000, 4000000)
         ) +
         labs(
           x = "Race of Individual",
           y = "Number stopped or frisked",
           title = "NYC's Stop And Frisk Operations By Race - The Bloomberg Years",
           subtitle = "4.98 million stops/frisks from 2003 to 2013*. NYC Population: ~8.34 million",
           caption = "No data availalbe for 2002, Mayor Bloomberg's first year."
         ) +
         theme_minimal()+
         theme(
           plot.title = element_text(size = 10),
           plot.subtitle = element_text(size = 9),
           plot.caption = element_text(size = 6),
           plot.background = element_rect(fill = "ivory"),
           axis.text.x = element_text(size = 7),
           axis.text.y = element_text(size = 7),
           axis.title.x = element_text(size = 9),
           axis.title.y = element_text(size = 9)
         ),
       width = 5, height = 4, dpi = 300, units = "in", device = "png")
