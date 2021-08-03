***Where Can Childcare Expansion Increase Mothers’ Labor Force Participation? A Comparison of Quasi-Experimental Estimates from 7 Countries
*Agnes Szabo-Morvai* and Anna Lovasz**
*July 27, 2021

*KTI server 
* EU-LFS data Hungary. Similar codes run on all other countries

cd "/home/szabomorvaia/EULFS/pairs"
global root "/home/szabomorvaia/EULFS/data"
global pairs "/home/szabomorvaia/EULFS/pairs"

global country hu
local country hu
use "$root/eulfs_`country'_y.dta", clear
set more off, perm

* newid: a new HH id for each household, which differs also for the same household observed on a different date
gen double hhnum_yr_wk = hhnum * 1000000 + refyear * 100 + refweek
sort wave hhnum
egen newid =  group(hhnum_yr_wk) 
save temp_eulfs_`country'_panel, replace
gen wave_num = wave
keep if wave_num >= 180
keep wave_num newid hhnum_yr_wk intwave year intweek hhseqnum region hhspou hhfath hhmoth sex age ///
marstat national hatlev1d hatfield hatyear hhnbchld ///
hhnb0014 hhage14 hhageyg hhnbold hhnbch2 hhnbch5 hhnbch8 hhnbch11 hhnbch14 ///
hhnbch17 hhnbch24
order wave_num newid hhnum_yr_wk intwave year intweek  , first
egen hh_size = max(hhseqnum), by(newid)
egen hh_age = sum(age), by(newid)
*Education level, field and year of person n in the HH
forval n = 1/15 {
	gen temp_educ_p`n' = hatlev1d if hhseqnum == `n'
	egen educ_p`n' = max(temp_educ_p`n'), by(newid)
	gen temp_field_p`n' = hatfield if hhseqnum == `n'
	egen field_p`n' = max(temp_field_p`n'), by(newid)
	gen temp_edyear_p`n' = hatyear if hhseqnum == `n'
	egen edyear_p`n' = max(temp_edyear_p`n'), by(newid)
	drop temp*
}

*Marital status of person n in the HH
forval n = 1/3 {
	gen temp_marstat_p`n' = marstat if hhseqnum == `n'
	egen marstat_p`n' = max(temp_marstat_p`n'), by(newid)
	drop temp*
}

duplicates drop newid, force
drop if hhnb0014 == 0
gen pair = 0 
gen hits = 0 
save panel_$country, replace

************************************************************************************************************

use panel_$country, clear
set more off
gsort - intwave
forval obs = 35756 / 202000 {

* Household variables
* Size: # of persons. Merge: no change
local local_hh_size=hh_size[`obs']
gen hh_size_ok = 0 
	replace hh_size_ok = 1 if hh_size == `local_hh_size' 

* Age: Sum of the age of the household members. Merge: at most half of the members switch between age categories.
local local_hh_age=hh_age[`obs']
gen hh_age_ok = 0 
	 replace hh_age_ok = 1 if (hh_age == `local_hh_age' | hh_age == `local_hh_age' + 5) 

* Wave: the next should be larger by 1
local local_wave=wave_num[`obs']
gen wave_ok = 0 
	 replace wave_ok = 1 if wave_num == `local_wave' + 1 

*Education level, field and year of person n in the HH
foreach var in educ field edyear { 
	forval n = 1/15 {
		local local_`var'_p`n'=`var'_p`n'[`obs']
		gen `var'_p`n'_ok = 0 
			 replace `var'_p`n'_ok = 1 if `var'_p`n' == `local_`var'_p`n'' 
	}
}

*Marital status of person n in the HH
forval n = 1/3 {
	local local_marstat_p`n'= marstat_p`n'[`obs']
	gen marstat_p`n'_ok = 0 
		 replace marstat_p`n'_ok = 1 if marstat_p`n' == `local_marstat_p`n'' 
}

* Number of children under age `num'
foreach num of numlist 2 5 8 11 14 17 24 {
	local local_hhnbch`num'=hhnbch`num'[`obs']
	gen hhnbch`num'_ok = 0 
		 replace hhnbch`num'_ok = 1 if (hhnbch`num' == `local_hhnbch`num'' | ///
		hhnbch`num' == `local_hhnbch`num'' + 1 | hhnbch`num' == `local_hhnbch`num'' - 1 ) 
}

* Age of the youngest child
local local_hhageyg=hhageyg[`obs']
gen hhageyg_ok = 0 
	 replace hhageyg_ok = 1 if (hhageyg == `local_hhageyg' | ///
	hhageyg == `local_hhageyg' + 1 | hhageyg == 0) 

	* Region

local local_region=region[`obs']
gen region_ok = 0 
	 replace region_ok = 1 if region == `local_region'

* Sequence number of father
local local_hhfath=hhfath[`obs']
gen hhfath_ok = 0 
	 replace hhfath_ok = 1 if hhfath == `local_hhfath' 

* Sequence number of mother
local local_hhmoth=hhmoth[`obs']
gen hhmoth_ok = 0 
	 replace hhmoth_ok = 1 if hhmoth == `local_hhmoth' 
gen ok = (hh_size_ok + hh_age_ok +  /// 2
educ_p3_ok + educ_p4_ok + educ_p5_ok + educ_p6_ok + educ_p7_ok + educ_p8_ok + /// 6
educ_p9_ok + educ_p10_ok + educ_p11_ok + educ_p12_ok + educ_p13_ok + educ_p14_ok + /// 6
educ_p15_ok + field_p3_ok + field_p4_ok + field_p5_ok + /// 4
field_p6_ok + field_p7_ok + field_p8_ok + field_p9_ok + field_p10_ok + field_p11_ok + /// 6
field_p12_ok + field_p13_ok + field_p14_ok + field_p15_ok +  /// 4
edyear_p3_ok + edyear_p4_ok + edyear_p5_ok + edyear_p6_ok + edyear_p7_ok + edyear_p8_ok + /// 6
edyear_p9_ok + edyear_p10_ok + edyear_p11_ok + edyear_p12_ok + edyear_p13_ok + edyear_p14_ok + /// 6
edyear_p15_ok + hhnbch2_ok + hhnbch5_ok + hhnbch8_ok + hhnbch11_ok + hhnbch14_ok + /// 6
hhnbch17_ok + hhnbch24_ok + hhageyg_ok + marstat_p1_ok + marstat_p2_ok + /// 5
marstat_p3_ok + hhfath_ok + hhmoth_ok + field_p1_ok + field_p2_ok ) *intwave_ok * wave_ok * region_ok * edyear_p1_ok * /// 5
educ_p1_ok * educ_p2_ok * edyear_p2_ok // 

local local_newid = newid[`obs']

disp "******************************"

disp "Obs: `obs' "

disp "******************************"

egen maxok = max(ok) // if (region == `reg') & (intwave == `iw'+1 )& (wave_num == `w'+1)

replace hits = ok if ok== maxok & maxok > hits & ok != 0 & maxok != . 

replace pair = `local_newid' if hits == ok & ok != 0 & maxok != . 

drop *ok

}

save "$pairs/panel_pairs_$country", replace