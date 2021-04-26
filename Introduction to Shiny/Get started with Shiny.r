### Chapter 1: Get started ###
library(shiny)
library(ggplot2)
library(babynames)
library(dplyr)
library(plotly)
library(DT)
library(shinyWidgets)
library(shinydashboard)
ui <- fluidPage()
server <- function(input, output, session){}
shinyApp(ui = ui, server = server)

# Hello world Shiny App
ui <- fluidPage("Hello, world!!!")
server <- function(input, output, session){}
shinyApp(ui = ui, server = server)

# Ask a question (with an input )
ui <- fluidPage(textInput("name","enter a name"),textOutput("q"))
server <- function(input, output){
  output$q <- renderText({paste("Do you prefer dogs or cats,", input$name, "?")})
}
shinyApp(ui = ui, server = server)

# Ex1
ui <- fluidPage(
  textInput("name", "What is your name?"),
  # CODE BELOW: Display the text output, greeting
  # Make sure to add a comma after textInput()
  textOutput("greeting")
)

server <- function(input, output) {
  # CODE BELOW: Render a text output, greeting

  output$greeting <- renderText({paste("Hello,",input$name)})

}

shinyApp(ui = ui, server = server)

# Build a babyname explorer Shiny App
# skecth your app
# Add inputs (UI)
ui <- fluidPage(titlePanel("Baby Name Explorer"),
                sidebarLayout(
                sidebarPanel(
                textInput("name","Enter Name", "David"),),
                mainPanel(
                plotOutput('trend')
                )
                )
)

server <- function(input, output, session){
  output$trend <- renderPlot({
    data_name <- subset(babynames, name == input$name)
    ggplot(data_name) + geom_line(aes(x=year, y = prop, color = sex))
  })
}
shinyApp(ui = ui, server = server)

### Chapter 2: Inputs, Outputs, and Layouts
## Inputs
selectInput('inputId','label',choices = c('A','B','C'))
sliderInput('inputID','label',value = 1925, min = 1900, max = 2000 )
?dateRangeInput
?checkboxInput
ui <- fluidPage(
  textInput('name','Enter a name:'),
  selectInput('animal',"dogs or cats?", choices = c("dogs","cats")),
  textOutput("greeting"),
  textOutput(('answer'))
)
server <- function(input, output, session) {
  output$greeting <- renderText({
    paste("do you prefer dogs or cats,", input$name, "?")
  })
  output$answer <- renderText({
    paste("I prefer", input$animal, "!")
  })
}
shinyApp(ui = ui, server = server)

# EX: Add a select input, Add a slider input to select year
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("F", "M")),
  # CODE BELOW: Add slider input named 'year' to select years  (1900 - 2010)
  sliderInput('year', 'select a year:', max = 2010, min = 1900, value = 1900 ),
  # Add plot output to display top 10 most popular names
  plotOutput('plot_top_10_names')
)

server <- function(input, output, session){
  # Render plot of top 10 most popular names
  output$plot_top_10_names <- renderPlot({
    # Get top 10 names by sex and year
    top_10_names <- babynames %>%
      filter(sex == input$sex) %>%
      # MODIFY CODE BELOW: Filter for the selected year
      filter(year == input$year) %>%
      top_n(10, prop)
    # Plot top 10 names by sex and year
    ggplot(top_10_names, aes(x = name, y = prop)) +
      geom_col(fill = "#263e63")
  })
}

shinyApp(ui = ui, server = server)

## Outputs
ui <- fluidPage(
  DT::DTOutput("babynames_table")
)
server <- function(input, output){
  output$babynames_table <- DT::renderDT({
    babynames %>%
      dplyr::sample_frac(.1)
  })
}
shinyApp(ui = ui, server = server)

# EX:Add a table output
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("M", "F")),
  # Add slider input named "year" to select year between 1900 and 2010
  sliderInput('year', 'Select Year', min = 1900, max = 2010, value = 1900),
  # MODIFY CODE BELOW: Add a DT output named "table_top_10_names"
  tableOutput('table_top_10_names')
)
server <- function(input, output, session){
  top_10_names <- function(){
    babynames %>%
      filter(sex == input$sex) %>%
      filter(year == input$year) %>%
      top_n(10, prop)
  }
  # MODIFY CODE BELOW: Render a DT output named "table_top_10_names"
  output$table_top_10_names <- renderTable({
    top_10_names()
  })
}
shinyApp(ui = ui, server = server)

