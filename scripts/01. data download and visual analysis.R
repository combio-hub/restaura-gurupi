# Packages ----
packages <- c("terra","sf","ggplot2","gganimate","reshape2","stringr","ggspatial","patchwork","av")
missing_packages <- packages[!vapply(packages,requireNamespace,logical(1),quietly=TRUE)]
if(length(missing_packages))stop("Install missing packages: install.packages(c(",paste(shQuote(missing_packages),collapse=","),"))")
invisible(lapply(packages,library,character.only=TRUE))
library(stringr)
library(terra)

# Download and organize files for analysis ----
dir.create("dataset/spatial/raster/fire")
severity_base = "dataset/spatial/raster/fire/severity/"
burned_base = "dataset/spatial/raster/fire/annual/"
freq_base = "dataset/spatial/raster/fire/frequency/"
interval_base = "dataset/spatial/raster/fire/interval/"
soil_base = "dataset/spatial/raster/soil/"
def_base = "dataset/spatial/raster/deforestation/"
land_base = "dataset/spatial/raster/land_use/"
elev_base = "dataset/spatial/raster/elevation/"

if(!file.exists(severity_base)){dir.create(severity_base)}
if(!file.exists(burned_base)){dir.create(burned_base)}
if(!file.exists(freq_base)){dir.create(freq_base)}
if(!file.exists(interval_base)){dir.create(interval_base)}
if(!file.exists(soil_base)){dir.create(soil_base)}
if(!file.exists(def_base)){dir.create(def_base)}
if(!file.exists(land_base)){dir.create(land_base)}
if(!file.exists(elev_base)){dir.create(elev_base)}

severity_links = paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/brasil/collection_10/fire-col5/mapbiomas_fire_collection5_severity_class_v1/severity_class_",2012:2025,".tif")
burned_links = paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/brasil/collection_10/fire-col5/mapbiomas_fire_collection5_annual_burned_v1/burned_area_",2012:2025,".tif")
freq_links = paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/brasil/collection_10/fire-col5/mapbiomas_fire_collection5_fire_frequency_v1/fire_frequency_1985_",2012:2025,".tif")
interval_links = paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/brasil/collection_10/fire-col5/mapbiomas_fire_collection5_interval_since_fire_v1/interval_since_fire_",2012:2025,".tif")
carbon_links = paste0("https://storage.googleapis.com/shared-development-storage/COLLECTIONS/BRASIL/SOLO/COLLECTION3/mbsoil_c03_carbon_v1/mbsoil03-carbon_",2012:2025,"_v1.tif")
def_links = paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/brazil/lulc/collection_11/deforestation_secondary_vegetation/deforestation_secondary_vegetation-brazil_classification_",2012:2025,".tif")
land_links = paste0("https://storage.googleapis.com/mapbiomas-public/initiatives/brasil/lulc_10m/collection4/coverage/brazil_coverage/brazil_coverage-col4_10m_",2017:2025,".tif")

extents = st_bbox(st_transform(st_buffer(AoI,5000),4326))

