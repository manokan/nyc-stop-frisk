library(data.table)
library(ggplot2)
library(scales) # For thousands separator in y axis
options(scipen = 100) # Suppress scientific notation

sqfByYear <- fread("sqfByYear.csv") # Stop/frisk yearly totals processed in StopFrisk_process_rawData.R in this repo

# Barchart using geom_col: ----
 
ggplot(sqfByYear, aes(x = year, y = N)) +
  geom_col(alpha = .75,
           fill = "blue",
           width = .85) +
  scale_x_continuous(breaks = c(2003:2016)) +
  scale_y_continuous(labels = comma) +
  labs(
    x = "Year",
    y = "Number stopped or frisked",
    title = "NYC's Stop And Frisk By Year",
    subtitle = "From 2003 to 2016."
  )

# Line plot: ----

ggplot(sqfByYear, aes(x = year, y = N)) +
  geom_line(color = "purple", size = 1.5) +
  scale_x_continuous(breaks = c(2003:2016)) +
  scale_y_continuous(
    labels = comma,
    breaks = c(200000, 400000, 600000),
    sec.axis = dup_axis(breaks = c(10000, 100000), labels = comma) # some y axis breaks on right side for easier readability
  ) +
  labs(
    x = "Year",
    y = "Number stopped or frisked",
    title = "NYC's Stop And Frisk By Year",
    subtitle = "From 2003 to 2016.",
    caption = " Mayor from 2002 to 2013: Michael R. Bloomberg. 2014 onwards: Bill de Blasio."
  ) +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.caption = element_text(size = 10, face = "italic")
  )
