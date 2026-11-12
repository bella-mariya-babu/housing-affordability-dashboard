

library(shiny)
library(tidyverse)
library(leaflet)
library(sf)
library(plotly)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  # Header Section
  div(
    class = "container",
    style = "padding: 20px 0;",
    h1("Housing Affordability in Australia", 
       style = "color: #2c3e50; margin-bottom: 20px;"),
    
    # Introduction Panel
    div(
      class = "well",
      style = "background-color: #f8f9fa; border: none; border-radius: 8px;",
      h2("Introduction",
         style = "color: #2c3e50; margin-bottom: 15px;"),
      p("The housing affordability crisis in Australia represents one of the most pressing socioeconomic challenges facing the nation.
     This dashboard provide comprehensive insights into housing affordability trends, with a particular focus on Melbourne's rental market evolution between 2000 and 2024.
        ", 
        style = "font-size: 16px; color: #2c3e50;"),
      
      h2("Motivation",
         style = "color: #2c3e50; margin-bottom: 15px;"),
      p("I am motivated to look into and assess the various factors influencing this issue because I am concerned about the impact that Australia's home affordability crisis is having on local communities.
      The ability to live in affordable, safe housing is one of the most fundamental human necessities. Individuals, families, and society at large may experience severe consequences if this need is not met.", 
        style = "font-size: 16px; color: #2c3e50;"),
      
      h2("Research question",
         style = "color: #2c3e50; margin-bottom: 15px;"),
      p("The visualisation focus on the following questions:",
        style = "font-size: 16px; color: #2c3e50;",
        tags$ul(
          tags$li("What are the major factors affecting housing affordability in Australia?",
                  style = "font-size: 16px;"),
          tags$li("From 2000 to 2024, how have regional differences in rental housing affordability changed throughout Melbourne's neighbourhoods?",
                  style = "font-size: 16px;")
        )
      ),
      
      h2("Summary",
         style = "color: #2c3e50; margin-bottom: 15px;"),
      p("The economic indicators show significant spikes in interest charges and moderate fluctuations in dwelling prices overtime, while wages have remained relatively stagnant.
      The rapid changes in interest rates and housing prices continue to impact housing affordability more significantly than wage growth.
      The melbourne rental affordability from 2000 to 2024 shows improvement in southeastern and inner city regions, while north and outer city faces significant housing stress.
        The data suggests that while housing conditions have generally improved over the 24-year period, the benefits haven't been evenly distributed across all regions.", 
        style = "font-size: 16px; color: #2c3e50;")
      
    )
  ),
  
  
  # Main Navigation Tabs 
  tabsetPanel(
    id = "mainTabs",
    type = "tabs",
    
    # 1. Dashboard Overview Tab
    tabPanel(
      "Dashboard Overview",
      div(
        class = "container",
        style = "padding: 20px;",
        div(
          class = "row",
          div(
            class = "col-md-12",
            div(
              class = "well",
              h3("How to Use This Dashboard", 
                 style = "color: #2c3e50; margin-bottom: 20px;"),
              tags$ul(
                tags$li("Begin with overview for complete context"),
                tags$li("View timeseries graph below to get a general overview about the major factors affecting housing crisis in Australia"),
                tags$li("Move onto the next tab to get specific idea of how these factors changed over the following years"),
                tags$li("Finally to explore the rental affordability rate of melbourne regions go to the final tab"),
              )
              
            )
          )
        ),
        # Timeline Chart Section
        div(
          class = "row mt-4",
          div(
            class = "col-md-12",
            div(
              class = "well",
              h3("Economic Indicators Overview", 
                 style = "color: #2c3e50; margin-bottom: 20px;"),
              plotlyOutput("overview_timeline", height = "400px")
            )
          )
        )
      )
    ),
    
    #Economic Indicators Tab 
    tabPanel(
      "Economic Indicators",
      div(
        class = "container",
        style = "padding: 20px;",
        fluidRow(
          # Controls
          column(
            3,
            wellPanel(
              style = "background-color: #f8f9fa; border: none; border-radius: 8px;",
              h4("Economic Drivers", style = "color: #2c3e50;"),
              p("Select different economic indicators to understand their trends and potential impact on housing affordability."),
              selectInput("indicator",
                          "Select Economic Indicator:",
                          choices = c(
                            "Annual population change" = "population",
                            "Annual CPI change" = "Annual_Cpi",
                            "Annual WPI movement" = "Annual_wpi",
                            "Change in dwellings price" = "Dwellings_price",
                            "Households mortgage interest charges" = "interest_charges"
                          )),
              hr(),
              h5("Understanding the Indicators:", style = "color: #2c3e50;"),
              tags$ul(
                tags$li("Each selection displays a detailed trend line graph with interactive tooltips"),
                tags$li("Hover over data points to see exact values"),
                tags$li("Population changes affect housing demand"),
                tags$li("Interest charges often move inversely to dwelling prices"),
                tags$li("Wage growth consistently lags behind housing price increases"),
                tags$li("Recent period shows unprecedented interest charge increases"),
                tags$li("Data source: Australian Bureau of Statistics") 
              )
            )
          ),
          # Chart
          column(
            9,
            div(
              style = "background-color: white; padding: 15px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.12);",
              plotlyOutput("economic_plot", height = "600px")
            )
          )
        )
      )
    ),
    
    #Regional Affordability Tab 
    tabPanel(
      "Regional Affordability",
      div(
        class = "container",
        style = "padding: 20px;",
        fluidRow(
          # Controls
          column(
            3,
            wellPanel(
              style = "background-color: #f8f9fa; border: none; border-radius: 8px;",
              h4("Regional Analysis", style = "color: #2c3e50;"),
              p("Explore how housing affordability varies across Melbourne's regions over time."),
              selectInput("selected_year", 
                          "Select Time Period:",
                          choices = NULL),
              hr(),
              h5("How to Read the Map:", style = "color: #2c3e50;"),
              tags$ul(
                tags$li("Darker colors indicate lower affordability"),
                tags$li("Click on regions for detailed information"),
                tags$li("Compare patterns across different time periods"),
                tags$li("Here most regions show lighter colors in 2024 compared to 2000, indicating a general improvement in affordability across Melbourne"),
                tags$li("A clear divide exists between inner and outer Melbourne, where southeastern regions show better affordability compared to northern and western regions"),
                tags$li("Data source: ABS LGA Boundaries and Homes Victoria rental report") 
              )
            )
          ),
          # Map
          column(
            9,
            div(
              style = "background-color: white; padding: 15px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.12);",
              leafletOutput("melb_map", height = "600px")
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  # Load and process data with error handling
  economic_data <- reactive({
    req(file.exists("timeseries_analysis.csv"))
    data <- read.csv("timeseries_analysis.csv")
    validate(need(!is.null(data), "Economic data couldn't be loaded"))
    return(data)
  })
  
  affordability_data <- reactive({
    req(file.exists("Affordability.csv"))
    data <- read.csv("Affordability.csv")
    validate(need(!is.null(data), "Affordability data couldn't be loaded"))
    
    data[] <- lapply(data, function(x) {
      if(is.character(x) && any(grepl("%", x))) {
        as.numeric(gsub("[%\\s]", "", x)) / 100
      } else {
        x
      }
    })
    return(data)
  })
  
  melbourne_spatial <- reactive({
    req(file.exists("lga_simplified.rds"))
    tryCatch({
      spatial_data <- readRDS("lga_simplified.rds") %>%
        st_transform(4326) %>%
        mutate(across(where(is.character), str_trim)) %>%
        mutate(LGA_NAME24 = tolower(LGA_NAME24)) %>%
        filter(!is.na(LGA_NAME24))
      
      validate(need(!is.null(spatial_data), "Spatial data couldn't be loaded"))
      return(spatial_data)
    }, error = function(e) {
      validate(need(FALSE, paste("Error loading spatial data:", e$message)))
    })
  })
  
  # Overview Timeline Plot
  output$overview_timeline <- renderPlotly({
    req(economic_data())
    
    long_data <- economic_data() %>%
      pivot_longer(
        cols = c("population", "Annual_Cpi", "Annual_wpi", 
                 "Dwellings_price", "interest_charges"),
        names_to = "indicator",
        values_to = "value"
      ) %>%
      mutate(
        indicator_label = case_when(
          indicator == "population" ~ "Population Change",
          indicator == "Annual_Cpi" ~ "Consumer Price Index",
          indicator == "Annual_wpi" ~ "Wage Price Index",
          indicator == "Dwellings_price" ~ "Dwelling Price Change",
          indicator == "interest_charges" ~ "Interest Charges"
        )
      )
    
    p <- ggplot(long_data, 
                aes(x = Time_period, 
                    y = value, 
                    color = indicator_label, 
                    group = indicator_label)) +
      geom_line(size = 1) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(size = 16, face = "bold"),
        legend.position = "bottom",
        legend.title = element_blank(),
        plot.margin = margin(t = 20, r = 20, b = 40,l = 20)
      ) +
      labs(
        title = "Economic Indicators Over Time",
        x = "Time Period",
        y = "Percentage Change (%)"
      )
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(
        hoverlabel = list(bgcolor = "white"),
        margin = list(t = 50),
        legend = list(orientation = "h", y = -0.4)
      )
  })

  # Economic Indicators Plot
  output$economic_plot <- renderPlotly({
    req(input$indicator, economic_data())
    
    validate(
      need(input$indicator %in% names(economic_data()), "Selected indicator not found in data")
    )
    
    label_mapping <- c(
      "population" = "Population Change (%)",
      "Annual_Cpi" = "Consumer Price Index Change(%)",
      "Annual_wpi" = "Wage Price Index Change (%)",
      "Dwellings_price" = "Dwelling Price Change (%)",
      "interest_charges" = "Mortgage Interest Charges (%)"
    )
    
    # Calculate global y-axis limits (min and max) across all indicators
    y_min <- min(
      c(min(economic_data()$population, na.rm = TRUE),
        min(economic_data()$Annual_Cpi, na.rm = TRUE),
        min(economic_data()$Annual_wpi, na.rm = TRUE),
        min(economic_data()$Dwellings_price, na.rm = TRUE),
        min(economic_data()$interest_charges, na.rm = TRUE)),
      na.rm = TRUE
    )
    
    y_max <- max(
      c(max(economic_data()$population, na.rm = TRUE),
        max(economic_data()$Annual_Cpi, na.rm = TRUE),
        max(economic_data()$Annual_wpi, na.rm = TRUE),
        max(economic_data()$Dwellings_price, na.rm = TRUE),
        max(economic_data()$interest_charges, na.rm = TRUE)),
      na.rm = TRUE
    )
    
    # Create the plot with a consistent y-axis range
    p <- ggplot(economic_data(), 
                aes(x = Time_period, 
                    y = .data[[input$indicator]])) +
      geom_line(color = "#2c3e50", size = 1) +
      geom_point(color = "#e74c3c") +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(size = 14, face = "bold"),
        plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
      ) +
      labs(
        title = paste("Trend of", label_mapping[input$indicator]),
        x = "Time Period",
        y = label_mapping[input$indicator]
      ) +
      ylim(y_min, y_max)  
    
    ggplotly(p) %>%
      layout(
        hoverlabel = list(bgcolor = "white"),
        margin = list(t = 50)
      )
  })
  
  
  
  # Update year selector
  observe({
    req(affordability_data())
    dates <- names(affordability_data())[-1]
    updateSelectInput(session, "selected_year",
                      choices = dates,
                      selected = dates[1])
  })
  
  # Melbourne Map with fixed legend
  output$melb_map <- renderLeaflet({
    req(input$selected_year, melbourne_spatial(), affordability_data())
    
    # Prepare data
    selected_data <- affordability_data() %>%
      select(Region_name, all_of(input$selected_year)) %>%
      rename(rate = input$selected_year) %>%
      mutate(
        Region_name = str_trim(tolower(Region_name)),
        rate_display = scales::percent(rate, accuracy = 0.1)
      ) %>%
      filter(!is.na(Region_name), !is.na(rate))
    
    # Join data
    melb_data <- melbourne_spatial() %>%
      inner_join(selected_data, by = c("LGA_NAME24" = "Region_name"))
    
    validate(
      need(nrow(melb_data) > 0, "No matching data found for the selected time period")
    )
    
    # Create color palette
    pal <- colorNumeric(
      palette = "YlOrRd",
      domain = melb_data$rate,
      reverse = FALSE
    )
    
    # Create and store map object
    map <- leaflet(melb_data) %>%
      addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
      addPolygons(
        fillColor = ~pal(rate),
        fillOpacity = 0.7,
        weight = 1,
        color = "#666666",
        popup = ~paste0(
          '<div style="font-family: Arial, sans-serif;">',
          '<h4 style="margin: 0 0 5px 0;">', str_to_title(LGA_NAME24), '</h4>',
          '<p style="margin: 0;">',
          '<strong>Affordability Rate:</strong> ', rate_display,
          '</p>',
          '</div>'
        ),
        label = ~paste(str_to_title(LGA_NAME24), ":", rate_display),
        labelOptions = labelOptions(
          style = list(
            "font-weight" = "normal",
            padding = "3px 8px"
          ),
          textsize = "15px",
          direction = "auto"
        ),
        highlightOptions = highlightOptions(
          weight = 2,
          color = "#666666",
          fillOpacity = 0.9,
          bringToFront = TRUE
        )
      )
    
    # Add legend to the stored map object
    map %>% addLegend(
      position = "bottomright",
      pal = pal,
      values = ~rate,
      title = "Affordability Rate",
      labFormat = labelFormat(suffix = "%", transform = function(x) 100 * x)
    )
  })
}

shinyApp(ui = ui, server = server)