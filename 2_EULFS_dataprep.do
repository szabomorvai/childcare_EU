***Where Can Childcare Expansion Increase Mothers’ Labor Force Participation? A Comparison of Quasi-Experimental Estimates from 7 Countries
*Agnes Szabo-Morvai* and Anna Lovasz**
*July 27, 2021

cd "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\work"
global root "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\eulfs_panel"
global mothers "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\mothers"
global country at cz fr gr hu it sk 

***birth month*********************************************************

foreach country in $country {
use "$root\eulfs_`country'_panel.dta", clear
sort panelid refyear refweek
keep panelid year hhseqnum hhage14 quarter wave rem 
drop if panelid == . 
drop if hhage14==.
* How many people are there in the household
bysort panelid wave: egen hh_obs=max(hhseqnum)
*keep as HH level data:
drop hhseqnum
* Keep only one observation of each household
duplicates drop
sort panelid wave
by panelid: gen obs_qtrnum = _n
*no of qtrs observed:
bysort panelid: egen qtrs_obs = max(obs_qtrnum)
tsset panelid obs_qtrnum
gen laghhage14=L.hhage14
*mark when age changes within HH observed qtrs:
gen age_switch=0
replace age_switch=1 if hhage14==laghhage14+1 & laghhage14!=.
bysort panelid: egen sumswitch=sum(age_switch)
gen birth_month_yst=.
*if observe change, use reference month as birthmonth
replace birth_month_yst=rem if age_switch==1
* Check if switch occcurs at the same time if it occurs more than once
bysort panelid: egen temp_birth_mo_yst_min=min(birth_month_yst)
bysort panelid: egen temp_birth_mo_yst_max=max(birth_month_yst)
* If min and max are not equal, this means that the age switches in different quarters, we'll have to ignore these observations. 
gen temp_birth_mo_ok = 0 
	replace temp_birth_mo_ok = 1 if  temp_birth_mo_yst_max == temp_birth_mo_yst_min
* Ignore those households where the switch occurs in two different months
	replace birth_month_yst = . if temp_birth_mo_ok == 0
drop temp*
*if no switch, but observed for 4 qtrs, assume first month observed is birthmonth
replace birth_month_yst= rem if qtrs_obs==4 & obs_qtrnum == 1 & sumswitch==0
sort panelid wave
keep panelid wave birth_month_yst hh_obs qtrs_obs
rename hh_obs hh_ind_obs
rename qtrs_obs hh_qtrs_obs
sort panelid wave
drop if birth_month_yst == . 
duplicates drop panelid, force
save "EULFS_birth_months_`country'.dta", replace

***merge back into main dataset***************************************************************************************************

use "$root\eulfs_`country'_panel.dta", clear
sort panelid wave
merge panelid using "EULFS_birth_months_`country'.dta"
keep if _merge==3
drop _merge
save "eulfs_eurovi_`country'.dta", replace

***match to actual mothers, based on mother id codes*************************************************************

*use "eulfs_eurovi_`country'.dta", clear
keep panelid hhseqnum hhmoth age year quarter hhage14 wave rem hh_qtrs_obs birth_mo*
bysort panelid wave: egen minage=min(age)
keep if age==minage
keep panelid hhmoth wave age minage hhage14
order panelid wave
*drop if no mother info
drop if hhmoth==0
duplicates drop 
*mark if two children are youngest of same age with different mothers
duplicates tag panelid wave, gen(dupl)
tab dupl
sort dupl panelid wave
*drop these
drop if dupl!=0
drop dupl
*save mother id codes for mothers who have the youngest child in the HH
keep panelid wave hhmoth
gen mother=1
sort panelid wave hhmoth
rename hhmoth hhseqnum
save "EULFS_mother_ids_`country'.dta", replace
*merge these and keep only actual mothers based on mother id codes
use "eulfs_eurovi_`country'.dta", clear
sort panelid wave hhseqnum
merge panelid wave hhseqnum using "EULFS_mother_ids_`country'.dta"
tab _merge
*only keep mothers of the youngest child, based on mother code variable, in each HH 
keep if _merge==3
drop _merge
order panelid wave hhseqnum
sort panelid wave hhseqnum
* Keep females of age 15 to 60 born in the country 
drop if sex == 1 | age < 15 | age > 60 | countryb != 0
drop hhnum_yr_wk newid hh_ind_obs hh_qtrs_obs  mother
save "eulfs_eurovi_`country'.dta", replace
***make final mother dataset**********************************************************************************

keep panelid wave hhnum hhseqnum coeff refyear refweek intweek country region rem year hhlink sex age marstat ///
national yearesid countryb wstator stapro countryw ystartwk mstartwk ftpt ftptreas temp tempreas tempdur ///
hwusual hwactual hourreas hwwish homewk exist2j hwactua2 stapro2j yearpr monthpr leavreas stapropr iscopr3d_08 ///
wantwork availble avaireas preseek mainstat  educfild courfild hatlevel hatfield hatyear wstat1y ///
na111y1d ilostat na111d na11s isco1d_08 na112j1d na112js na11pr1d na11prs iscopr1d_08 hatlev1d startime leavtime ///
quarter hhchildr hhpartnr hhnbchld hhnb0014 hhnbch2 hhnbch5 hhnbch8 hhnbch11 hhnbch14 hhnbch17 hhnbch24 hhnbpers ///
hhnbempl hhnbinac hhnbunem hhnbwork hhageyg hhage14 hhnbold hhpers ///
birth_month_yst   seekreas needcare hatlfath hatlmoth 

order panelid wave hhseqnum coeff refyear refweek intweek quarter birth_month_yst
gen activ=.
	replace activ=1 if ilostat==1 | ilostat==2
	replace activ=0 if ilostat==3
gen emp=0
	replace emp=1 if ilostat==1
save "eulfs_eurovi_`country'.dta", replace
}


