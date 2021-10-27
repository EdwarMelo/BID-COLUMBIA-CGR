*Cleaning ubicación geográfica de entidades denunciadas
*Author: Marcia Ruiz   
*Last modified: September 11, 2020
*Inputs: Excel with codified willay inputs 
********************************************************************************

import excel "D:\Dropbox\PeruContraloria\Data\Denuncias\out\Manually Processed Willay Files\Consultants\Input_07sep2020.xlsx", sheet("Sheet1") firstrow  //cambiar con el path de su excel

rename DEPARTAMENTO dep 
rename PROVINCIA prov
rename DISTRITO dist

merge m:1 dep prov dist using  "$census/districts_census2017.dta", gen(merge_distr)  //cambiar path donde ubicarán la base del censo

br if merge_distr==1 //Verificar por qué no se hicieron merge (usualmente pasa por que hay typos en la escritura de las variables 
					 // -> las variables de ubicación geográfica de sus excels deben estar escritas tal cual están en la base del censo
					 // además de typos puede ser que hayan ubicado mal geográficamente a un distrito y hayan puesto que está en una provincia o departamento al que no pertenece
					 // si solo dice el nombre de la municipalidad, verificar en google donde se ubica para llenar correctamente el distrito y provincia
					 // el hecho de que una Gerencia Regional de un departamento X haya revisado la denuncia no significa necesariamente que la entidad denunciada pertenece a ese dpto
					 
*** Una vez identificadas las observaciones que no se han hecho merge, proceder con el cleaning:

/* Ejemplos:
replace DEPARTAMENTO = "Lima" if DEPARTAMENTO == "Lima, Callao"
replace PROVINCIA = "Huaraz" if DISTRITO == "Huanchay"
replace DISTRITO = "Huayana" if DISTRITO == "Huyana" & PROVINCIA == "Andahuaylas"
replace DISTRITO = "Anco-Huallo" if DISTRITO == "Huayo" & PROVINCIA == "Chincheros"
replace PROVINCIA = "Huamalies" if PROVINCIA == "Huamelies" & DEPARTAMENTO == "Huanuco" & DISTRITO == "Jircan" //ubicado mal geográficamente
replace PROVINCIA = "Pachitea" if PROVINCIA == "Huanuco" & DEPARTAMENTO == "Huanuco" & DISTRITO == "Pachitea" //ubicado mal geográficamente
replace DISTRITO = "Lurigancho" if  strpos(DISTRITO,"Chosica") 
replace DISTRITO = "Tirapata" if DISTRITO == "Tiripata" //typo
replace DISTRITO = "Tapairihua" if DISTRITO == "Tapayrihua" // synonyms
*/
