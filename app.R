library(shiny)
library(DT)
library(tidyverse)
library(plotly)
library(here)
library(scales)

# once you've prepared the data uncomment this line
tidy_fuels <- read_csv(here("data", "cooking.csv"))
# you might want to use highlight_key here

ui <- fluidPage(style = "background-color:#d4ebf2;",
  title = "Indoor Air Pollution",
  tabsetPanel(
    tabPanel("chart",
      icon = icon("line-chart"),
      fluidRow(
        column(
          2,
          checkboxInput("linear_scale",
            "Linearize x-axis",
            value = FALSE
          )
        ),
        column(
          6,
          offset = 1,
          # also possible to use plotly here
          selectizeInput("countries", "Select Countries",
            choices = unique(tidy_fuels$country),
            multiple = TRUE
          )
        ),
        column(
          2,
          offset = 1,
          checkboxInput("small_countries",
            "Hide countries < 1 million",
            value = FALSE
          )
        )
      ),
      align = "center", style = "background-color:#d4ebf2;", plotlyOutput("chart", width = "90%", height = "750"),
      sliderInput("year",
        "Year",
        min = 2000,
        max = 2016,
        value = c(2000, 2016),
        sep = "",
        width = "100%"
      )
    ),
    tabPanel("table", dataTableOutput("table"), icon = icon("table")),

    tabPanel("about", icon = icon("question"))

  )
)


server <- function(input, output, session) {
  # Define reactive expressions here for filtering data
  output$text_out <- renderText({
       paste("This is the second assessment for ect 5523, hello hello link to my git ", input$text_input)
     })

  # Define outputs here
  output$chart <- renderPlotly({

    if (input$small_countries) {
      tidy_fuels <- tidy_fuels %>%
        filter(total_population >= 1000000)
    }

    if (!is.null(input$countries)){
      tidy_fuels <- tidy_fuels %>%
        filter(country %in% input$countries)
    }

    tidy_fuels <- tidy_fuels %>%
      filter(year >= input$year[1] & year <= input$year[2])


    tidy_fuels <- tidy_fuels %>%
      plot_ly(x = ~gdp_per_capita, y = ~cooking, color = ~continent,
              size = ~total_population, split = ~country,
              text = paste("Country: ", tidy_fuels$country,
                           "<br>Proportion: ", tidy_fuels$cooking,
                           "<br>Population: ", tidy_fuels$total_population,
                           "<br>GDP per capita: ", round(tidy_fuels$gdp_per_capita, 3)),
              hoverinfo = 'text')


    if(input$year[1] != input$year[2]){
      tidy_fuels <- tidy_fuels %>%
        add_trace(mode = 'lines+markers')
    }

    tidy_fuels <- tidy_fuels %>%
      layout(title = "Access to clean fuels for cooking vs. GDP per capita",
             yaxis = list(title = "Access to clean fuels and technologies for cooking", ticksuffix = "%")) %>%

      config(displaylogo = FALSE,
             modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "zoom2d", "pan2d"))

    if(!input$linear_scale){
      tidy_fuels <- layout(tidy_fuels, xaxis = list(title = 'GDP per capita (int.-$)', type = "log", ticksuffix = "$", nticks=3))
    } else{
      tidy_fuels <- layout(tidy_fuels, xaxis = list(title = 'GDP per capita (int.-$)', ticksuffix = "$", nticks=6, range = c(1000, 100000)))

      }

    tidy_fuels

  })



  output$table <- renderDataTable({
    NULL
  })

  url <- a("GitHub", href="https://www.google.com/")
  output$about <- renderUI({
    tagList("URL link:", url)
  })
}

runApp(shinyApp(ui, server))