***make merged mothers' panel dataset of all sample countries******************************************************************
use "eulfs_eurovi_at.dta", clear

foreach country in cz fr gr hu it sk  {
append using "eulfs_eurovi_`country'.dta", force
}

gen HHid=panelid
lab var activ "LFP"
save "EULFS_eurovi_pooled_orig.dta", replace
rename birth_month_yst birth_mo_yst

*quarter of birth
gen birth_qtr=.
replace birth_qtr=1 if (birth_mo_yst==1 | birth_mo_yst==2 | birth_mo_yst==3)
replace birth_qtr=2 if (birth_mo_yst==4 | birth_mo_yst==5 | birth_mo_yst==6)
replace birth_qtr=3 if (birth_mo_yst==7 | birth_mo_yst==8 | birth_mo_yst==9)
replace birth_qtr=4 if (birth_mo_yst==10 | birth_mo_yst==11 | birth_mo_yst==12)

***kidage_qtr**************
gen kidage_inqtr=hhage14*4 if birth_qtr==quarter
	replace kidage_inqtr=hhage14*4+quarter-birth_qtr if quarter>birth_qtr
	replace kidage_inqtr=hhage14*4+(4-birth_qtr)+quarter if quarter<birth_qtr
gen kidage_qtr=kidage_inqtr/4


***control variables

gen wklastweek = 0
	replace wklastweek = 1 if wstator == 1
rename coeff wght
tab marstat, gen(dmarstat)
	rename dmarstat1 mst_wid
	rename dmarstat2 mst_sin
	rename dmarstat3 mst_mar
tab refyear, gen(dyear)
	rename dyear1 yr_2005
	rename dyear2 yr_2006
	rename dyear3 yr_2007
	rename dyear4 yr_2008
	rename dyear5 yr_2009
	rename dyear6 yr_2010
	rename dyear7 yr_2011
	rename dyear8 yr_2012
tab country, gen(dcountry)
* dregion is not good, as two regons from different coutries may have the same region number.
gen ctr_region=country*1000+region 
tab ctr_region, gen(dregion)
* educ level 
tab hatlev1d, gen(deduc)
	rename deduc1 isced2
	rename deduc2 isced3
	rename deduc3 isced4
save "$mothers\EULFS_eurovi_pooled_orig.dta", replace
