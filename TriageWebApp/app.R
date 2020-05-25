#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

getTriageCategory <- function(age, gender){
    result <- paste("age:",age,"gender:",gender,sep = " ")
    return(result)
}

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    fluidRow(
        column(12,
               # Application title
               titlePanel("Triage Web App")
               )
        
    ),
    
    fluidRow(
        column(6,
               h1("Patient Details"),
               numericInput("ageInput", label = "Age", min = 0, max = 150, value = 0),
               
               selectInput("genderInput",
                           label = "Gender",
                           choices = list("Male" = 1, "Female" = 2),
                           selected = 1),
               
               submitButton("Submit")
               
               
               ),
        
        column(6,
               h1("Triage Prediction"),
               
               h3(textOutput("triagePrediction")),
               
               offset = 6)
        
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$triagePrediction <- renderText(
        getTriageCategory(input$ageInput, input$genderInput)
        )
     
}



# Run the application 
shinyApp(ui = ui, server = server)
