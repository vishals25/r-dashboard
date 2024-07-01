## Shiny Server component for dashboard

function(input, output, session){
  # Data table Output
  output$dataT <- renderDataTable(my_data)
  
  # Rendering the box header  
  output$head1 <- renderText(
    paste(input$var2," of Top 5 Publishers ")
  )
  
  # Rendering the box header 
  output$head2 <- renderText(
    paste(input$var2," of  Bottom 5 Publishers")
  )
  
  
  # Rendering table with 5 states with high arrests for specific crime type
  output$top5 <- renderTable({
    
    my_data %>% 
      select(Publisher, input$var2) %>% 
      arrange(desc(get(input$var2))) %>% 
      head(5)
    
  })
  
  # Rendering table with 5 states with low arrests for specific crime type
  output$low5 <- renderTable({
    
    my_data %>% 
      select(Publisher, input$var2) %>% 
      arrange(get(input$var2)) %>% 
      head(5)
    
    
  })
  
  
  # For Structure output
  output$structure <- renderPrint({
    my_data %>% 
      str()
  })
  
  
  # For Summary Output
  output$summary <- renderPrint({
    my_data %>% 
      summary()
  })
  
  # For histogram - distribution charts
  output$histplot <- renderPlotly({
    p1 = my_data %>% 
      plot_ly() %>% 
      add_histogram(x=~get(input$var1)) %>% 
      layout(xaxis = list(title = paste(input$var1)))
    
    
    p2 = my_data %>%
      plot_ly() %>%
      add_boxplot(x=~get(input$var1)) %>% 
      layout(yaxis = list(showticklabels = F))
    
    # stacking the plots on top of each other
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Distribution chart - Histogram and Boxplot",
             yaxis = list(title="Frequency"))
  })

  ### Scatter Charts 
  output$scatter <- renderPlotly({
    p = my_data %>% 
      ggplot(aes(x=get(input$var3), y=get(input$var4),color=get(input$var4))) +
      geom_point() +
      labs(title = paste("Relation b/w", input$var3 , "and" , input$var4),
           x = input$var3,
           y = input$var4,
           color = input$var4) +
      theme(  plot.title = element_textbox_simple(size=10,halign=0.5))
      
    
    # applied ggplot to make it interactive
    ggplotly(p)
    
  })
  
  output$map_plot1 <- renderPlotly({
    
    # Plot yearly trends
    p1<-yearly_sales%>%
    ggplot(aes(x = Year, y = Total_Sales)) +
      geom_point(shape = 4)+
      labs(title = "Yearly Sales Trends",
           x = "Year",
           y = "Total Sales")
    
    ggplotly(p1)
  })
  output$map_plot2 <- renderPlotly({
    
    fig <- plot_ly(genre_data, labels = ~Genre, values = ~count,type = 'pie')
    
    fig <- fig %>% layout( title="Genre Distibution",
                          
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    
    fig
  })
  output$map_plot3 <- renderPlotly({
  ggplot(platform_data, aes(x = reorder(Platform, Count), y = Count,fill="orangered")) +
  geom_bar(stat = "identity") +
  labs(title = "Platform Popularity",
       x = "Platform",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
output$map_plot4 <- renderPlotly({
  
  publisher <- input$var5  # Get the selected publisher from input
  yearly_sales_pub <- my_data %>%
    filter(Publisher == publisher) %>%
    group_by(Year) %>%
    summarise(Total_Sales = sum(Global_Sales))
  # Create a sequence of all years present in the dataset
  all_years <- seq(1986,2022)
  # Plot global sales over the years for the specified publisher
  p1<-plot_ly(data = yearly_sales_pub, x = ~Year, y = ~Total_Sales, type = "scatter", mode = "lines") %>%
    layout(title = paste("Total Sales Over the Years for", publisher),
           xaxis = list(title = "Year"),
           yaxis = list(title = "Total Sales"))
  ggplotly(p1)# Convert ggplot to plotly
})
output$map_plot5 <- renderPlotly({
  
  publisher <- input$var5
  publisher1_data <- my_data %>%
    filter(Publisher == publisher) %>%
    group_by(Year) %>%
    summarise(TNA_Sales = sum(NA_Sales))
  
  publisher2_data <- my_data %>%
    filter(Publisher == publisher) %>%
    group_by(Year) %>%
    summarise(TEU_Sales = sum(EU_Sales))
  
  publisher3_data <- my_data %>%
    filter(Publisher == publisher) %>%
    group_by(Year) %>%
    summarise(TJP_Sales =sum(JP_Sales))
  # Create a sequence of all years present in the dataset
  all_years <- seq(1986,2022)
  # Plot global sales over the years for the specified publisher

  
  p <- plot_ly()
  
  
  # Add traces for each publisher
  p <- add_trace(p, data = publisher1_data, x = ~Year, y = ~TNA_Sales, type = "scatter", mode = "lines", name = "NA_Sales")
  p <- add_trace(p, data = publisher2_data, x = ~Year, y = ~TEU_Sales, type = "scatter", mode = "lines", name = "EU_Sales")
  p <- add_trace(p, data = publisher3_data, x = ~Year, y = ~TJP_Sales, type = "scatter", mode = "lines", name = "JP_Sales")
  # Add more traces for other publishers as needed3
  
  # Customize layout
  p <- layout(p, title = "Sales Distribution Over the Years",
              xaxis = list(title = "Year"),
              yaxis = list(title = "Comparision Of Sales"))
  
  
  
  ggplotly(p)
})
  
}

