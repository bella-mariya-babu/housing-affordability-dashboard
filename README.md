# Housing Affordability in Australia: R Shiny Dashboard

An interactive dashboard exploring what drives housing affordability in Australia and how rental affordability has changed across Victorian local government areas (LGAs), with a focus on Melbourne, between 2000 and 2024.

**Live app:** coming soon

## Screenshots

**Dashboard Overview**
![Overview](Screenshot%202026-11-12%20141830.png)

**Economic Indicators**
![Economic Indicators](Screenshot%202026-11-12%20141925.png)

**Regional Affordability**
![Regional Affordability](Screenshot%202026-11-12%20142201.png)

## Questions the dashboard answers

1. What are the major factors affecting housing affordability in Australia?
2. How have regional differences in rental affordability changed across Melbourne's neighbourhoods from 2000 to 2024?

## What's in the dashboard

| Tab | What it shows |
|---|---|
| Dashboard Overview | Introduction, motivation, and a combined timeline of the economic indicators |
| Economic Indicators | Dropdown to view one indicator at a time (population change, CPI, WPI, dwelling prices, mortgage interest charges) on a common y-axis, with hover tooltips |
| Regional Affordability | Choropleth map of Victorian LGAs with a time period selector, popups and a colour legend |

## Key findings

- Interest charges and dwelling prices moved far more than wages, which stayed relatively flat.
- Rental affordability improved across much of Melbourne between 2000 and 2024, particularly in the southeast and inner city.
- Northern and outer regions continued to show higher housing stress, so the improvement was uneven.

## Tools

R, Shiny, tidyverse, ggplot2, plotly, leaflet, sf, shinythemes

## Files

- `app.R`: the Shiny app
- `Affordability.csv`: rental affordability rates by region and time period
- `timeseries_analysis.csv`: economic indicator time series
- `lga_simplified.rds`: simplified Victorian LGA boundaries for fast map loading

## Data sources

- Economic indicators: Australian Bureau of Statistics
- LGA boundaries: ABS, Local Government Areas 2024 (GDA2020), filtered to Victoria and simplified for web performance
- Rental affordability by region: Homes Victoria rental report

## Run locally

```r
install.packages(c("shiny", "tidyverse", "leaflet", "sf", "plotly", "shinythemes"))
shiny::runApp()
```

## Author

Bella Babu. Built as part of the Master of Data Science at Monash University (FIT5147).
