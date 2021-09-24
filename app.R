library(shiny)
library(DT)
library(tidyverse)
library(plotly)
library(here)
library(scales)
library(glue)

# once you've prepared the data uncomment this line
tidy_fuels <- read_csv(here("data", "cooking.csv"))
# you might want to use highlight_key here

ui <- fluidPage(style = "background-color:#F3FCEF;",
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
      align = "center", style = "background-color:#F3FCEF;", plotlyOutput("chart", width = "90%", height = "700"),
      sliderInput("year",
        "Year",
        min = 2000,
        max = 2016,
        value = c(2000, 2016),
        sep = "",
        width = "100%"
      )
    ),
    tabPanel("table",icon = icon("table"),
             tabsetPanel(tabPanel("Access to clean fuels and technologies for cooking",
                        fluidRow(column(12,
                                 dataTableOutput("% of population",  height = "1000")))),
                         tabPanel("GDP per capita (int.-$)",
                        fluidRow(column(12,
                                 dataTableOutput("international-$", height = "1000")))),
               tabPanel("Population",
                        fluidRow(column(12,
                                 dataTableOutput("Population", height = "1000")))))
    ),

    tabPanel("about", icon = icon("question"),
             fluidRow(
               column(12, h1('ETC5523: Communicating with Data',  align = "center", style = "font-size: 30px;"),
                          h2('Assessment 2',  align = "center", style = "font-size: 30px;"),
                          h3("Ratul Wadhwa (32055587)", align = "center", style = "font-size: 18px;"),
                          h6(textOutput('text_out')),
                             tags$head(tags$style("#text_out{color: #006400;
                                 font-size: 20px;
                                 font-style: italic;
                                 }")),
                          uiOutput("about")))))
)


