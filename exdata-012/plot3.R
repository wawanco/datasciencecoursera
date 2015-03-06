plot3 <- function(NEI = NA, SCC = NA, screen = FALSE)
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
        group_by(year, type) %>% 
        summarize(totalemission = sum(Emissions))
    # Generate plot
    g <- ggplot(agg, aes(year, totalemission, group=type))  + 
        geom_line(aes(colour = type)) +
        ylab("Total emission") +
        labs(title = "Emission evolution by type for Baltimore City")
    if(screen) 
    {
        print(g)
    }
    else 
    {
        png(file = "plot3.png")
        print(g)
        dev.off()
        "Plot 3 created successfully in plot3.png file."
    }
}