plot6 <- function(NEI = NA, SCC = NA, screen = FALSE)
{
    # Read files if DF are nulls
    if(!is.data.frame(NEI))
        NEI <- readRDS("summarySCC_PM25.rds")
    if(!is.data.frame(NEI))
        SCC <- readRDS("Source_Classification_Code.rds")
    # Build data
    library(dplyr)
    ## Let's assume that by "Motor Vehicle" we mean :
    ##   1. SCC.Level.One is "Mobile Sources"
    ##   2. SCC.Level.Two contains the word "vehicle"
    sources <- 
        subset(SCC, 
               SCC.Level.One == "Mobile Sources" & 
                   grepl("vehicle", SCC.Level.Two, ignore.case = TRUE), 
               select = SCC)
    ## Aggregate emmissions for Baltimore
    agg  <-  
        NEI %>%
        filter(SCC %in% sources$SCC, fips == "24510" | fips == "06037") %>% 
        mutate(place = ifelse(fips == "24510", "Baltimore City",  "Los Angeles County" )) %>% 
        select(year, place, Emissions) %>%
        group_by(year, place) %>% 
        summarize(totalemission = sum(Emissions))
    ## Data will be display versus value in 1999 to normalize figures
    ba99 <- subset(agg, year == 1999 & place == "Baltimore City")$totalemission
    la99 <- subset(agg, year == 1999 & place == "Los Angeles County")$totalemission
    agg100 <- rbind(
        agg %>% 
        filter(place == "Baltimore City") %>%
        mutate(emission100 = totalemission / ba99 * 100),
        agg %>% 
        filter(place == "Los Angeles County") %>%
        mutate(emission100 = totalemission / la99 * 100)
    )
    # plot the result
    g <- 
        ggplot(agg100, aes(year, emission100)) +
        geom_line(aes(color = place))  +
        ylab("Total emission - 100% in 1999") +
        labs(title = "Normalized emissions from motor vehicle sources")
    if(screen) 
    {
        print(g)
    }
    else 
    {
        png(file = "plot6.png")
        print(g)
        dev.off()
        "Plot 6 created successfully in plot5.png file."
    }
}