#EX2 DT Interactive datatable
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("M", "F")),
  # Add slider input named "year" to select year between 1900 and 2010
  sliderInput('year', 'Select Year', min = 1900, max = 2010, value = 1900),
  # MODIFY CODE BELOW: Add a DT output named "table_top_10_names"
  DT::DTOutput('table_top_10_names')
)
server <- function(input, output, session){
  top_10_names <- function(){
    babynames %>%
      filter(sex == input$sex) %>%
      filter(year == input$year) %>%
      top_n(10, prop)
  }
  # MODIFY CODE BELOW: Render a DT output named "table_top_10_names"
  output$table_top_10_names <- DT::renderDT({
    top_10_names()
  })
}
shinyApp(ui = ui, server = server)

# EX3: Add interactive plot output
ui <- fluidPage(
  selectInput('name', 'Select Name', top_trendy_names$name),
  # CODE BELOW: Add a plotly output named 'plot_trendy_names'
  plotly::plotlyOutput('plot_trendy_names')
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    babynames %>%
      filter(name == input$name) %>%
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  # CODE BELOW: Render a plotly output named 'plot_trendy_names'
  output$plot_trendy_names = plotly::renderPlotly({
    plot_trends()}
  )


}
shinyApp(ui = ui, server = server)

## Layout and themes
# EX1: Sidebar layouts
ui <- fluidPage(
  # MODIFY CODE BELOW: Wrap in a sidebarLayout
  # MODIFY CODE BELOW: Wrap in a sidebarPanel
  sidebarLayout(
    sidebarPanel(selectInput('name', 'Select Name', top_trendy_names$name)),
    # MODIFY CODE BELOW: Wrap in a mainPanel
    mainPanel(plotly::plotlyOutput('plot_trendy_names'),
              DT::DTOutput('table_trendy_names'))
  ))
# DO NOT MODIFY
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    babynames %>%
      filter(name == input$name) %>%
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })

  output$table_trendy_names <- DT::renderDT({
    babynames %>%
      filter(name == input$name)
  })
}
shinyApp(ui = ui, server = server)
# EX2:Tab layouts
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput('name', 'Select Name', top_trendy_names$name)
      ),
      mainPanel(
        # MODIFY CODE BLOCK BELOW: Wrap in a tabsetPanel
        # MODIFY CODE BELOW: Wrap in a tabPanel providing an appropriate label
        tabsetPanel(
          tabPanel(
            plotly::plotlyOutput('plot_trendy_names')),
          # MODIFY CODE BELOW: Wrap in a tabPanel providing an appropriate label
          tabPanel(DT::DTOutput('table_trendy_names'))
        )
      )
    ))
  server <- function(input, output, session){
    # Function to plot trends in a name
    plot_trends <- function(){
      babynames %>%
        filter(name == input$name) %>%
        ggplot(aes(x = year, y = n)) +
        geom_col()
    }
    output$plot_trendy_names <- plotly::renderPlotly({
      plot_trends()
    })

    output$table_trendy_names <- DT::renderDT({
      babynames %>%
        filter(name == input$name)
    })
  }
  shinyApp(ui = ui, server = server)

# EX3: Themes
  ui <- fluidPage(
    # CODE BELOW: Add a titlePanel with an appropriate title
    titlePanel('ABC'),
    # REPLACE CODE BELOW: with theme = shinythemes::shinytheme("<your theme>")
    #shinythemes::themeSelector(),
    theme = shinythemes::shinytheme('yeti'),
    sidebarLayout(
      sidebarPanel(
        selectInput('name', 'Select Name', top_trendy_names$name)
      ),
      mainPanel(
        tabsetPanel(
          tabPanel('Plot', plotly::plotlyOutput('plot_trendy_names')),
          tabPanel('Table', DT::DTOutput('table_trendy_names'))
        )
      )
    )
  )
  server <- function(input, output, session){
    # Function to plot trends in a name
    plot_trends <- function(){
      babynames %>%
        filter(name == input$name) %>%
        ggplot(aes(x = year, y = n)) +
        geom_col()
    }
    output$plot_trendy_names <- plotly::renderPlotly({
      plot_trends()
    })

    output$table_trendy_names <- DT::renderDT({
      babynames %>%
        filter(name == input$name)
    })
  }
  shinyApp(ui = ui, server = server)