for(x in 1:length(severity_links)){
  if(!file.exists(file.path(severity_base,tail(str_split(severity_links[x],"/")[[1]],1)))){
    download.file(severity_links[x],destfile = file.path(severity_base,tail(str_split(severity_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(severity_base,tail(str_split(severity_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(severity_base,tail(str_split(severity_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
  
  if(!file.exists(file.path(freq_base,tail(str_split(freq_links[x],"/")[[1]],1)))){
    download.file(freq_links[x],destfile = file.path(freq_base,tail(str_split(freq_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(freq_base,tail(str_split(freq_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(freq_base,tail(str_split(freq_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
  
  if(!file.exists(file.path(interval_base,tail(str_split(interval_links[x],"/")[[1]],1)))){
    download.file(interval_links[x],destfile = file.path(interval_base,tail(str_split(interval_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(interval_base,tail(str_split(interval_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(interval_base,tail(str_split(interval_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
  
  if(!file.exists(file.path(soil_base,tail(str_split(carbon_links[x],"/")[[1]],1)))){
    download.file(carbon_links[x],destfile = file.path(soil_base,tail(str_split(carbon_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(soil_base,tail(str_split(carbon_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(soil_base,tail(str_split(carbon_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
  
  if(!file.exists(file.path(def_base,tail(str_split(def_links[x],"/")[[1]],1)))){
    download.file(def_links[x],destfile = file.path(def_base,tail(str_split(def_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(def_base,tail(str_split(def_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(def_base,tail(str_split(def_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
  
  if(!file.exists(file.path(burned_base,tail(str_split(burned_links[x],"/")[[1]],1)))){
    download.file(burned_links[x],destfile = file.path(burned_base,tail(str_split(burned_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(burned_base,tail(str_split(burned_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(burned_base,tail(str_split(burned_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
  if(!file.exists(file.path(land_base,tail(str_split(land_links[x],"/")[[1]],1)))){
    download.file(land_links[x],destfile = file.path(land_base,tail(str_split(land_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(land_base,tail(str_split(land_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(land_base,tail(str_split(land_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
}

clay_links = paste0("https://storage.googleapis.com/shared-development-storage/COLLECTIONS/BRASIL/SOLO/COLLECTION3/mbsoil_c03_clay_fraction_v1/mbsoil03-","clay","_fraction_",c("000_010","010_020","020_030","030_040","040_050","050_060","060_070","080_090","090_100"),"cm_v1.tif")
sand_links = paste0("https://storage.googleapis.com/shared-development-storage/COLLECTIONS/BRASIL/SOLO/COLLECTION3/mbsoil_c03_sand_fraction_v1/mbsoil03-","sand","_fraction_",c("000_010","010_020","020_030","030_040","040_050","050_060","060_070","080_090","090_100"),"cm_v1.tif")
silt_links = paste0("https://storage.googleapis.com/shared-development-storage/COLLECTIONS/BRASIL/SOLO/COLLECTION3/mbsoil_c03_silt_fraction_v1/mbsoil03-","silt","_fraction_",c("000_010","010_020","020_030","030_040","040_050","050_060","060_070","080_090","090_100"),"cm_v1.tif")

for(x in 1:length(clay_links)){
  if(!file.exists(file.path(soil_base,tail(str_split(clay_links[x],"/")[[1]],1)))){
    download.file(clay_links[x],destfile = file.path(soil_base,tail(str_split(clay_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(soil_base,tail(str_split(clay_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(soil_base,tail(str_split(clay_links[x],"/")[[1]],1)),overwrite=TRUE)  
  }
  if(!file.exists(file.path(soil_base,tail(str_split(clay_links[x],"/")[[1]],1)))){
    download.file(sand_links[x],destfile = file.path(soil_base,tail(str_split(sand_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(soil_base,tail(str_split(sand_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(soil_base,tail(str_split(sand_links[x],"/")[[1]],1)),overwrite=TRUE)
  }
  if(!file.exists(file.path(soil_base,tail(str_split(clay_links[x],"/")[[1]],1)))){
    download.file(silt_links[x],destfile = file.path(soil_base,tail(str_split(silt_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(soil_base,tail(str_split(silt_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(soil_base,tail(str_split(silt_links[x],"/")[[1]],1)),overwrite=TRUE) 
  }
}

elev_links = c("https://data.inpe.br/bdc/data/topodata/v001/03S/48_/03S48_ZN.tif",
               "https://data.inpe.br/bdc/data/topodata/v001/04S/48_/04S48_ZN.tif")

for(x in 1:length(elev_links)){
  if(!file.exists(file.path(elev_base,tail(str_split(elev_links[x],"/")[[1]],1)))){
    download.file(elev_links[x],destfile = file.path(elev_base,tail(str_split(elev_links[x],"/")[[1]],1)),method = "curl")
    r = rast(file.path(elev_base,tail(str_split(elev_links[x],"/")[[1]],1)))
    r = crop(r,extents)
    terra::writeRaster(r,file.path(elev_base,tail(str_split(elev_links[x],"/")[[1]],1)),overwrite=TRUE)  
  }
}

r_elevs = file.path(elev_base,unlist(lapply(str_split(elev_links,"/"),tail,1)))
r_elevs = lapply(r_elevs,rast)
r_elevs <- mosaic(r_elevs[[1]],r_elevs[[2]], fun = "mean")
#plot(r_elevs)
terra::writeRaster(r_elevs,file.path(elev_base,"elevation.tif"),overwrite=TRUE)  
file.remove(file.path(elev_base,unlist(lapply(str_split(elev_links,"/"),tail,1))))

# Plot all predictors ----
severity_base = "dataset/spatial/raster/fire/severity/"
burned_base = "dataset/spatial/raster/fire/annual/"
freq_base = "dataset/spatial/raster/fire/frequency/"
interval_base = "dataset/spatial/raster/fire/interval/"
soil_base = "dataset/spatial/raster/soil/"
def_base = "dataset/spatial/raster/deforestation/"
land_base = "dataset/spatial/raster/land_use/"
elev_base = "dataset/spatial/raster/elevation/"

land_files = dir(land_base,pattern = "brazil_coverage-col4_10m_[0-9][0-9][0-9][0-9].tif$",full.names = T)
elev_files = dir(elev_base,pattern = "*.tif$",full.names = T)
severity_files = dir(severity_base,pattern = "*.tif$",full.names = T)
burned_files = dir(burned_base,pattern = "*.tif$",full.names = T)
freq_files = dir(freq_base,pattern = "*.tif$",full.names = T)
interval_files = dir(interval_base,pattern = "*.tif$",full.names = T)
clay_files = dir(soil_base,pattern = "*mbsoil03-clay_fraction_[0-9]+_[0-9]+cm_v1.tif$",full.names = T)
silt_files = dir(soil_base,pattern = "*mbsoil03-silt_fraction_[0-9]+_[0-9]+cm_v1.tif$",full.names = T)
sand_files = dir(soil_base,pattern = "*mbsoil03-sand_fraction_[0-9]+_[0-9]+cm_v1.tif$",full.names = T)
carbon_files = dir(soil_base,pattern = "mbsoil03-carbon_[0-9]+_v1.tif$",full.names = T)
def_files = dir(def_base,pattern = "*.tif$",full.names = T)

read.csv("dataset/legend_code_mapbiomas_brazil_collection_11.csv",h=T,sep=",")->cols

AoI = read_sf("dataset/spatial/vector/fazenda.shp")
AoI = st_transform(AoI,31983)

# land_r = lapply(land_files,rast)
# land_r = lapply(land_r,crop,extents)
# dir.create("dataset/spatial/raster/land_use")
# for(x in 1:length(land_r)){
#   terra::writeRaster(land_r[[x]],file.path("dataset/spatial/raster/land_use",paste0(names(land_r[[x]]),".tif")),overwrite=TRUE)
# }
# land_r = rast(land_r)
# plot(land_r)

# elev_r = lapply(elev_files,rast)
# elev_r = lapply(elev_r,crop,extents)
# elev_r <- mosaic(elev_r[[1]], elev_r[[2]], fun = "mean")
# plot(elev_r)
# dir.create("dataset/spatial/raster/elevation")
# terra::writeRaster(elev_r,"dataset/spatial/raster/elevation/elevation.tif",overwrite=TRUE)

## Dynamic ----
video_dimensions <- function(r,map_long_side=1000,legend_space=240,title_space=140){
  bounds <- as.vector(terra::ext(r))
  dx <- bounds[2]-bounds[1]
  dy <- bounds[4]-bounds[3]
  # Correct longitude width for latitude when coordinates are geographic.
  if(terra::is.lonlat(r))dx <- dx*cos(mean(bounds[3:4])*pi/180)
  ratio <- dx/dy
  if(!is.finite(ratio)||ratio<=0)stop("Invalid raster extent.")
  map_width <- if(ratio>=1)map_long_side else map_long_side*ratio
  map_height <- if(ratio>=1)map_long_side/ratio else map_long_side
  # H.264 with yuv420p requires even pixel dimensions.
  c(width=2*ceiling((map_width+legend_space)/2),height=2*ceiling((map_height+title_space)/2))
}

### Land use ----
land_r = lapply(land_files,rast)
land_r = rast(land_r)
names(land_r) = str_extract(names(land_r),"[0-9][0-9][0-9][0-9]")

crop_areas = lapply(1:nrow(AoI),function(x){
  return(crop(land_r,st_transform(st_buffer(AoI[x,],1000),4326),mask = TRUE))
})

library(gganimate)
library(reshape2)

nomez = c("Fazenda Cardoso","Vila Bom Jesus","Área de Queimada")

land_anims = lapply(1:nrow(AoI),function(x){
  g_df = as.data.frame(crop_areas[[x]],xy=T)
  g_df = melt(g_df,id.vars = c("x","y"))
  dims <- video_dimensions(crop_areas[[i]])
  names(dims) = c("width","height")
  ggplot() +
    geom_tile(data = g_df, aes(x = x,y = y,fill = as.factor(value),group = as.factor(variable))) +
    scale_fill_manual(values = cols$hex_code, 
                      labels = cols$class_name_pt_br, 
                      breaks = cols$class_id,
                      name="Cobertura do solo",
                      na.value = "transparent") + 
    geom_sf(data=st_intersection(hidro,st_transform(st_buffer(AoI[x,],1000),4326)),colour='lightblue',linetype='solid',fill = NA) +
    geom_sf(data=st_transform(AoI[x,],4326),colour='black',linetype='solid',fill = NA) +
    annotation_scale(location="br")+ # scale bar
    annotation_north_arrow(location="tl")+ # north arrow
    theme_minimal()+
    theme(axis.title = element_blank())+
    transition_manual(variable)+
    theme(legend.justification = "top",legend.text.align = 1,legend.title.align=1,legend.position = "right", legend.background = element_rect(fill="NA", colour = "NA"), legend.title = element_text(face="bold", family = "sans", colour = "black", size=12), legend.text = element_text(family ="sans", size=10), axis.text = element_text(family = "sans", colour = "black", size=12))-> anim_land_1
  
  anim_land_1 <- anim_land_1 +
    labs(title = paste0(nomez[x],"\nAno: {current_frame}")) +
    theme(plot.title = element_text(size = 18,face = "bold",hjust = 0.5))
  
  n_quadros <- length(unique(g_df$variable))
  
  arquivo <- file.path(
    "figures",
    paste0(gsub(" ", "_", nomez[x]), "_cobertura_solo.mp4")
  )
  
  AnimLand1 <- gganimate::animate(
    anim_land_1,
    nframes = n_quadros + 2,
    fps = 1,
    start_pause = 0,
    width = dims[1],
    height = dims[2],
    end_pause = 2,
    rewind = FALSE,
    renderer = gganimate::av_renderer(
      file = arquivo,
      codec = "libx264",
      vfilter = "format=yuv420p"
    )
  )
  return(AnimLand1)
})

land_anims[[1]]
land_anims[[2]]
land_anims[[3]]

library(ggplot2)
library(sf)
library(patchwork)

cores <- setNames(cols$hex_code, as.character(cols$class_id))

# Mesma legenda em todas as linhas
classes <- as.character(cols$class_id)
classes <- classes[
  classes %in% unique(as.character(g_df$value))
]

plots <- lapply(seq_len(nrow(AoI)), function(i) {
  
  dados <- g_df[g_df$area == nomez[i], ]
  
  aoi <- st_transform(AoI[i, ], 4326)
  
  # Interseção em CRS projetado, com unidades em metros
  # AoI foi transformado para EPSG:31983 no seu script
  buffer <- st_buffer(AoI[i, ], dist = 1000)
  
  rios <- st_intersection(st_geometry(st_transform(hidro, st_crs(buffer))),st_geometry(buffer))
  rios <- st_transform(rios, 4326)
  
  ggplot() +
    geom_tile(data = dados,aes(x = x, y = y, fill = as.factor(value))) +
    scale_fill_manual(values = cores,limits = classes,breaks = classes,labels = cols$class_name_pt_br[match(classes, as.character(cols$class_id))],drop = FALSE,name = "Cobertura do solo",na.value = "transparent") +
    geom_sf(data = rios,colour = "lightblue",fill = NA,alpha=0.7,linewidth=0.5) +
    geom_sf(data = aoi,colour = "black",fill = NA) +
    coord_sf(crs = st_crs(4326),default_crs = st_crs(4326),xlim = range(dados$x, na.rm = TRUE),ylim = range(dados$y, na.rm = TRUE),expand = FALSE) +
    facet_wrap(~ variable, nrow = 1, drop = FALSE) +
    labs(title = nomez[i]) +
    guides(fill = "none")+
    theme_minimal() +
    theme(axis.title = element_blank(),axis.text = element_text(size = 6),strip.text = element_text(face = "bold"),plot.title = element_text(face = "bold", size = 12),legend.title = element_text(face = "bold"))
})

grid_land <- wrap_plots(plots,ncol = 1,guides = "collect") & theme(legend.position = "right")

#grid_land
ggsave(plot = grid_land,filename = "figures/grid_land.tif",width=12,height=6,dpi=300,units="in")

### Settings ----
nomez <- c("Fazenda Cardoso","Vila Bom Jesus","Área de Queimada")
output_dir <- "figures"
buffer_m <- 1000
buffer_crs <- 31983
end_pause <- 2L
video_width <- 1200
video_height <- 800
grid_dpi <- 300

stopifnot(inherits(AoI,"sf"),nrow(AoI)==length(nomez),!anyDuplicated(nomez))
if(is.na(st_crs(AoI))||is.na(st_crs(hidro)))stop("AoI and hidro must have a defined CRS.")
if(!"libx264"%in%av::av_encoders()$name)stop("The installed av package does not provide libx264.")
dir.create(output_dir,showWarnings=FALSE,recursive=TRUE)

### Predictor configuration ----
# Categorical labels/colours can be named vectors: c("1"="Label","2"="Label").
# NULL displays the original class codes with automatically generated colours.
# multiplier=1 preserves the values stored in the raster.
# Annual burned area: positive values become 1; zero stays zero; NA stays NA.
predictors <- list(
  severity=list(files=severity_files,title="Severidade do fogo",legend="Classe de severidade",type="categorical",palette="YlOrRd",labels=NULL,colours=NULL,multiplier=1),
  burned=list(files=burned_files,title="Área queimada anual",legend="Área queimada",type="burned",palette=NULL,labels=c("0"="Não queimado (valor 0)","1"="Queimado"),colours=c("0"="#eeeeee","1"="#d73027"),multiplier=1),
  frequency=list(files=freq_files,title="Frequência acumulada de fogo",legend="Número de anos\ncom fogo",type="continuous",palette="YlOrRd",labels=NULL,colours=NULL,multiplier=1),
  interval=list(files=interval_files,title="Tempo desde o último fogo",legend="Anos desde\no último fogo",type="continuous",palette="viridis",labels=NULL,colours=NULL,multiplier=1),
  carbon=list(files=carbon_files,title="Carbono orgânico do solo",legend="Carbono do solo\n(unidade do raster)",type="continuous",palette="viridis",labels=NULL,colours=NULL,multiplier=1),
  deforestation=list(files=def_files,title="Desmatamento e vegetação secundária",legend="Código da classe",type="categorical",palette="Dark 3",labels=NULL,colours=NULL,multiplier=1)
)

### Prepare spatial overlays once ----
aoi_m <- st_make_valid(st_transform(AoI,buffer_crs))
hidro_m <- st_make_valid(st_transform(st_geometry(hidro),buffer_crs))

overlays <- lapply(seq_len(nrow(aoi_m)),function(i){
  aoi <- st_sf(geometry=st_geometry(aoi_m[i,]))
  buffer <- st_buffer(aoi,dist=buffer_m)
  intersects <- lengths(st_intersects(hidro_m,st_geometry(buffer)))>0
  rivers <- st_intersection(hidro_m[intersects],st_geometry(buffer))
  list(aoi=aoi,buffer=buffer,rivers=st_sf(geometry=rivers))
})

### Helpers ----
safe_name <- function(x){
  y <- iconv(x,from="",to="ASCII//TRANSLIT")
  y[is.na(y)] <- x[is.na(y)]
  gsub("[^A-Za-z0-9_-]+","_",y)
}

extract_year <- function(files){
  matches <- str_extract_all(basename(files),"(?<![0-9])(?:19|20)[0-9]{2}(?![0-9])")
  years <- vapply(matches,function(z)if(length(z))as.integer(tail(z,1))else NA_integer_,integer(1))
  if(anyNA(years))stop("Cannot extract year from: ",paste(basename(files[is.na(years)]),collapse=", "))
  years
}

read_annual <- function(files){
  if(!length(files))stop("Empty raster file vector.")
  if(any(!file.exists(files)))stop("Missing files: ",paste(files[!file.exists(files)],collapse=", "))
  years <- extract_year(files)
  if(anyDuplicated(years))stop("Duplicate years: ",paste(unique(years[duplicated(years)]),collapse=", "))
  ord <- order(years)
  files <- files[ord]
  years <- years[ord]
  layers <- lapply(files,terra::rast)
  if(any(vapply(layers,terra::nlyr,numeric(1))!=1))stop("Expected one annual band per file.")
  r <- terra::rast(layers)
  names(r) <- as.character(years)
  if(!nzchar(terra::crs(r)))stop("Raster CRS is missing.")
  if(length(years)>1L&&any(diff(years)!=1L))warning("Missing years in source files: ",paste(setdiff(seq(min(years),max(years)),years),collapse=", "))
  r
}

to_long <- function(r,cfg){
  # Numeric matrix preserves raster codes, including categorical rasters.
  xy <- terra::xyFromCell(r,seq_len(terra::ncell(r)))
  vals <- terra::values(r,mat=TRUE)
  vals[!is.finite(vals)] <- NA_real_
  if(cfg$type=="burned"){
    if(any(vals<0,na.rm=TRUE))stop("Negative burned-area values found; check the raster coding.")
    vals[!is.na(vals)] <- as.numeric(vals[!is.na(vals)]>0)
  }
  vals <- vals*cfg$multiplier
  colnames(vals) <- names(r)
  wide <- data.frame(x=xy[,1],y=xy[,2],vals,check.names=FALSE)
  # Keep NA rows so that years without valid pixels are not dropped.
  long <- reshape2::melt(wide,id.vars=c("x","y"),variable.name="variable",value.name="value",na.rm=FALSE)
  long$variable <- factor(as.character(long$variable),levels=names(r))
  long
}

make_scale <- function(cfg,class_ids,value_limits){
  if(cfg$type%in%c("categorical","burned")){
    palette <- cfg$colours
    if(is.null(palette))palette <- setNames(grDevices::hcl.colors(max(1L,length(class_ids)),palette=cfg$palette),class_ids)
    missing_colours <- setdiff(class_ids,names(palette))
    if(length(missing_colours))stop("Missing colours for classes: ",paste(missing_colours,collapse=", "))
    labels <- setNames(paste("Classe",class_ids),class_ids)
    if(!is.null(cfg$labels)){
      common <- intersect(class_ids,names(cfg$labels))
      labels[common] <- cfg$labels[common]
    }
    return(scale_fill_manual(values=palette,limits=class_ids,breaks=class_ids,labels=unname(labels[class_ids]),drop=FALSE,na.translate=FALSE,na.value="transparent",name=cfg$legend))
  }
  if(cfg$palette=="viridis")return(scale_fill_viridis_c(option="C",limits=value_limits,na.value="transparent",name=cfg$legend))
  scale_fill_gradientn(colours=grDevices::hcl.colors(100,palette=cfg$palette),limits=value_limits,na.value="transparent",name=cfg$legend)
}

### Reusable predictor workflow ----
render_predictor <- function(id,cfg){
  message("\nProcessing: ",id)
  r <- read_annual(cfg$files)
  years <- names(r)
  raster_crs <- st_crs(terra::crs(r))
  
  crops <- lapply(seq_along(overlays),function(i){
    message("  Cropping: ",nomez[i])
    boundary <- terra::vect(st_transform(overlays[[i]]$buffer,raster_crs))
    terra::crop(r,boundary,mask=TRUE)
  })
  
  data_list <- lapply(crops,to_long,cfg=cfg)
  categorical <- cfg$type%in%c("categorical","burned")
  class_ids <- character()
  value_limits <- NULL
  
  if(categorical){
    codes <- sort(unique(unlist(lapply(data_list,function(d)unique(d$value[!is.na(d$value)])),use.names=FALSE)))
    class_ids <- as.character(codes)
    if(!length(class_ids)&&!is.null(cfg$colours))class_ids <- names(cfg$colours)
    for(i in seq_along(data_list))data_list[[i]]$value <- factor(as.character(data_list[[i]]$value),levels=class_ids)
  }else{
    ranges <- lapply(data_list,function(d){
      z <- d$value[is.finite(d$value)]
      if(length(z))range(z)else c(NA_real_,NA_real_)
    })
    endpoints <- unlist(ranges,use.names=FALSE)
    endpoints <- endpoints[is.finite(endpoints)]
    if(length(endpoints)){
      value_limits <- range(endpoints)
      if(diff(value_limits)==0){
        padding <- max(abs(value_limits[1])*0.01,0.5)
        value_limits <- value_limits+c(-padding,padding)
      }
    }
  }
  
  has_values <- any(vapply(data_list,function(d)any(!is.na(d$value)),logical(1)))
  if(!has_values)warning(id,": all cropped values are NA; output maps will show overlays only.")
  
  plots <- vector("list",length(nomez))
  videos <- setNames(character(length(nomez)),nomez)
  
  for(i in seq_along(nomez)){
    message("  Rendering: ",nomez[i])
    dados <- data_list[[i]]
    aoi <- st_transform(overlays[[i]]$aoi,raster_crs)
    rios <- st_transform(overlays[[i]]$rivers,raster_crs)
    bounds <- as.vector(terra::ext(crops[[i]]))
    cell_size <- terra::res(crops[[i]])
    
    p <- ggplot()+
      geom_tile(data=dados,aes(x=x,y=y,fill=value),width=cell_size[1],height=cell_size[2],alpha=1)+
      make_scale(cfg,class_ids,value_limits)+
      geom_sf(data=rios,colour="lightblue",fill=NA,alpha=0.7,linewidth=0.1)+
      geom_sf(data=aoi,colour="black",fill=NA,linewidth=0.4)+
      coord_sf(crs=raster_crs,default_crs=raster_crs,xlim=bounds[1:2],ylim=bounds[3:4],expand=FALSE)+
      theme_minimal()+
      theme(axis.title=element_blank(),axis.text=element_text(size=8),legend.position="right",legend.justification="top",legend.title=element_text(face="bold",size=11),legend.text=element_text(size=9),plot.title=element_text(face="bold",size=15,hjust=0.5),panel.grid.minor=element_blank(),plot.background=element_rect(fill="white",colour=NA))
    
    if(!has_values)p <- p+guides(fill="none")
    
    animated <- p+
      ggspatial::annotation_scale(location="br",width_hint=0.25)+
      ggspatial::annotation_north_arrow(location="tl")+
      labs(title=paste0(nomez[i],"\n",cfg$title," | Ano: {current_frame}"))+
      gganimate::transition_manual(variable)
    
    videos[i] <- file.path(output_dir,paste0(safe_name(nomez[i]),"_",id,".mp4"))
    
    dims <- video_dimensions(crops[[i]])
    names(dims) = c("width","height")
    message("  Video dimensions: ",dims["width"]," × ",dims["height"])
    
    animation <- gganimate::animate(animated,nframes=length(years)+end_pause,fps=1,start_pause=0,end_pause=end_pause,rewind=FALSE,width=unname(dims["width"]),height=unname(dims["height"]),renderer=gganimate::av_renderer(file=videos[i],codec="libx264",vfilter="format=yuv420p"))
    
    # Verify that the rendered sequence contains every source year.
    shown <- unique(as.character(gganimate::frame_vars(animation)$current_frame))
    if(!setequal(shown,years))stop("Rendered years differ from source years for ",nomez[i],"/",id)
    
    plots[[i]] <- p+
      facet_wrap(~variable,nrow=1,drop=FALSE)+
      labs(title=nomez[i])+
      theme(axis.text=element_text(size=5),strip.text=element_text(face="bold",size=8),plot.title=element_text(face="bold",size=12,hjust=0))
  }
  
  grid <- (patchwork::wrap_plots(plots,ncol=1,guides="collect")+
             patchwork::plot_annotation(title=cfg$title))&
    theme(legend.position="right")
  
  grid_file <- file.path(output_dir,paste0("grid_",id,".tif"))
  ggsave(filename=grid_file,plot=grid,width=max(12,length(years)*1.45+2.5),height=max(4,length(nomez)*2.3),units="in",dpi=grid_dpi,compression="lzw",bg="white",limitsize=FALSE)
  
  message("  Saved: ",length(videos)," videos and ",grid_file)
  # Return paths rather than retaining all raster tables and plots in memory.
  list(videos=videos,grid=grid_file,years=years)
}

### Run all six predictors ----
results <- setNames(vector("list",length(predictors)),names(predictors))
for(id in names(predictors)){
  results[[id]] <- render_predictor(id,predictors[[id]])
  invisible(gc())
}

### Output paths ----
results$severity
results$burned
results$frequency
results$interval
results$carbon
results$deforestation

### Vídeos com todas as variáveis dinâmicas por área ----
multi_years <- 2017:2024
multi_ncol <- 3L
multi_map_side <- 600
multi_dpi <- 100
multi_pause <- 2L

multi_predictors <- c(
  list(land=list(files=land_files,title="Cobertura do solo",legend="Cobertura do solo",type="categorical",palette="Dark 3",labels=setNames(cols$class_name_pt_br,as.character(cols$class_id)),colours=setNames(cols$hex_code,as.character(cols$class_id)),multiplier=1)),
  predictors
)

multi_values <- function(v,cfg){
  v[!is.finite(v)] <- NA_real_
  if(cfg$type=="burned"){
    if(any(v<0,na.rm=TRUE))stop("Valores negativos em área queimada; confira a codificação.")
    v[!is.na(v)] <- as.numeric(v[!is.na(v)]>0)
  }
  v*cfg$multiplier
}

make_multi_videos <- function(areas=NULL){  
  stopifnot(length(overlays)==length(nomez),!anyDuplicated(nomez),length(multi_years)>0)
  # Seleção por índice ou nome; NULL seleciona todas.
  if(is.null(areas)){
    selected <- seq_along(nomez)
  }else if(is.character(areas)){
    selected <- match(areas,nomez)
    if(anyNA(selected))stop("Áreas não encontradas: ",paste(areas[is.na(selected)],collapse=", "))
  }else if(is.numeric(areas)){
    if(any(!is.finite(areas))||any(areas!=floor(areas))||any(areas<1|areas>length(nomez)))stop("Use índices inteiros entre 1 e ",length(nomez),".")
    selected <- as.integer(areas)
  }else{
    stop("'areas' deve conter índices ou nomes das áreas.")
  }
  
  selected <- unique(selected)
  if(!length(selected))stop("Selecione pelo menos uma área.")
  
  # Alterações locais: os objetos originais permanecem disponíveis.
  nomez <- nomez[selected]
  overlays <- overlays[selected]
  message("Áreas selecionadas: ",paste(nomez,collapse=", "))
  dir.create(output_dir,showWarnings=FALSE,recursive=TRUE)
  cache <- tempfile("multi_predictors_")
  dir.create(cache)
  on.exit(unlink(cache,recursive=TRUE),add=TRUE)
  
  display_crs <- sf::st_crs(buffer_crs)
  specs <- setNames(vector("list",length(multi_predictors)),names(multi_predictors))
  
  for(id in names(multi_predictors)){
    cfg <- multi_predictors[[id]]
    message("\nPreparando painéis: ",id)
    
    files <- cfg$files
    if(length(files))files <- files[extract_year(files)%in%multi_years]
    
    if(!length(files)){
      warning(id,": nenhum arquivo entre 2017 e 2024.")
      specs[[id]] <- list(cfg=cfg,crops=NULL,years=character(),crs=sf::st_crs(4326),classes=character(),limits=NULL,valid=FALSE)
      next
    }
    
    r <- read_annual(files)
    src_crs <- sf::st_crs(terra::crs(r))
    missing_years <- setdiff(as.character(multi_years),names(r))
    if(length(missing_years))warning(id,": anos sem arquivo: ",paste(missing_years,collapse=", "))
    
    cr <- lapply(seq_along(overlays),function(i){
      boundary <- terra::vect(sf::st_transform(overlays[[i]]$buffer,src_crs))
      terra::crop(r,boundary,mask=TRUE,filename=file.path(cache,paste0(id,"_",i,".tif")),overwrite=TRUE)
    })
    
    categorical <- cfg$type%in%c("categorical","burned")
    codes <- numeric()
    limits <- c(Inf,-Inf)
    valid <- FALSE
    
    for(i in seq_along(cr)){
      for(k in seq_len(terra::nlyr(cr[[i]]))){
        v <- multi_values(terra::values(cr[[i]][[k]],mat=FALSE),cfg)
        v <- v[is.finite(v)]
        if(!length(v))next
        valid <- TRUE
        if(categorical)codes <- union(codes,unique(v))
        else limits <- range(c(limits[is.finite(limits)],range(v)))
      }
    }
    
    classes <- as.character(sort(codes))
    if(!valid)limits <- NULL
    if(!categorical&&valid&&diff(limits)==0){
      padding <- max(abs(limits[1])*0.01,0.5)
      limits <- limits+c(-padding,padding)
    }
    
    if(categorical&&valid&&!is.null(cfg$colours)){
      missing_codes <- setdiff(classes,names(cfg$colours))
      if(length(missing_codes))stop(id,": cores ausentes para códigos ",paste(missing_codes,collapse=", "))
    }
    
    specs[[id]] <- list(cfg=cfg,crops=cr,years=names(r),crs=src_crs,classes=classes,limits=limits,valid=valid)
  }
  
  make_panel <- function(id,i,year){
    s <- specs[[id]]
    cfg <- s$cfg
    categorical <- cfg$type%in%c("categorical","burned")
    buffer <- sf::st_transform(overlays[[i]]$buffer,s$crs)
    bb <- sf::st_bbox(buffer)
    available <- as.character(year)%in%s$years
    has_pixels <- FALSE
    
    p <- ggplot2::ggplot()
    
    if(available){
      layer <- s$crops[[i]][[match(as.character(year),s$years)]]
      v <- multi_values(terra::values(layer,mat=FALSE),cfg)
      cells <- which(is.finite(v))
      has_pixels <- length(cells)>0
      
      if(has_pixels){
        xy <- terra::xyFromCell(layer,cells)
        d <- data.frame(x=xy[,1],y=xy[,2],value=v[cells])
      }else{
        d <- data.frame(x=numeric(),y=numeric(),value=numeric())
      }
      
      if(categorical)d$value <- factor(as.character(d$value),levels=s$classes)
      resolution <- terra::res(layer)
      p <- p+ggplot2::geom_tile(data=d,ggplot2::aes(x=x,y=y,fill=value),width=resolution[1],height=resolution[2])
    }
    
    if(!available&&s$valid){
      d <- data.frame(x=numeric(),y=numeric(),value=numeric())
      if(categorical)d$value <- factor(character(),levels=s$classes)
      p <- p+ggplot2::geom_tile(data=d,ggplot2::aes(x=x,y=y,fill=value))
    }
    if(s$valid)p <- p+make_scale(cfg,s$classes,s$limits)
    
    p <- p+
      ggplot2::geom_sf(data=sf::st_transform(overlays[[i]]$rivers,display_crs),colour="lightblue",fill=NA,linewidth=0.15,alpha=0.7)+
      ggplot2::geom_sf(data=sf::st_transform(overlays[[i]]$aoi,display_crs),colour="black",fill=NA,linewidth=0.4)+
      ggplot2::coord_sf(crs=display_crs,default_crs=s$crs,xlim=unname(bb[c("xmin","xmax")]),ylim=unname(bb[c("ymin","ymax")]),expand=FALSE)+
      ggspatial::annotation_scale(location="br",width_hint=0.25,text_cex=0.55)+
      ggplot2::labs(title=stringr::str_wrap(cfg$title,width=32))+
      ggplot2::theme_minimal(base_size=10)+
      ggplot2::theme(axis.title=ggplot2::element_blank(),axis.text=ggplot2::element_text(size=6),plot.title=ggplot2::element_text(face="bold",size=12,hjust=0.5),legend.position="right",legend.justification="top",legend.title=ggplot2::element_text(face="bold",size=9),legend.text=ggplot2::element_text(size=8),legend.key.height=grid::unit(0.35,"cm"),panel.grid.minor=ggplot2::element_blank(),plot.background=ggplot2::element_rect(fill="white",colour=NA))
    
    if(!has_pixels){
      text <- if(available)"Sem dados válidos"else"Sem arquivo para este ano"
      p <- p+ggplot2::annotate("label",x=mean(bb[c("xmin","xmax")]),y=mean(bb[c("ymin","ymax")]),label=text,size=3,fill="white")
    }
    p
  }
  
  outputs <- setNames(character(length(nomez)),nomez)
  ncols <- min(multi_ncol,length(specs))
  nrows <- ceiling(length(specs)/ncols)
  
  for(i in seq_along(nomez)){
    message("\nVídeo multipainel: ",nomez[i])
    
    # Dimensões adaptadas à proporção da área em coordenadas métricas.
    bb <- sf::st_bbox(sf::st_transform(overlays[[i]]$buffer,display_crs))
    ratio <- as.numeric((bb["xmax"]-bb["xmin"])/(bb["ymax"]-bb["ymin"]))
    if(!is.finite(ratio)||ratio<=0)stop("Extensão inválida: ",nomez[i])
    
    map_w <- if(ratio>=1)multi_map_side else multi_map_side*ratio
    map_h <- if(ratio>=1)multi_map_side/ratio else multi_map_side
    width_px <- 2*ceiling(ncols*(map_w+240)/2)
    height_px <- 2*ceiling((nrows*(map_h+120)+100)/2)
    
    frame_dir <- file.path(cache,paste0("frames_",i))
    dir.create(frame_dir)
    frames <- file.path(frame_dir,paste0("frame_",multi_years,".png"))
    
    for(j in seq_along(multi_years)){
      year <- multi_years[j]
      message("  Ano ",year," — ",j,"/",length(multi_years))
      panels <- lapply(names(specs),make_panel,i=i,year=year)
      
      # Preencher as posições restantes sem ampliar o último mapa.
      while(length(panels)<ncols*nrows)panels[[length(panels)+1L]] <- patchwork::plot_spacer()
      
      frame <- patchwork::wrap_plots(panels,ncol=ncols,nrow=nrows,guides="keep")+
        patchwork::plot_annotation(title=paste0(nomez[i]," | Ano: ",year),theme=ggplot2::theme(plot.title=ggplot2::element_text(face="bold",size=22,hjust=0.5),plot.background=ggplot2::element_rect(fill="white",colour=NA)))
      
      ggplot2::ggsave(filename=frames[j],plot=frame,width=width_px/multi_dpi,height=height_px/multi_dpi,units="in",dpi=multi_dpi,bg="white",limitsize=FALSE)
    }
    
    # Oito anos, um segundo por ano, mais a pausa no último quadro.
    sequence <- c(frames,rep(tail(frames,1),multi_pause))
    outputs[i] <- file.path(output_dir,paste0(safe_name(nomez[i]),"_todas_variaveis_2017_2024.mp4"))
    av::av_encode_video(input=sequence,output=outputs[i],framerate=1,codec="libx264",vfilter="format=yuv420p",verbose=TRUE)
    message("  Salvo: ",outputs[i])
    unlink(frame_dir,recursive=TRUE)
    invisible(gc())
  }
  
  outputs
}

### Executar e mostrar caminhos dos três vídeos ----
multi_predictors$land$colours["19"] <- "#C27BA0"
multi_predictors$land$labels["19"] <- "Lavoura temporária"

# Fazenda Cardoso e Área de Queimada
multi_videos <- make_multi_videos(areas=1:3)
multi_videos

# Static ----
## Elevation ----
elev_r = rast(elev_files)

## Hydrography ----
googledrive::drive_download(,path = "dataset/spatial/vector/hidro_gurupi.kml")
hidro = read_sf("dataset/spatial/vector/hidro_gurupi.kml")

## Soil granulometry ----
### Argila ----
clay_r = lapply(clay_files,rast)
clay_r = rast(clay_r)
names(clay_r) = str_extract(names(clay_r),"[0-9]+_[0-9]+")
clay_r = st_as_stars(clay_r)
clay_r = st_transform(clay_r, st_crs(AoI))

library(patchwork)

depth_labels <- function(x){
  limits <- strsplit(as.character(x),"_",fixed=TRUE)
  vapply(limits,function(z)sprintf("%02d - %02d cm",as.integer(z[1]),as.integer(z[2])),character(1))
}

location_names <- c("Fazenda Cardoso","Vila Bom Jesus","Área de Queimada")
stopifnot(length(location_names)==nrow(AoI))

clay_wrap <- st_warp(clay_r,crs=st_crs(AoI))
names(clay_wrap) <- "clay"
aoi_plot <- st_transform(AoI,st_crs(clay_wrap))
buffers <- st_buffer(aoi_plot,1000)
hidro_plot <- st_transform(hidro,st_crs(clay_wrap))

# Crop each location, preserving all depth bands.
clay_crops <- lapply(seq_len(nrow(aoi_plot)),function(i){
  st_crop(clay_wrap,buffers[i,])
})

# Shared colour limits across locations and depths.
clay_limits <- range(unlist(lapply(clay_crops,function(r){
  v <- as.numeric(r[[1]])
  range(v[is.finite(v)],na.rm=TRUE)
})),na.rm=TRUE)
if(any(!is.finite(clay_limits)))stop("No valid clay values in the selected areas.")

clay_rows <- lapply(seq_len(nrow(aoi_plot)),function(i){
  cropped_clay <- clay_crops[[i]]
  aoi_i <- aoi_plot[i,]
  buffer_i <- buffers[i,]
  bb <- st_bbox(buffer_i)
  rivers_i <- st_intersection(st_geometry(hidro_plot),st_geometry(buffer_i))
  
  ggplot()+
    geom_stars(data=cropped_clay,aes(fill=clay),downsample=0)+
    geom_sf(data=rivers_i,color="lightblue",alpha=0.7,linewidth=0.2)+
    geom_sf(data=aoi_i,fill=NA,color="black",linewidth=0.5)+
    coord_sf(crs=st_crs(clay_wrap),default_crs=st_crs(clay_wrap),xlim=unname(bb[c("xmin","xmax")]),ylim=unname(bb[c("ymin","ymax")]),expand=FALSE)+
    facet_wrap(~attributes,nrow=1,drop=FALSE,labeller=labeller(attributes=depth_labels))+
    scale_fill_viridis_c(name="Argila",limits=clay_limits,na.value="transparent")+
    annotation_scale(location="br",width_hint=0.3,text_cex=0.5)+
    annotation_north_arrow(location="tl",height=grid::unit(0.5,"cm"),width=grid::unit(0.5,"cm"))+
    labs(title=location_names[i])+
    theme_minimal()+
    theme(axis.title=element_blank(),legend.justification="top",legend.position="right",legend.background=element_rect(fill=NA,colour=NA),legend.title=element_text(face="bold",size=12),legend.text=element_text(size=10),axis.text=element_text(size=6),strip.text=element_text(face="bold",size=9),plot.title=element_text(face="bold",size=12),panel.grid.minor=element_blank())
})

clay_plot <- wrap_plots(clay_rows,ncol=1,guides="collect")&
  theme(legend.position="right")

clay_plot

ggsave("figures/grid_clay.tif",plot=clay_plot,width=20,height=9,units="in",dpi=300,compression="lzw")

### Silte ----
silt_r <- rast(lapply(silt_files,rast))
names(silt_r) <- str_extract(names(silt_r),"[0-9]+_[0-9]+")
silt_r <- st_as_stars(silt_r)
silt_wrap <- st_warp(silt_r,crs=st_crs(AoI))
names(silt_wrap) <- "silt"

aoi_plot <- st_transform(AoI,st_crs(silt_wrap))
buffers <- st_buffer(aoi_plot,1000)
hidro_plot <- st_transform(hidro,st_crs(silt_wrap))

silt_crops <- lapply(seq_len(nrow(aoi_plot)),function(i){
  st_crop(silt_wrap,buffers[i,])
})

silt_limits <- range(unlist(lapply(silt_crops,function(r){
  v <- as.numeric(r[[1]])
  v <- v[is.finite(v)]
  if(length(v))range(v)else NULL
})),na.rm=TRUE)
if(any(!is.finite(silt_limits)))stop("Sem valores válidos de silte nas áreas selecionadas.")

silt_rows <- lapply(seq_len(nrow(aoi_plot)),function(i){
  cropped_silt <- silt_crops[[i]]
  aoi_i <- aoi_plot[i,]
  buffer_i <- buffers[i,]
  bb <- st_bbox(buffer_i)
  rivers_i <- st_intersection(st_geometry(hidro_plot),st_geometry(buffer_i))
  
  ggplot()+
    geom_stars(data=cropped_silt,aes(fill=silt),downsample=0)+
    geom_sf(data=rivers_i,color="lightblue",alpha=0.7,linewidth=0.2)+
    geom_sf(data=aoi_i,fill=NA,color="black",linewidth=0.5)+
    coord_sf(crs=st_crs(silt_wrap),default_crs=st_crs(silt_wrap),xlim=unname(bb[c("xmin","xmax")]),ylim=unname(bb[c("ymin","ymax")]),expand=FALSE)+
    facet_wrap(~attributes,nrow=1,drop=FALSE,labeller=labeller(attributes=depth_labels))+
    scale_fill_viridis_c(name="Silte",limits=silt_limits,na.value="transparent")+
    annotation_scale(location="br",width_hint=0.3,text_cex=0.5)+
    annotation_north_arrow(location="tl",height=grid::unit(0.5,"cm"),width=grid::unit(0.5,"cm"))+
    labs(title=location_names[i])+
    theme_minimal()+
    theme(axis.title=element_blank(),legend.justification="top",legend.position="right",legend.background=element_rect(fill=NA,colour=NA),legend.title=element_text(face="bold",size=12),legend.text=element_text(size=10),axis.text=element_text(size=6),strip.text=element_text(face="bold",size=9),plot.title=element_text(face="bold",size=12),panel.grid.minor=element_blank())
})

silt_plot <- wrap_plots(silt_rows,ncol=1,guides="collect")&
  theme(legend.position="right")

ggsave("figures/grid_silt.tif",plot=silt_plot,width=20,height=9,units="in",dpi=300,compression="lzw")

### Areia ----
sand_r <- rast(lapply(sand_files,rast))
names(sand_r) <- str_extract(names(sand_r),"[0-9]+_[0-9]+")
sand_r <- st_as_stars(sand_r)
sand_wrap <- st_warp(sand_r,crs=st_crs(AoI))
names(sand_wrap) <- "sand"

aoi_plot <- st_transform(AoI,st_crs(sand_wrap))
buffers <- st_buffer(aoi_plot,1000)
hidro_plot <- st_transform(hidro,st_crs(sand_wrap))

sand_crops <- lapply(seq_len(nrow(aoi_plot)),function(i){
  st_crop(sand_wrap,buffers[i,])
})

sand_limits <- range(unlist(lapply(sand_crops,function(r){
  v <- as.numeric(r[[1]])
  v <- v[is.finite(v)]
  if(length(v))range(v)else NULL
})),na.rm=TRUE)
if(any(!is.finite(sand_limits)))stop("Sem valores válidos de areia nas áreas selecionadas.")

sand_rows <- lapply(seq_len(nrow(aoi_plot)),function(i){
  cropped_sand <- sand_crops[[i]]
  aoi_i <- aoi_plot[i,]
  buffer_i <- buffers[i,]
  bb <- st_bbox(buffer_i)
  rivers_i <- st_intersection(st_geometry(hidro_plot),st_geometry(buffer_i))
  
  ggplot()+
    geom_stars(data=cropped_sand,aes(fill=sand),downsample=0)+
    geom_sf(data=rivers_i,color="lightblue",alpha=0.7,linewidth=0.2)+
    geom_sf(data=aoi_i,fill=NA,color="black",linewidth=0.5)+
    coord_sf(crs=st_crs(sand_wrap),default_crs=st_crs(sand_wrap),xlim=unname(bb[c("xmin","xmax")]),ylim=unname(bb[c("ymin","ymax")]),expand=FALSE)+
    facet_wrap(~attributes,nrow=1,drop=FALSE,labeller=labeller(attributes=depth_labels))+
    scale_fill_viridis_c(name="Areia",limits=sand_limits,na.value="transparent")+
    annotation_scale(location="br",width_hint=0.3,text_cex=0.5)+
    annotation_north_arrow(location="tl",height=grid::unit(0.5,"cm"),width=grid::unit(0.5,"cm"))+
    labs(title=location_names[i])+
    theme_minimal()+
    theme(axis.title=element_blank(),legend.justification="top",legend.position="right",legend.background=element_rect(fill=NA,colour=NA),legend.title=element_text(face="bold",size=12),legend.text=element_text(size=10),axis.text=element_text(size=6),strip.text=element_text(face="bold",size=9),plot.title=element_text(face="bold",size=12),panel.grid.minor=element_blank())
})

sand_plot <- wrap_plots(sand_rows,ncol=1,guides="collect")&
  theme(legend.position="right")

ggsave("figures/grid_sand.tif",plot=sand_plot,width=20,height=9,units="in",dpi=300,compression="lzw")