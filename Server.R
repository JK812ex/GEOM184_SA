#################################################################
## Coursework for GEOM184 - Open Source GIS ##
## 14/11/2025 ##
## Large Wood on the Insonzo ##
## Server.R ##
## code by Jack Kane (jk812@exeter.ac.uk) ##
#################################################################

# Defines Server
server <-function(input, output, session){

# Render leaflet map ----
# Leaflet map output
output$map <- renderLeaflet({
  leaflet() %>%
    setView(lng=13.533545, lat=45.850065, zoom=11.3) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolylines(data = lw_to_bridge_lines,
                 color = "red",
                 weight = 4,
                 group = "Nearest Bridge") %>%
    addPolylines(data = catchments,
                 color = "brown",
                 opacity = 1,
                 weight = 5,
                 group = "Catchments") %>%
    addPolylines(data = river,
                 color = "blue",
                 weight = 2,
                 opacity = 0.8,
                 group = "Isonzo River") %>%
    addCircles(data = bridges,
               color = "black",
               fillColor="purple",
               fillOpacity=1,
               weight = 2,
               radius = 50,
               group = "Bridges") %>%
    addCircles(data = lw_points,
               fillColor = "brown",
               fillOpacity = 1,
               color = "black",
               weight = 2,
               radius = 12,
               group = "Large Wood") %>%
  addRasterImage(heatmap,
                 colors = pal_heatmap,
                 opacity = 0.7,
                 group = "Heatmap") %>%
  addImageQuery(heatmap,
                layerId = "Heatmap",
                prefix = "Value: ",
                digits = 2,
                position = "bottomleft",
                type = "mousemove",
                options = queryOptions(position = "topright"),
                group = "Heatmap") %>%
  addLayersControl(
    overlayGroups = c("Isonzo River", "Bridges", "Large Wood", "Catchments", "Nearest Bridge", "Heatmap", "Clusters"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
    hideGroup("Nearest Bridge") %>%
    hideGroup("Heatmap")
})

# Popups for large wood clusters ----
observe({
  leafletProxy("map") %>%
    clearMarkers() %>%
    addCircleMarkers(data = lw_points,
  fillColor = ~pal_clusters(cluster),
  color = "black",
  weight = 1,
  radius = 5,
  stroke = TRUE,
  fillOpacity = 0.7,
  popup = ~paste("<b>Large Wood Type:</b>", LW_Type,
                  "<br><b>Cluster ID:</b>", cluster),
  group = "Clusters")
 })
}