## Building Apps:
# EX1:App 1: Multilingual Greeting
  ui <- fluidPage(
    selectInput ('greeting','Select greeting', choices = c('Hello','Bonjour')),
    textInput ('name','Enter your name','Kaelen'),
    textOutput('whole')
  )

  server <- function(input, output, session) {
    output$whole <- renderText({
      paste(input$greeting,',',input$name)
    })

  }

  shinyApp(ui = ui, server = server)

#EX2: App 2: Popular Baby Names
  ui <- fluidPage(
    titlePanel("ABC"),
    sidebarLayout(
      sidebarPanel (
        selectInput('sex','Select Sex', choices = c('M','F')),
        sliderInput('year','Select Year', max = 2017,min = 1880, value = 1880)),
      mainPanel(plotOutput('plot'))
    )
  )

  server <- function(input, output, session) {
    topnames<- babynames %>% get_top_names(input$year, input$sex)
    output$plot <- renderPlot({
      ggplot(babynames, aes(x = topnames, y = prop)) + geom_col()

    })

  }
  shinyApp(ui = ui, server = server)

# Ex3: App 3: Popular Baby Names Redux

  ui <- fluidPage(
    titlePanel('Most Popular Names'),
    sidebarLayout(
      sidebarPanel(
        selectInput('sex','Select sex',choices = c('M','F')),
        sliderInput('year','Select year', max = 2017, min = 1880, value = 1900)),
      mainPanel(
        tabsetPanel(
          tabPanel(tableOutput ('table')),
          tabPanel(plotOutput('plot'))))
    )
  )

  server <- function(input, output, session) {
    topnames = babynames %>% get_top_names(input$year, input$sex)
    output$table = renderTable({
      babynames %>% filter (year == input$year) %>% filter (sex == input$sex) %>% filter(name == topnames)
    })
    output$plot = renderPlot ({
      ggplot(babynames,aes(x= topnames, y = prop)) +  geom_col()
    })

  }
  shinyApp(ui = ui, server = server)


### Chapter 3 Reactive Programming
## Ex1
  ui <- fluidPage(
    titlePanel('BMI Calculator'),
    theme = shinythemes::shinytheme('cosmo'),
    sidebarLayout(
      sidebarPanel(
        numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
        numeriInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
      ),
      mainPanel(
        textOutput("bmi"),
        textOutput("bmi_range")
      )
    )
  )
  server <- function(input, output, session) {
    rval_bmi <- reactive({
      input$weight/(input$height^2)
    })
    output$bmi <- renderText({
      bmi <- rval_bmi()
      paste("Your BMI is", round(bmi, 1))
    })
    output$bmi_range <- renderText({
      bmi <- rval_bmi()
      health_status <- cut(bmi,
                           breaks = c(0, 18.5, 24.9, 29.9, 40),
                           labels = c('underweight', 'healthy', 'overweight', 'obese')
      )
      paste("You are", health_status)
    })
  }
  shinyApp(ui, server)

# EX2:
  server <- function(input, output, session) {
    # CODE BELOW: Add a reactive expression rval_bmi to calculate BMI
    rval_bmi <- reactive({input$weight/(input$height^2)})


    output$bmi <- renderText({
      # MODIFY CODE BELOW: Replace right-hand-side with reactive expression
      bmi <- rval_bmi()
      paste("Your BMI is", round(bmi, 1))
    })
    output$bmi_range <- renderText({
      # MODIFY CODE BELOW: Replace right-hand-side with reactive expression
      bmi <- rval_bmi()
      bmi_status <- cut(bmi,
                        breaks = c(0, 18.5, 24.9, 29.9, 40),
                        labels = c('underweight', 'healthy', 'overweight', 'obese')
      )
      paste("You are", bmi_status)
    })
  }
  ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
      sidebarPanel(
        numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
        numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
      ),
      mainPanel(
        textOutput("bmi"),
        textOutput("bmi_range")
      )
    )
  )

  shinyApp(ui = ui, server = server)

