plot1 <- function(NEI = NA, SCC = NA, screen = FALSE)
{
    # Read files if DF are nulls
    if(!is.data.frame(NEI))
        NEI <- readRDS("summarySCC_PM25.rds")
    if(!is.data.frame(NEI))
        SCC <- readRDS("Source_Classification_Code.rds")
    # Build data
    library(dplyr)
    agg <- NEI %>% group_by(year) %>% summarize(totalemission = sum(Emissions))
    # Generate plot
    if(screen) 
    {
        with(agg, {
            plot(year, totalemission, type="l", ylab = "Total emission")
            points(year, totalemission)
            title(main = "Total emission from PM2.5 in the US from 1999 to 2008")
        })
    }
    else 
    {
        png(file = "plot1.png")
        with(agg, {
            plot(year, totalemission, type="l", ylab = "Total emission")
            points(year, totalemission)
            title(main = "Total emission from PM2.5 in the US from 1999 to 2008")
        })
        dev.off()
        "Plot 1 created successfully in plot1.png file."
    }
}