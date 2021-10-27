/*Creación de municipalidades distritales, provinciales y gobiernos regionales
con su ubicación geográfica
*Author: Ronny Condor   
*Last modified: September 22, 2020
*Inputs: Censo 
*******************************************************************************/

* Censo
global censo "G:\Mi unidad\Proyectos\CGR\Insumos\Censo"

* Generar municipalidad distrital
use "$censo/districts_census2017.dta", clear
tempfile ub_1
keep dep prov dist
label variable dep "departamento" 
label variable prov "provincia" 
label variable dist "distrito"
save "$censo/districts_census2017.dta", replace

gen muni="MUNICIPALIDAD DISTRITAL DE" 
gen tipo="Municipalidad Distrital"
egen entidad = concat(muni dist), punct(" ")
replace entidad= upper(entidad)
order entidad, first
order tipo, after(entidad)
drop muni
save `ub_1'

* Generar municipalidad provincial
use "$censo/districts_census2017.dta", clear
tempfile ub_2
drop dist
duplicates drop
gen muni="MUNICIPALIDAD PROVINCIAL DE"
gen tipo="Municipalidad Provincial"
egen entidad=concat(muni prov), punct(" ")
replace entidad= upper(entidad)
order entidad, first
order tipo, after(entidad)
drop muni
save `ub_2'

* Generar gobiernos regionales
use "$censo/districts_census2017.dta", clear
tempfile ub_3
drop dist prov
duplicates drop
gen gore="GOBIERNO REGIONAL"
gen tipo="Gobierno Regional"
egen entidad=concat(gore dep), punct(" ")
replace entidad= upper(entidad)
replace entidad="GOBIERNO REGIONAL DE LIMA" if entidad=="GOBIERNO REGIONAL LIMA"
order entidad, first
order tipo, after(entidad)
drop gore
save `ub_3'


* Append
append using `ub_2'
append using `ub_1'
compress
sort dep prov dist

rename dep departamento
rename prov provincia
rename dist distrito


* Output
save "$censo\censo.dta", replace
export excel using "$censo\censo.xlsx", sheetmodify firstrow(varlabels) 




/*
* Grupo 12 (14 de setiembre del 2020)
import excel "G:\Mi unidad\Proyectos\CGR\Grupo 12\2020-09-14_1.xlsx", sheet("Sheet1") firstrow case(lower) clear

rename departamento dep 
rename provincia prov
rename distrito dist
keep expediente dep prov dist 

replace prov="Lima" if prov=="Lima Metropolitana"
replace dist="Lima" if dist=="Cercado de Lima"
replace prov = "Huaraz" if dist == "Huanchay"
replace dist = "Huayana" if dist == "Huyana" & prov == "Andahuaylas"
replace dist = "Anco-Huallo" if dist == "Huayo" & prov == "Chincheros"
replace prov = "Huamalies" if prov == "Huamelies" & dep == "Huanuco" & dist == "Jircan" //ubicado mal geográficamente
replace prov = "Pachitea" if prov == "Huanuco" & dep == "Huanuco" & dist == "Pachitea" //ubicado mal geográficamente
replace dist = "Lurigancho" if  strpos(dist,"Chosica") 
replace dist = "Tirapata" if dist == "Tiripata" //typo
replace dist= "Tapairihua" if dist == "Tapayrihua" // synonyms

merge m:1 dep prov dist using  "$censo/districts_census2017.dta", gen(merge_distr)  
keep expediente dep prov dist merge_distr

codebook merge_distr

br if merge_distr==1 & dist!="" 

* Cleaning
replace prov="Lima" if expediente=="08201338173"
replace prov="Callao" if prov=="Calllao"
replace prov="Nasca" if prov=="Nazca"
replace dep="Callao" if prov=="Callao" */