# EX3:
  ui <- fluidPage(
    numericInput('nrows', 'Number of Rows', 10, 5, 30),
    tableOutput('table'),
    plotOutput('plot')
  )
  server <- function(input, output, session){
    cars_1 <- reactive({
      print("Computing cars_1 ...")
      head(cars, input$nrows)
    })
    cars_2 <- reactive({
      print("Computing cars_2 ...")
      head(cars, input$nrows*2)
    })
    output$plot <- renderPlot({
      plot(cars_1())
    })
    output$table <- renderTable({
      cars_1()
    })
  }
  shinyApp(ui = ui, server = server)


## Observer and Reactives:
# EX1: Add another reactive expression
  server <- function(input, output, session) {
    rval_bmi <- reactive({
      input$weight/(input$height^2)
    })
    # CODE BELOW: Add a reactive expression rval_bmi_status to
    # return health status as underweight etc. based on inputs
    rval_bmi_status <- reactive ({cut (rval_bmi(),
                                       breaks = c(0, 18.5, 24.9, 29.9, 40),
                                       labels = c('underweight', 'healthy', 'overweight', 'obese')
    )})

    output$bmi <- renderText({
      bmi <- rval_bmi()
      paste("Your BMI is", round(bmi, 1))
    })
    output$bmi_status <- renderText({
      # MODIFY CODE BELOW: Replace right-hand-side with
      # reactive expression rval_bmi_status
      bmi_status <- rval_bmi_status()
      paste("You are", bmi_status)
    })
  }
  ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
      sidebarPanel(
        numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
        numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
      ),
      mainPanel(
        textOutput("bmi"),
        textOutput("bmi_status")
      )
    )
  )

  shinyApp(ui = ui, server = server)


# EX 3 Add an observer to display notifications
  ui <- fluidPage(
    textInput('name', 'Enter your name')
  )

  server <- function(input, output, session) {
    # CODE BELOW: Add an observer to display a notification
    # 'You have entered the name xxxx' where xxxx is the name
    observe(showNotification(paste("You have entered the name",input$name)))
  }

  shinyApp(ui = ui, server = server)

## Stop - delay - trigger
# isolating actions
  output$greeting <- renderText({paste(isolate({input$greeting_type}),input$name, sep = ",")})
# delay actions
  rv_greeting <- eventReactive(input$show_greeting, {paste("hello", input$name)})
  output$greeting <- renderText({
    rv_greeting()
  })
#  trigger event
  observeEvent(input$show_greeting, {
    showModal(modalDialog(paste('Hello', input$name)))
  })

# EX1: Stop reactions with isolate()
  server <- function(input, output, session) {
    rval_bmi <- reactive({
      input$weight/(input$height^2)
    })
    output$bmi <- renderText({
      bmi <- rval_bmi()
      # MODIFY CODE BELOW:
      # Use isolate to stop output from updating when name changes.
      paste("Hi", isolate({input$name}), ". Your BMI is", round(bmi, 1))
    })
  }
  ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
      sidebarPanel(
        textInput('name', 'Enter your name'),
        numericInput('height', 'Enter your height (in m)', 1.5, 1, 2, step = 0.1),
        numericInput('weight', 'Enter your weight (in Kg)', 60, 45, 120)
      ),
      mainPanel(
        textOutput("bmi")
      )
    )
  )

  shinyApp(ui = ui, server = server)
# EX2: Delay reactions with eventReactive()
  server <- function(input, output, session) {
    # MODIFY CODE BELOW: Use eventReactive to delay the execution of the
    # calculation until the user clicks on the show_bmi button (Show BMI)
    rval_bmi <- eventReactive(
      input$show_bmi, {input$weight/(input$height^2)
      })
    output$bmi <- renderText({
      bmi <- rval_bmi()
      paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
    })
  }
  ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
      sidebarPanel(
        textInput('name', 'Enter your name'),
        numericInput('height', 'Enter height (in m)', 1.5, 1, 2, step = 0.1),
        numericInput('weight', 'Enter weight (in Kg)', 60, 45, 120),
        actionButton("show_bmi", "Show BMI")
      ),
      mainPanel(
        textOutput("bmi")
      )
    )
  )


  shinyApp(ui = ui, server = server)

