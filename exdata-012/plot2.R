plot2 <- function(NEI = NA, SCC = NA, screen = FALSE)
{
    # Read files if DF are nulls
    if(!is.data.frame(NEI))
        NEI <- readRDS("summarySCC_PM25.rds")
    if(!is.data.frame(NEI))
        SCC <- readRDS("Source_Classification_Code.rds")
    # Build data
    library(dplyr)
    agg <- 
        subset(NEI, fips == "24510") %>% 
        group_by(year) %>% 
        summarize(totalemission = sum(Emissions))
    # Generate plot
    if(screen) 
    {
        with(agg, {
            plot(year, totalemission, type="l", ylab = "Total emission")
            points(year, totalemission)
            title(main = "Total emission from PM2.5 in the Baltimore City from 1999 to 2008")
        })
    }
    else 
    {
        png(file = "plot2.png")
        with(agg, {
            plot(year, totalemission, type="l", ylab = "Total emission")
            points(year, totalemission)
            title(main = "Total emission from PM2.5 in the Baltimore City from 1999 to 2008")
        })
        dev.off()
        "Plot 2 created successfully in plot2.png file."
    }
}