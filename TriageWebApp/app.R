#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

getTriageCategory <- function(age, gender, height, weight,
                              smoking, pregnancy,
                              avpu, gcs, rr, pulse,
                              heartrate, o2sat){
    result <- paste("age:",age,
                    "gender:",gender,
                    "weight:",weight,
                    "height:",height,
                    "smoking:",smoking,
                    "avpu",avpu,
                    "gcs",gcs,
                    "rr",rr,
                    "pulse",pulse,
                    "heartrate",heartrate,
                    "o2sat",o2sat,
                    sep = " ")
    return(result)
}

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Emergency Department- Triage Assessment"),
    
    
    fluidRow(
        h2("Patient Details"),
        
        column(3,
               
               numericInput("ageInput", label = "Age", min = 0, max = 150, value = 0),
               
               selectInput("genderInput",
                           label = "Gender",
                           choices = list("Male" = 1, "Female" = 2),
                           selected = 1),
               
               numericInput("heightInput", label = "Height", value = 0),
               
               numericInput("weightInput", label = "Weight", value = 0),
               
               radioButtons("smokingInput", label = "Smoking", 
                            choices = list("Smoking"=1, "Non-Smoking"=2),
                            selected = 2
               ),
               
               radioButtons("pregnancyInput", label = "Pregnancy", 
                            choices = list("Pregnant"=1, "Non-Pregnant"=2),
                            selected = 2
               ),
               
               ),
        
        column(3,
               
               h2("Vital Signs"),
               
               selectInput("avpuInput", 
                           label = "AVPU",
                           choices = list("Alert" = 1, 
                                          "Pain" = 2,
                                          "Unresponsive" = 3,
                                          "Verbal" = 4,
                                          "Touch" = 5
                                          ),
                           
                           selected = 1
                           ),
               
               numericInput("gcsInput", label = "GCS", value = 0),
               
               numericInput("rrInput", label = "Respiratory Rate", value = 0),
               
               numericInput("pulseInput", label = "Pulse", value = 0),
               
               numericInput("heartInput", label = "Heart Rate", value = 0),
               
               numericInput("o2satInput", label = "O2 Saturation", value = 0),
               
               submitButton("Submit")
               
               
        ),
        
        column(6,
               h2("Triage Prediction"),
               
               h3(textOutput("triagePrediction")),
               
               offset = 0)
        
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$patientID <- renderText(
        "00001"
    )
    
    output$triagePrediction <- renderText(
        getTriageCategory(age = input$ageInput, 
                          gender = input$genderInput,
                          height = input$heightInput,
                          weight = input$weightInput,
                          smoking = input$smokingInput,
                          pregnancy = input$pregnancyInput,
                          avpu = input$avpuInput, 
                          gcs = input$gcsInput, 
                          rr = input$rrInput, 
                          pulse = input$pulseInput,
                          heartrate = input$heartInput, 
                          o2sat = input$o2satInput
                          )
        
        )
     
}



# Run the application 
shinyApp(ui = ui, server = server)
