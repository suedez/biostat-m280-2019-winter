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
DPtitle <- unique(city_ep$Department_Title)

city_ep %>% 
  group_by(Department_Title) %>%
  summarise(Total_Payments = sum(Total_Payments),
            Overtime_Pay = sum(Overtime_Pay),
            Base_Pay = sum(Base_Pay),
            Other_Pay = sum(Other_Pay)) %>%
  arrange(desc(Total_Payments)) %>%
  mutate(Rank = 1 : length(DPtitle)) -> sum_by_dp

# Define UI for application that draws a histogram
ui <- navbarPage(
  
  # Application title
  title = "Payroll by LA City",
  # tab title
  tabPanel("Total Payroll by LA City", 
      plotOutput("barplot1")),
 
navbarMenu('More',
 tabPanel("Who Earned Most?",
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
            plotOutput("barplot2")))),
 
 tabPanel("Which Department Earned Most?",
          sidebarLayout(
            sidebarPanel(
              numericInput("year2",
                      "selecte a year:",
                      value = 2018,
                       min = 2013,
                       max = 2018,
                       step = 1),
              numericInput("n2",
              label = "Visualize the top n department which earn most",
              value = 5),
              radioButtons('method',
                'mean/median payments',
                choices = c('mean',
                            'median'),
                selected = 'median'
              )),
            mainPanel(
              plotOutput("barplot3")))),
 
 tabPanel("Which Department Cost Most?",
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
               value = 5)),
            mainPanel(
              plotOutput("barplot4")))),
 
 tabPanel("6-Year Average Payment Composition of a Department",
          sidebarLayout(
           selectInput("dptitle",
                      "selecte a department:",
                      choices = DPtitle
          ),
          mainPanel(
            h4(''),
            plotOutput("chartplot"),
            
            h4(''),
            textOutput("text"))))
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
      arrange(desc(Total_Payments)) %>% 
      top_n(input$n1) %>% 
      mutate(Rank = factor(1:input$n1)) %>%
      gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected2
    
    brks <- seq(-6e5, 6e5, by = 1e5)
    lbls = paste0(as.character(c(seq(6e5, 0, by = -1e5), 
                                 seq(1e5, 6e5, by = 1e5))))
    
    ggplot(selected2) + geom_bar(stat = 'identity', 
                                 aes(x = Rank, y = Ammount, fill = Type)) +
      labs(title = paste('Top', input$n1, 'Payment in Year', input$year1), x = 'Rank',
           y = 'Payment')  + 
      geom_bar(stat = 'identity', 
               aes(x = Rank, y = -Total_Payments/3, 
                   fill = paste(Department_Title, '\n', Job_Class_Title)))  + 
      scale_fill_discrete(limits=c("Base_Pay", "Overtime_Pay", "Other_Pay", 
                                   paste(selected2$Department_Title[1:input$n1], 
                                         '\n', selected2$Job_Class_Title[1:input$n1]))) + 
      scale_y_continuous(breaks = brks,   # Breaks
                         labels = lbls) +
      guides(fill = guide_legend(
        title= paste('Payment Type (top) and', 
                     '\n', 'Job Type (bottom)')))
  })

  
  output$barplot3 <- renderPlot({
    filter(city_ep, Year == input$year2) %>% select(Department_Title, 
                                             Total_Payments, Base_Pay, Overtime_Pay, Other_Pay) %>% 
      as.data.frame() %>% 
      group_by(Department_Title) -> selected31
    if(input$method == 'mean'){
      selected31 %>% summarise(Total_Payments = mean(Total_Payments),
                Base_Pay = mean(Base_Pay), 
                Overtime_Pay = mean(Overtime_Pay),
                Other_Pay = mean(Other_Pay)) %>% 
      arrange(desc(Total_Payments)) %>% top_n(input$n2) %>% 
      mutate(Rank = as.factor(1:input$n2)) %>%
      gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected3
    }else{selected31 %>% summarise(Total_Payments = median(Total_Payments),
                                   Base_Pay = median(Base_Pay), 
                                   Overtime_Pay = median(Overtime_Pay),
                                   Other_Pay = median(Other_Pay)) %>% 
        arrange(desc(Total_Payments)) %>% top_n(input$n2) %>% 
        mutate(Rank = as.factor(1:input$n2)) %>%
        gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
               key = 'Type', value = 'Ammount') -> selected3
    }
    
    selected3$Department_Title <- factor(selected3$Department_Title, 
                                         levels = as.character(
                                           selected3$Department_Title[input$n2:1]))
    
    ggplot(selected3) + geom_bar(stat = 'identity', 
                                 aes(x = Department_Title, y = Ammount, fill = Type), 
                                 position = 'stack')  + coord_flip() +
      labs(title = paste('Top', input$n2, 'Payment Department in Year', input$year2), 
           x = 'Department',
           y = paste(input$metohd,' Payment')) 
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
                                  selected4$Department_Title[input$n3 : 1])) 
    brks <- seq(-4e8, 13e8, by = 1e8)
    lbls = paste0(as.character(c(seq(4e8, 0, by = -1e8), 
                                 seq(1e8, 13e8, by = 1e8))))
    
    ggplot(selected4) + geom_bar(stat = 'identity', 
                                 aes(x = Department_Title, 
                                     y = Ammount, fill = Type), 
                                 position = 'identity') + 
      scale_y_continuous(breaks = brks, 
                         labels = lbls) +
      theme(axis.text.x = element_text(size = 8, family = "myFont", 
                                       vjust = 0.6, 
                                       hjust = 0.5, angle = 90)) +
      labs(title = paste('Top', input$n3, 
                         'Cost Department in Year', input$year3), 
           x = 'Department',
           y = 'Ammount') + coord_flip()
  })
  
  output$chartplot <- renderPlot({
    sum_by_dp %>%
      filter(Department_Title == input$dptitle) %>%
      gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected5
    theme_set(theme_classic())
    ggplot(selected5, aes(x = '', y = Ammount, fill = Type)) + 
      geom_bar(stat = 'identity') + 
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            plot.title = element_text(hjust=0.5)) + 
      labs(fill="class", 
           x=NULL, 
           y=NULL, 
           title=paste('Average Payment Composition for', input$dptitle)) +
      coord_polar('y', start = 0) + 
      theme(axis.text.x = element_blank())
  })
  
  output$text <- renderText({
    sum_by_dp %>%
    filter(Department_Title == input$dptitle) %>%
      gather(`Base_Pay`, `Overtime_Pay`, `Other_Pay`, 
             key = 'Type', value = 'Ammount') -> selected5
    ranki <- selected5$Rank[1]
    paste('The average total payments of this department ranks in',
        ranki, 'among all departments')
  })
}
# Run the application 
shinyApp(ui = ui, server = server)

