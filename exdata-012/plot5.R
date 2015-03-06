plot5 <- function(NEI = NA, SCC = NA, screen = FALSE)
{
    # Read files if DF are nulls
    if(!is.data.frame(NEI))
        NEI <- readRDS("summarySCC_PM25.rds")
    if(!is.data.frame(NEI))
        SCC <- readRDS("Source_Classification_Code.rds")
    # Generate plot
    library(dplyr)
    ## Let's assume that by "Motor Vehicle" we mean :
    ##   1. SCC.Level.One is "Mobile Sources"
    ##   2. SCC.Level.Two contains the word "vehicle"
    sources <- 
        subset(SCC, 
            SCC.Level.One == "Mobile Sources" & 
            grepl("vehicle", SCC.Level.Two, ignore.case = TRUE), 
            select = SCC)
    # Aggregate emmissions for Baltimore
    agg  <-  
        NEI %>%
        filter(SCC %in% sources$SCC, fips == "24510") %>% 
        group_by(year) %>% 
        summarize(totalemission = sum(Emissions))
    ## plot the result
    g <- 
        ggplot(agg, aes(year, totalemission)) + 
        geom_line() +
        ylab("Total emission") +
        labs(title = "Emissions from motor vehicle sources from 1999-2008 in Baltimore City")
    if(screen) 
    {
        print(g)
    }
    else 
    {
        png(file = "plot5.png")
        print(g)
        dev.off()
        "Plot 5 created successfully in plot5.png file."
    }
}