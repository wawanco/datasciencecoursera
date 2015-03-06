plot4 <- function(NEI = NA, SCC = NA, screen = FALSE)
{
    # Read files if DF are nulls
    if(!is.data.frame(NEI))
        NEI <- readRDS("summarySCC_PM25.rds")
    if(!is.data.frame(NEI))
        SCC <- readRDS("Source_Classification_Code.rds")
    # Build data
    library(dplyr)
    ## Final rows that mention COAL and COMB    
    coal.comb <- grep("coal", grep("comb", levels(SCC$EI.Sector), ign=T, val=T), ign=T, val=T)
    ## Subset the sources to keep only those rows
    sources <- subset(SCC, EI.Sector %in% coal.comb )
    ## Merge with NEI dataset
    dataset <- merge(NEI, sources, by="SCC")
    ## Group and summarize
    agg <- dataset %>% group_by(year) %>% summarize(totalemission = sum(Emissions))
    # Generate plot
    g <- 
        ggplot(agg, aes(year, totalemission)) +
        geom_line() +
        ylab("Total emission") +
        labs(title = "Emission across the US from coal combustion-related sources")
    if(screen) 
    {
        print(g)
    }
    else 
    {
        png(file = "plot4.png")
        print(g)
        dev.off()
        "Plot 4 created successfully in plot4.png file."
    }
}