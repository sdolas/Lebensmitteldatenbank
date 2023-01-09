library(shiny)
library(shinythemes)

load("meine_umgebung.RData")

ui <- fluidPage(
  theme = shinytheme("slate"),
  
  textInput(
    inputId = "regex",
    label = "Suchleiste",
    value = ""
  ),
  
  "Suchergebnisse",
  
  tableOutput("makros"),
  tableOutput("vitamine"),
  tableOutput("mineralstoffe"),
  tableOutput("spurenelemente"),
  tableOutput("aminos"),
  tableOutput("kohlenhydrate"),
  tableOutput("ballaststoffe"),
  tableOutput("fette")
  
)


server <- function(input, output, session){
  
  regex <- reactive(input$regex)
  
  output$makros <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    makros[grepl(regex_new, regex_compare), -2] |> head(n=1)
  })
  
  output$vitamine <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    vitamine[grepl(regex_new, regex_compare),] |> head(n=1)
  })
  
  output$mineralstoffe <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    mineralstoffe[grepl(regex_new, regex_compare),] |> head(n=1)
  })
  
  output$spurenelemente <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    spurenelemente[grepl(regex_new, regex_compare),] |> head(n=1)
  })
  
  output$aminos <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    aminos[grepl(regex_new, regex_compare),] |> head(n=1)
  })
  
  output$kohlenhydrate <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    kohlenhydrate[grepl(regex_new, regex_compare),] |> head(n=1)
  })
  
  output$ballaststoffe <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    ballaststoffe[grepl(regex_new, regex_compare),] |> head(n=1)
  })
  
  output$fette <- renderTable({
    regex_compare <- paste(makros$name, makros$Kategorie)
    regex_new <- gsub(" ", ".*", paste0("(?i)",regex()))
    fette[grepl(regex_new, regex_compare),] |> head(n=1)
  })
  
  
  
}

shinyApp(ui, server)




