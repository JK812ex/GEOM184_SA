#################################################################
## Coursework for GEOM184 - Open Source GIS ##
## 14/11/2025 ##
## Large Wood on the Insonzo ##
## GH_App.R ##
## code by Jack Kane (jk812@exeter.ac.uk) ##
#################################################################

# Load packages ----
library(shiny)
library(leaflet)
library(sf)
library(st)
library(raster)
library(ggplot2)
library(ggiraph)
library(RColorBrewer)
library(terra)
library(leafem)
library(dbscan)

# Run global script containing all relevant data -----
source("GH_Global.R")

# Define UI for visualization ----
source("GH_UI.R")

ui <-navbarPage("Instream Large Wood on the River Isonzo", id='nav',
                tabPanel("Map",
                         div(class="outer",
                             leafletOutput("map", height="calc(100vh - 70px)")
                             )
                         )
)

# Define the server that performs all necessary operations ----
server <-function(input, output, session){
  source("GH_Server.R", local = TRUE)
}

# Run the application ----
shinyApp(ui, server)
