#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## load required packages
library(shiny)
library(readr)

LA_ep <- read_rds('LAEmployeePayroll.rds')

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Total Payroll by LA City"),
  
  # let users select a year 
  sidebarLayout(
    sidebarPanel(
      numericInput("year",
                   "Select a year:",
                   value = 2018,
                   min = 2013,
                   max = 2018,
                   step = 1)
    ),
    
    # Show a plot of the selecte year
    mainPanel(
      plotOutput("histogram")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$histogram <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