server <- function(input, output, session) {
  # Define reactive expressions here for filtering data
  output$text_out <- renderText({
       paste("This assessment is an interactive web application using the shiny framework,
             I have tired to reproduce two interactive graphics from the Our World in Data website on the topic of air pollution.
             The shiny frame work can be found at Github repository(below).
             The 'Chart' panel contains a plot created with plotly which shows Access to clean fuels for cooking vs. GDP per capita.
             The 'Table' panel contains an interactive table that give details about Access to clean fuels and technologies for cooking
             (% of population).", input$text_input)
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

    continentcolors <- c('#800080', '#008080', '#483D8B', '#DC582A', '#964B00', '#63666A')

    tidy_fuels <- tidy_fuels %>%
      group_by(country)%>%
      highlight_key(~country) %>%
      plot_ly(x = ~gdp_per_capita,
              y = ~cooking,
              color = ~continent,
              colors = ~continentcolors,
              size = ~total_population,
              mode = 'lines+markers',
              text = paste("Country: ", tidy_fuels$country,
                           "<br>Proportion: ", tidy_fuels$cooking,
                           "<br>Population: ", tidy_fuels$total_population,
                           "<br>GDP per capita: ", round(tidy_fuels$gdp_per_capita, 3)),
              hoverinfo = 'text') %>%

      highlight(on = "plotly_hover", off = "plotly_doubleclick",
                selected = attrs_selected(showlegend = FALSE))%>%


      layout(paper_bgcolor='#FAEBD7',
             plot_bgcolor='#FAEBD7',
             xaxis = list(color = '#006400'),
             yaxis = list(color = '#006400', title = "Access to clean fuels and technologies for cooking", ticksuffix = "%"),
             title = "Access to clean fuels for cooking vs. GDP per capita") %>%

      config(displaylogo = FALSE,
             modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "zoom2d", "pan2d"))


    if(!input$linear_scale){
      tidy_fuels <- layout(tidy_fuels, xaxis = list(title = 'GDP per capita (int.-$)', type = "log", ticksuffix = "$", nticks=3))
    } else{
      tidy_fuels <- layout(tidy_fuels, xaxis = list(title = 'GDP per capita (int.-$)', ticksuffix = "$", nticks=6, range = c(1000, 100000)))

      }

    tidy_fuels

  })


  output$`% of population` <- renderDataTable({
    if (!is.null(input$countries)){
      tidy_fuels <- tidy_fuels %>%
        filter(country %in% input$countries)
    }

    if (input$small_countries) {
      tidy_fuels <- tidy_fuels %>%
        filter(total_population >= 1000000)
    }

    tidy_fuels <- tidy_fuels %>%
      filter(year == input$year[1] | year == input$year[2])

    tidy_fuels %>%
      select(-c(code, continent,gdp_per_capita, total_population)) %>%
      pivot_wider(names_from = year ,
                  values_from = cooking) %>%
      mutate(`Absolute Change` = .[[3]] - .[[2]],
             `Relative Change` = (.[[3]] - .[[2]])/.[[2]]*100 ) %>%
      datatable(escape = FALSE,
                caption = htmltools::tags$caption (style = 'caption-side: top; text-align: center;
                                                              color: black; font-family: Arial;
                                                              font-size: 150% ;', 'Access to clean fuels and technologies for cooking')) %>%
      formatRound('Absolute Change', digits = 3) %>%
      formatRound('Relative Change', digits = 3)

  })


  output$`international-$` <- renderDataTable({
    if (!is.null(input$countries)){
      tidy_fuels <- tidy_fuels %>%
        filter(country %in% input$countries)
    }

    if (input$small_countries) {
      tidy_fuels <- tidy_fuels %>%
        filter(total_population >= 1000000)
    }

    tidy_fuels <- tidy_fuels %>%
      filter(year == input$year[1] | year == input$year[2])

    tidy_fuels %>%
      mutate(gdp_per_capita = round(gdp_per_capita, 2)) %>%
      select(-c(code, continent, total_population, cooking)) %>%
      pivot_wider(names_from = year ,
                  values_from = gdp_per_capita) %>%
      mutate(`Absolute Change` = .[[3]] - .[[2]],
             `Relative Change` = (.[[3]] - .[[2]])/.[[2]]*100 ) %>%
      datatable(escape = FALSE,
                caption = htmltools::tags$caption (style = 'caption-side: top; text-align: center;
                                                              color: black; font-family: Arial;
                                                              font-size: 150% ;', 'GDP per capita (int.-$)')) %>%
      formatRound('Absolute Change', digits = 3) %>%
      formatRound('Relative Change', digits = 3)

  })

  output$Population <- renderDataTable({
    if (!is.null(input$countries)){
      tidy_fuels <- tidy_fuels %>%
        filter(country %in% input$countries)
    }

    if (input$small_countries) {
      tidy_fuels <- tidy_fuels %>%
        filter(total_population >= 1000000)
    }

    tidy_fuels <- tidy_fuels %>%
      filter(year == input$year[1] | year == input$year[2])

    tidy_fuels %>%
      select(-c(code, continent, cooking, gdp_per_capita)) %>%
      pivot_wider(names_from = year ,
                  values_from = total_population) %>%
      mutate(`Absolute Change` = .[[3]] - .[[2]],
             `Relative Change` = (.[[3]] - .[[2]])/.[[2]]*100) %>%
      datatable(escape = FALSE,
                caption = htmltools::tags$caption (style = 'caption-side: top; text-align: center;
                                                              color: black; font-family: Arial;
                                                              font-size: 150% ;', 'Population')) %>%
      formatRound('Absolute Change', digits = 3) %>%
      formatRound('Relative Change', digits = 3)

  })


  url <- a("GitHub", href="https://github.com/etc5523-2021/shiny-assessment-ratulwadhwa")
  url2 <- a("Tutorial 7", href="https://cwd.numbat.space/tutorials/tutorial-07sol.html")
  url3 <- a("Our World in Data", href ="https://ourworldindata.org/grapher/access-to-clean-fuels-for-cooking-vs-gdp-per-capita")

  output$about <- renderUI({
    tagList("GitHub URL link:", url ,
            ", Sources URL link:", url2,
            ", Data URL link:", url3)

  })


}

runApp(shinyApp(ui, server))
