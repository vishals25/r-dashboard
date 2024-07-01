## Shiny UI component for the Dashboard

dashboardPage(
  dashboardHeader(title="Video Games sales Dashboard", titleWidth = 350, 
                  tags$li(class="dropdown",tags$a("TEAM MEMBERS: ")),
                  tags$li(class="dropdown",tags$a(icon("user"),"JANARTHANAN.K")),
                  tags$li(class="dropdown",tags$a(icon("user"),"MITHUN.B")),
                  tags$li(class="dropdown",tags$a(icon("user"),"SRIDHAR.S")),
                  tags$li(class="dropdown",tags$a(icon("user"),"VISHAL.S"))
                  ),
dashboardSidebar(
    sidebarMenu(id = "sidebar",
      menuItem("Dataset", tabName = "data", icon = icon("database")),
      menuItem("Visualization", tabName = "viz", icon=icon("chart-line")),
      # Conditional Panel for conditional widget appearance
      # Filter should appear only for the visualization menu and selected tabs within it
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Select the Variable" , choices = c1)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var2" , label ="Select the type" , choices = c1)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var3" , label ="Select the X variable" , choices = c1, selected = "Year")),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var4" , label ="Select the Y variable" , choices = c1, selected = "Global_sales")),
      menuItem("Analysis", tabName = "viz2", icon=icon("map")),
      conditionalPanel("input.sidebar == 'viz2' && input.t6 == 'd4'", selectInput(inputId = "var5" , label ="Select the Variable" , choices = publisher_name,selected = "Nintendo"))
    )
  ),
dashboardBody(
    tags$script(HTML('
      document.getElementById("bar").on("plotly_afterplot", function() {
        Plotly.relayout("bar", {
          "width": document.getElementById("bar").offsetWidth,
          "height": document.getElementById("bar").offsetHeight
        });
      });')),
    tabItems(
      ## First tab item
      tabItem(tabName = "data", 
              tabBox(id="t1", width = 20, 
                     tabPanel("About", icon=icon("address-card"),
fluidRow(
  column(width = 8, tags$img(src="game.jpg", width =600 , height = 350),align="center",
         tags$br() 
         #, tags$a(""), align = "center"
         ),
  column(width = 4, tags$br() ,
         tags$p("This dataset contains information about video game sales, including details such as the title, platform, genre, publisher, release date, and global sales figures."),
          tags$p("Key Features:"),

         tags$p("Title: The title of the video game."),
                tags$p("Platform: The gaming platform on which the game was released (e.g., PlayStation, Xbox, PC)."),
                       tags$p("Genre: The genre or category of the game (e.g., action, sports, role-playing)."),
                              tags$p("Publisher: The company responsible for publishing the game."),
                                     tags$p(" Release Date: The date when the game was released."),
                                             tags$p("Global Sales: The total global sales figures of the game across all regions."),
                                                    tags$p("The dataset allows us to analyze trends in the video game industry, such as popular gaming platforms, top publishers, genre preferences, and sales performance over time.")
  )
)
                              
                              ), 
                     tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted")),
                     tabPanel("Summary Stats", verbatimTextOutput("summary"), icon=icon("chart-pie"))
              )

),  
    
# Second Tab Item
    tabItem(tabName = "viz", 
            tabBox(id="t2",  width=20, 
            tabPanel("Games Trends by Publisher", value="trends",
                            fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , solidHeader = TRUE)),
                                     tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , solidHeader = TRUE))
                            )),
            tabPanel("Distribution", value="distro",
                     withSpinner(plotlyOutput("histplot", height = "400px"))),
            tabPanel("Relationship among Games", 
                     radioButtons(inputId ="fit" , label = "Select smooth method" , choices = c("loess", "lm"), selected = "lm" , inline = TRUE), 
                     withSpinner(plotlyOutput("scatter")), value="relation"),
            side = "left"
                   )
            ),
    # Third Tab Item
 tabItem(tabName = "viz2",
      tabBox(id="t6",width=20,
             tabPanel("Distribution among Year vs Global_Sales", value="d1",
               withSpinner(plotlyOutput("map_plot1", height = "400px"))),
              tabPanel("Genre Distribution", value="d2",
                        withSpinner(plotlyOutput("map_plot2", height = "400px"))
             ),
             tabPanel("platform popularity", value="d3",
                      withSpinner(plotlyOutput("map_plot3", height = "400px"))
             ),
             tabPanel("Sales Distribution Over the Years for an Publisher", value="d4",
                      withSpinner(plotlyOutput("map_plot4", height = "400px")),
                      withSpinner(plotlyOutput("map_plot5", height = "400px"))
             )
             )
        
    )

)
    )
)
