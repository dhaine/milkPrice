## Load packages -----------------------------------------------------
library(shiny)
library(shinythemes)
library(tidyverse)
library(readxl)
library(lubridate)
library(zoo)
library(plotly)

## Data
### currency conversion
currency <- read_csv("../data/currency.csv")
### Farm gate prices
farmGate_usa <- read_csv("../data/C8C030A0-BB15-3944-8CBC-6A343D47B6F0.csv") %>%
    filter(Period != "MARKETING YEAR" & `Geo Level` == "NATIONAL" &
           Period != "YEAR") %>%
    mutate(time = parse_date_time(paste(as.character(Year), Period,
                                        sep = "-"), "ym"),
           country = "USA") %>%
    arrange(time)
farmGate_usa <- merge(farmGate_usa, currency, by.x = "Year", by.y = "year") %>%
    mutate(price = Value * CAD_per_USD / 44.0242)  # USD to CAD and cwt to litre
farmGate_can <- read_csv2("../data/can_milk_price_farm_gate.csv") %>%
    mutate(country = "Canada",
           time = parse_date_time(paste(as.character(year), month, sep = "-"), "ym"),
           price = price / 100) %>%  # from hl to l
    arrange(time)
farmGate_nze <- read_csv2("../data/nz_milk_price_farm_gate.csv") %>%
    gather("Yr_2010":"Yr_2018", key = "year", value = "price") %>%
    mutate(year = str_extract(year, "[0-9]+"),
           country = "New Zealand",
           time = parse_date_time(paste(year, month, sep = "-"), "ym"),
           price = price * 0.9708737864 / 100)  # from 100 kg to l
farmGate_nze <- merge(farmGate_nze, currency, by = "year") %>%
    mutate(price = price * CAD_per_NZD)
farmGate_eur <- read_xls("../data/eu_farmgate_milk_prices_-_dg_agri.xls",
                         sheet = 2, range = "CT10:HA55")
eur <- read_xls("../data/eu_farmgate_milk_prices_-_dg_agri.xls",
                sheet = 2, range = "A10:A55")
farmGate_eur <- cbind(eur, farmGate_eur)
names(farmGate_eur) <- c("country", "2009-JAN", "2009-FEB", "2009-MAR", "2009-APR",
                         "2009-MAY", "2009-JUN", "2009-JUL", "2009-AUG", "2009-SEP",
                         "2009-OCT", "2009-NOV", "2009-DEC", "2010-JAN", "2010-FEB",
                         "2010-MAR", "2010-APR", "2010-MAY", "2010-JUN", "2010-JUL",
                         "2010-AUG", "2010-SEP", "2010-OCT", "2010-NOV", "2010-DEC",
                         "2011-JAN", "2011-FEB", "2011-MAR", "2011-APR", "2011-MAY",
                         "2011-JUN", "2011-JUL", "2011-AUG", "2011-SEP", "2011-OCT",
                         "2011-NOV", "2011-DEC", "2012-JAN", "2012-FEB", "2012-MAR",
                         "2012-APR", "2012-MAY", "2012-JUN", "2012-JUL", "2012-AUG",
                         "2012-SEP", "2012-OCT", "2012-NOV", "2012-DEC", "2013-JAN",
                         "2013-FEB", "2013-MAR", "2013-APR", "2013-MAY", "2013-JUN",
                         "2013-JUL", "2013-AUG", "2013-SEP", "2013-OCT", "2013-NOV",
                         "2013-DEC", "2014-JAN", "2014-FEB", "2014-MAR", "2014-APR",
                         "2014-MAY", "2014-JUN", "2014-JUL", "2014-AUG", "2014-SEP",
                         "2014-OCT", "2014-NOV", "2014-DEC", "2015-JAN", "2015-FEB",
                         "2015-MAR", "2015-APR", "2015-MAY", "2015-JUN", "2015-JUL",
                         "2015-AUG", "2015-SEP", "2015-OCT", "2015-NOV", "2015-DEC",
                         "2016-JAN", "2016-FEB", "2016-MAR", "2016-APR", "2016-MAY",
                         "2016-JUN", "2016-JUL", "2016-AUG", "2016-SEP", "2016-OCT",
                         "2016-NOV", "2016-DEC", "2017-JAN", "2017-FEB", "2017-MAR",
                         "2017-APR", "2017-MAY", "2017-JUN", "2017-JUL", "2017-AUG",
                         "2017-SEP", "2017-OCT", "2017-NOV", "2017-DEC", "2018-JAN",
                         "2018-FEB", "2018-MAR", "2018-APR")
farmGate_eur <- farmGate_eur %>%
    filter(country %in% c("Weighted Average EU15", "Weighted Average EU28")) %>%
    gather("2009-JAN":"2018-APR", key = "year", value = "price") %>%
    mutate(time = parse_date_time(year, "ym"),
           year = str_extract(year, "[0-9]+"),
           country = ifelse(country == "Weighted Average EU15", "EU15", "EU28"),
           price = price * 0.9708737864 / 100)  # from 100 kg to l
farmGate_eur <- merge(farmGate_eur, currency, by = "year") %>%
    mutate(price = price * CAD_per_EUR)
farm_gate <- rbind(farmGate_usa[, c("time", "country", "price")],
                   farmGate_can[ , c("time", "country", "price")])
farm_gate <- rbind(farm_gate, farmGate_nze[, c("time", "country", "price")])
farm_gate <- rbind(farm_gate, farmGate_eur[, c("time", "country", "price")]) %>%
    arrange(time)
