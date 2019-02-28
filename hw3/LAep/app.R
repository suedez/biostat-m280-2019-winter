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
library(ggplot2)
library(dplyr)
library(tidyverse)
city_ep <- read_rds('LAep.rds')

# Define UI for application that draws a histogram
ui <- navbarPage(
  
  # Application title
  titlePanel("Payroll by LA City"),
  # tab title
  tabPanel("Total Payroll by LA City", 
      plotOutput("barplot1")),
 
navbarMenu('More',
 tabPanel("Who earned most?",
          sidebarLayout(
          sidebarPanel(
            numericInput("year1",
            "selecte a year:",
             value = 2017,
             min = 2013,
             max = 2018,
             step = 1),
            numericInput("n1",
            label = "Visualize the top n people who earned most",
            value = 10)),
          mainPanel(
            plotOutput(c("barplot2", "barplot21"))))),
 
 tabPanel("Which department earned most?",
          sidebarLayout(
            sidebarPanel(
              numericInput("year2",
                      "selecte a year:",
                      value = 2017,
                       min = 2013,
                       max = 2018,
                       step = 1),
              numericInput("n2",
              label = "Visualize the top n department which earn most",
              value = 10)),
            mainPanel(
              plotOutput("barplot3")))),
 
 tabPanel("Which department cost most?",
          sidebarLayout(
            sidebarPanel(
              numericInput("year3",
                           "selecte a year:",
                           value = 2017,
                           min = 2013,
                           max = 2018,
                           step = 1),
              numericInput("n3",
               label = "Visualize the top n department which cost most",
               value = 10)),
            mainPanel(
              plotOutput("barplot4"))))
))

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$barplot1 <- renderPlot({
    select(city_ep, Year, Base_Pay, Overtime_Pay, 
           Other_Pay) %>% as.data.frame() %>%
      group_by(Year) %>% summarise(Base_Pay = sum(Base_Pay),
                          Overtime_Pay = sum(Overtime_Pay, na.rm = T),
                          Other_Pay = sum(Other_Pay)) %>%
      gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected1# Year == $year
    
    ggplot(selected1) + geom_bar(mapping = aes(x = as.factor(Year),
                        y = Ammount,
                        fill = Type),stat = 'identity') +
      labs(title = paste('LA City Total Payroll during Year 2013-2018'), 
           x = 'Payment Type',
           y = 'Total Payment Per Year')
    })
####################  
  output$barplot2 <- renderPlot({
    filter(city_ep, Year == input$year1) %>% 
      select(Department_Title, Job_Class_Title, 
             Total_Payments, Base_Pay, 
             Overtime_Pay, Other_Pay) %>% 
      as.data.frame() %>% 
      arrange(desc(Total_Payments)) %>% top_n(input$n1) %>% 
      mutate(Rank = as.factor(1:input$n1)) %>%
      gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected2
    ggplot(selected2) + geom_bar(stat = 'identity', 
                                 aes(x = Rank, y = Total_Payments, 
                                     fill = paste(Department_Title, 
                                            '\n', Job_Class_Title))) +
      labs(title = paste('Top', input$n1, 
                         'Payment in Year', input$year1), 
           x = 'Rank',
           y = 'Payment')
  })
   output$barplot21 <- renderPlot({
    ggplot(selected2) + geom_bar(stat = 'identity', 
                                 aes(x = Rank, y = Ammount, fill = Type)) +
      labs(title = paste('Top', input$n1, 'Payment in Year', input$year1), 
           x = 'Rank',
           y = 'Payment') 
  })
  
  output$barplot3 <- renderPlot({
    filter(city_ep, Year == input$year2) %>% select(Department_Title, 
      Total_Payments, Base_Pay, Overtime_Pay, Other_Pay) %>% 
      as.data.frame() %>% 
      group_by(Department_Title) %>%
      summarise(Total_Payments = mean(Total_Payments),
                Base_Pay = mean(Base_Pay), 
                Overtime_Pay = mean(Overtime_Pay),
                Other_Pay = mean(Other_Pay)) %>% 
      arrange(desc(Total_Payments)) %>% top_n(input$n2) %>% 
      mutate(Rank = as.factor(1:input$n2)) %>%
      gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected3
    
    selected3$Department_Title <- factor(selected3$Department_Title, 
                                  levels = as.character(
                                  selected3$Department_Title[1:input$n2]))
    
    ggplot(selected3) + geom_bar(stat = 'identity', 
                                 aes(x = Department_Title, 
                                     y = Ammount, fill = Type), 
                                 position = 'stack') +
      theme(axis.text.x = element_text(size = 6, family = "myFont", 
                                       vjust = 1, 
                                       hjust = 1, angle = 60)) +
      labs(title = paste('Top', input$n2, 
                         'Payment Department in Year', input$year2), 
           x = 'Department',
           y = 'MeanPayment') 
  })
  
  output$barplot4 <- renderPlot({
    filter(city_ep, Year == input$year3) %>% select(Department_Title, 
      Average_Benefit_Cost, Base_Pay, Overtime_Pay, Other_Pay) %>% 
      as.data.frame() %>% group_by(Department_Title) %>% 
      summarise(Average_Benefit_Cost = -sum(Average_Benefit_Cost),
                Base_Pay = sum(Base_Pay), 
                Overtime_Pay = sum(Overtime_Pay),
                Other_Pay = sum(Other_Pay)) %>%
      arrange(desc(-Average_Benefit_Cost))%>% 
      top_n(input$n3) %>%
      gather(`Average_Benefit_Cost`, `Base_Pay`, 
             `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected4
    
    selected4$Department_Title <- factor(selected4$Department_Title, 
                                  levels = as.character(
                                  selected4$Department_Title[1:input$n3])) 
    
    ggplot(selected4) + geom_bar(stat = 'identity', 
                                 aes(x = Department_Title, 
                                     y = Ammount, fill = Type), 
                                 position = 'identity') + 
      theme(axis.text.x = element_text(size = 8, family = "myFont", 
                                       vjust = 0.6, 
                                       hjust = 0.5, angle = 90)) +
      labs(title = paste('Top', input$n3, 
                         'Cost Department in Year', input$year3), 
           x = 'Department',
           y = 'Payment')
  })
}
# Run the application 
shinyApp(ui = ui, server = server)

