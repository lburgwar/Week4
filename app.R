library(shiny)
library(leaflet)

ui <- fluidPage(
  sliderInput(inputId = "slider",
              label = "Usage: Move the slider to the right to display more of a route",
              min = 0,
              max = 100,
              value = 0,
              step = 1),
  leafletOutput("my_leaf")
)

server <- function(input, output, session){

  fn = '0aa1c9fb-2222-4fd9-b9f0-abe528b48ba0.csv'
  route_df <- read.csv(fn)
  route_df$value = seq(1,100, by=(100-1)/(dim(route_df)[1]-1))

  ## create static element
  output$my_leaf <- renderLeaflet({

    leaflet() %>%
      addTiles() %>%
      setView(lng=-77.2974, lat=38.8509, zoom = 14)

  })

  ## filter data
  df_filtered <- reactive({
    route_df[route_df$value <= input$slider, ]
  })

  ## respond to the filtered data
  observe({

    leafletProxy(mapId = "my_leaf", data = df_filtered()) %>%
      clearMarkers() %>%   ## clear previous markers
      addCircleMarkers(radius=1)
  })

}

shinyApp(ui, server)