#EX3: Trigger reactions with observeEvent()
  server <- function(input, output, session) {
    # MODIFY CODE BELOW: Wrap in observeEvent() so the help text
    # is displayed when a user clicks on the Help button.

    # Display a modal dialog with bmi_help_text
    # MODIFY CODE BELOW: Uncomment code
    # showModal(modalDialog(bmi_help_text))

    rv_bmi <- eventReactive(input$show_bmi, {
      input$weight/(input$height^2)
    })
    observeEvent(input$show_help, {
      showModal(modalDialog(bmi_help_text))
    })
    output$bmi <- renderText({
      bmi <- rv_bmi()
      paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
    })
  }

  ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
      sidebarPanel(
        textInput('name', 'Enter your name'),
        numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
        numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120),
        actionButton("show_bmi", "Show BMI"),
        actionButton("show_help", "Help")
        # CODE BELOW: Add an action button named "show_help"

      ),
      mainPanel(
        textOutput("bmi")
      )
    )
  )

  shinyApp(ui = ui, server = server)


## Applying reactivity concepts
  server <- function(input, output, session) {
    # MODIFY CODE BELOW: Delay the height calculation until
    # the show button is pressed
    rval_height_cm <- eventReactive(input$show_height_cm,{
      input$height * 2.54
    })

    output$height_cm <- renderText({
      height_cm <- rval_height_cm()
      paste("Your height in centimeters is", height_cm, "cm")
    })
  }

  ui <- fluidPage(
    titlePanel("Inches to Centimeters Conversion"),
    sidebarLayout(
      sidebarPanel(
        numericInput("height", "Height (in)", 60),
        actionButton("show_height_cm", "Show height in cm")
      ),
      mainPanel(
        textOutput("height_cm")
      )
    )
  )

  shinyApp(ui = ui, server = server)

### Chapter 4: Build Shiny Apps
## Build an alien sightings dashborads
# EX1 Alien sightings: add inputs
  ui <- fluidPage(
    titlePanel("UFO Sightings"),
    sidebarPanel(
      selectInput("state", "Choose a U.S. state:", choices = unique(usa_ufo_sightings$state)),
      dateRangeInput("dates", "Choose a date range:",
                     start = "1920-01-01",
                     end = "1950-01-01"
      )
    ),
    # MODIFY CODE BELOW: Create a tab layout for the dashboard
    mainPanel(
      tabsetPanel(
        tabPanel('plot',plotOutput("shapes")),
        tabPanel('table',tableOutput("duration_table"))
      )
    ))

  server <- function(input, output) {
    output$shapes <- renderPlot({
      usa_ufo_sightings %>%
        filter(
          state == input$state,
          date_sighted >= input$dates[1],
          date_sighted <= input$dates[2]
        ) %>%
        ggplot(aes(shape)) +
        geom_bar() +
        labs(
          x = "Shape",
          y = "# Sighted"
        )
    })

    output$duration_table <- renderTable({
      usa_ufo_sightings %>%
        filter(
          state == input$state,
          date_sighted >= input$dates[1],
          date_sighted <= input$dates[2]
        ) %>%
        group_by(shape) %>%
        summarize(
          nb_sighted = n(),
          avg_duration_min = mean(duration_sec) / 60,
          median_duration_min = median(duration_sec) / 60,
          min_duration_min = min(duration_sec) / 60,
          max_duration_min = max(duration_sec) / 60
        )
    })
  }

  shinyApp(ui, server)


## Exploring the 2014 mental health in tech survey
shinyWidgetsGallery()
ui <- fluidPage(
  # CODE BELOW: Add an appropriate title
  titlePanel("2014 Mental Health in Tech Survey"),
  sidebarPanel(
    # CODE BELOW: Add a checkboxGroupInput
    checkboxGroupInput(
      inputId = "mental_health_consequence",
      label = "Do you think that discussing a mental health issue with your employer would have negative consequences?",
      choices = c("Maybe", "Yes", "No"),
      selected = "Maybe"
    ),
    # CODE BELOW: Add a pickerInput
    pickerInput(
      inputId = "mental_vs_physical",
      label = "Do you feel that your employer takes mental health as seriously as physical health?",
      choices = c("Don't Know", "No", "Yes"),
      multiple = TRUE
    )
  ),
  mainPanel(
    # CODE BELOW: Display the output
    plotOutput("age")
  )
)

