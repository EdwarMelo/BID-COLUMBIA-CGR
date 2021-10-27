# CGR-DENUNCIAS
# Autor Ronny M. Condor
# Objetivo: Eliminar duplicados
library(dplyr)
library(readxl)
library(writexl)
library(DataEditR)
library(stringi)

setwd("G:/Mi unidad/Proyectos/CGR/Insumos")
entidades <- read_excel("ubicación.xlsx")
attach(entidades)
length(entidad)

entidades <- entidades[!duplicated(entidades$entidad), ]
length(entidades$entidad)

attach(entidades)
entidades$entidad <- toupper(stri_trans_general(entidad,"Latin-ASCII"))
entidades$departamento <- stri_trans_general(departamento,"Latin-ASCII")
entidades$provincia<- stri_trans_general(provincia,"Latin-ASCII")
entidades$distrito<- stri_trans_general(distrito,"Latin-ASCII")


write_xlsx(entidades,"output.xlsx")
