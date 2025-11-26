#################################################################
## Coursework for GEOM184 - Open Source GIS ##
## 14/11/2025 ##
## Large Wood on the Insonzo ##
## Global.R ##
## code by Jack Kane (jk812@exeter.ac.uk) ##
#################################################################

# Load large wood, Isonzo River, bridges, and catchments ----
lw_points <- st_read("mapdata/LW_Shapes.shp")
river <- st_read("mapdata/RiverIsonzo.shp")
bridges <- st_read("mapdata/BridgesIsonzo.shp")
catchments <- st_read("mapdata/Catchers.shp")

# Convert vectors to CRS 4326 ----
lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)
catchments <- st_transform(catchments, crs = 4326)

# Perform clustering ----
lw_coords <- st_coordinates(lw_points)
clusters <- dbscan(lw_coords, eps = 0.008, minPts = 3)
lw_points$cluster <- as.factor(clusters$cluster)

# Dynamically generate colors based on number of unique clusters
num_clusters <- length(unique(clusters$cluster))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters),
domain = clusters$cluster)

# Adding the QGIS heatmap ----
heatmap <- rast("mapdata/Iso_Heatmap3.tif")
heatmap <- project(heatmap, crs(river))
pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)),
                            na.color = "transparent")

# Calculate distance to nearest bridge ----
nearest_bridge <- st_nearest_feature(lw_points, bridges)
lines_list <- mapply(function(p, b) {
  st_linestring(rbind
                (st_coordinates(p),
                  st_coordinates(b)
                  )
                )
}, st_geometry(lw_points),
st_geometry(bridges[nearest_bridge,]),
SIMPLIFY = FALSE)
lw_to_bridge_lines <- st_sfc(
  lines_list, crs = st_crs(lw_points)) |> st_sf()