server <- function(input, output, session) {
  # CODE BELOW: Build a histogram of the age of respondents
  # Filtered by the two inputs
  output$age <- renderPlot({
    validate(
      need(input$mental_vs_physical != "", "Be sure to select an option")
    )
    mental_health_survey %>%
      filter(
        mental_health_consequence %in% input$mental_health_consequence,
        mental_vs_physical %in% input$mental_vs_physical
      ) %>%
      ggplot(aes(Age)) +
      geom_histogram()
  })
}

shinyApp(ui, server)
## Explore cuisines
ui <- fluidPage(
  titlePanel('Explore Cuisines'),
  sidebarLayout(
    sidebarPanel(
      selectInput('cuisine', 'Select Cuisine', unique(recipes$cuisine)),
      sliderInput('nb_ingredients', 'Select No. of Ingredients', 5, 100, 20),
    ),
    mainPanel(
      tabsetPanel(
        # CODE BELOW: Add `d3wordcloudOutput` named `wc_ingredients` in a `tabPanel`
        tabPanel('Word Cloud', d3wordcloud::d3wordcloudOutput('wc_ingredients', height = '400')),
        tabPanel('Plot', plotly::plotlyOutput('plot_top_ingredients')),
        tabPanel('Table', DT::DTOutput('dt_top_ingredients'))
      )
    )
  )
)
server <- function(input, output, session){
  # CODE BELOW: Render an interactive wordcloud of top distinctive ingredients
  # and the number of recipes they get used in, using
  # `d3wordcloud::renderD3wordcloud`, and assign it to an output named
  # `wc_ingredients`.
  output$wc_ingredients <- d3wordcloud::renderD3wordcloud({
    ingredients_df <- rval_top_ingredients()
    d3wordcloud(ingredients_df$ingredient, ingredients_df$nb_recipes, tooltip = TRUE)
  })
  rval_top_ingredients <- reactive({
    recipes_enriched %>%
      filter(cuisine == input$cuisine) %>%
      arrange(desc(tf_idf)) %>%
      head(input$nb_ingredients) %>%
      mutate(ingredient = forcats::fct_reorder(ingredient, tf_idf))
  })
  output$plot_top_ingredients <- plotly::renderPlotly({
    rval_top_ingredients() %>%
      ggplot(aes(x = ingredient, y = tf_idf)) +
      geom_col() +
      coord_flip()
  })
  output$dt_top_ingredients <- DT::renderDT({
    recipes %>%
      filter(cuisine == input$cuisine) %>%
      count(ingredient, name = 'nb_recipes') %>%
      arrange(desc(nb_recipes)) %>%
      head(input$nb_ingredients)
  })
}
shinyApp(ui = ui, server= server)
## Mass shootings
ui <- bootstrapPage(
  theme = shinythemes::shinytheme('simplex'),
  leaflet::leafletOutput('map', width = '100%', height = '100%'),
  absolutePanel(top = 10, right = 10, id = 'controls',
                sliderInput('nb_fatalities', 'Minimum Fatalities', 1, 40, 10),
                dateRangeInput(
                  'date_range', 'Select Date', "2010-01-01", "2019-12-01"
                ),
                # CODE BELOW: Add an action button named show_about
                actionButton('show_about', 'About')
  ),
  tags$style(type = "text/css", "
    html, body {width:100%;height:100%}
    #controls{background-color:white;padding:20px;}
  ")
)
server <- function(input, output, session) {
  # CODE BELOW: Use observeEvent to display a modal dialog
  # with the help text stored in text_about.
  observeEvent(input$show_about, {
    showModal(modalDialog(text_about, title = 'About'))
  })
  output$map <- leaflet::renderLeaflet({
    mass_shootings %>%
      filter(
        date >= input$date_range[1],
        date <= input$date_range[2],
        fatalities >= input$nb_fatalities
      ) %>%
      leaflet() %>%
      setView( -98.58, 39.82, zoom = 5) %>%
      addTiles() %>%
      addCircleMarkers(
        popup = ~ summary, radius = ~ sqrt(fatalities)*3,
        fillColor = 'red', color = 'red', weight = 1
      )
  })
}

shinyApp(ui, server)

