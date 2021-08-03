***EUROVI project - EU LFS - HU sample and activity graph replication
***may 2016, Anna & Ági


*Anna directory:
*cd "C:\Users\Anna\Dropbox (E3 - Lendület)\data"
*Ági directory:
cd "D:\Files\Adatok\LFS1983-2012_YC\panel\mothers"
global graphlib "C:\Users\szabo\OneDrive\Documents\Dropbox\Eurovi\Graphs"
set scheme s2color

***countries in sample:
/*
AT	40
CZ	203
EE	233
FR	250
GR	300
HU	348
IT	380
LV	428
LT	440
PL  616
PT	620
SK	703
*/

*foreach country in 40 203 233 250 300 348 380 428 440 616 620 703 {

use "D:\Files\Adatok\LFS1983-2012_YC\panel\mothers\EULFS_eurovi_pooled_final_agi.dta", clear
merge m:1 year country hhage14 using "D:\Files\Family_policy_data\Database_gen\institutions.dta", nogen

*keep if country==`country'

keep HHid country year hhage14 ecec wave hhseqnum wght refyear rem activ emp ftpt ilostat quarter hhage14 ///
cashben ecec kidage_qtr kidage_yr

*sample restrictions
keep if hhage14<8
keep if refyear>2004

foreach v of var * {															// save variable labels in locals
        local l`v' : variable label `v'
            if `"`l`v''"' == "" {
            local l`v' "`v'"
        }
}
collapse activ ecec cashben[aw =wght], by(hhage14 country)

foreach v of var * {															// attach saved labels to collapsed variables 
        label var `v' "`l`v''"
}

drop if hhage14 < 2

*Austria
foreach country in 40  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(2.5 3) recast(area) color(gs12) ||			///
	function y=1, range(2.5 2.51) lp(solid) lc(red)			||			///		this is invisible, only needed to label the vertical red line (constructed by xline(.) below)
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") legend(off)

graph save Graph "$graphlib\mothers_act_`country'.gph", replace
graph save Graph "$graphlib\mothers_act_`mylabel'.gph", replace

}

*CZ
foreach country in 203  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(2.8 3.3) recast(area) color(gs12) ||			///		AGE AT MEASUREMENT
	(pci 0 2.11 1 2.11)										||			///			PARENTAL LEAVE ENDS
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") legend(off)

graph save Graph "$graphlib\mothers_act_`country'.gph", replace
graph save Graph "$graphlib\mothers_act_`mylabel'.gph", replace

}

*FR
foreach country in 250  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(2.67 3.17) recast(area) color(gs12) ||			///		AGE AT MEASUREMENT
	function y=1, range(2.5 2.51) lp(solid) lc(red)			||			///		this is invisible, only needed to label the vertical red line (constructed by xline(.) below)
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") legend(off)

graph save Graph "$graphlib\mothers_act_`country'.gph", replace
graph save Graph "$graphlib\mothers_act_`mylabel'.gph", replace

}

*GR
foreach country in 300  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(3.5 4) recast(area) color(gs12) ||			///		AGE AT MEASUREMENT
	function y=1, range(2.5 2.51) lp(solid) lc(red)			||			///		this is invisible, only needed to label the vertical red line (constructed by xline(.) below)
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") legend(off)

graph save Graph "$graphlib\mothers_act_`country'.gph", replace
graph save Graph "$graphlib\mothers_act_`mylabel'.gph", replace

}

*HU
foreach country in 348  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(2.67 3.17) recast(area) color(gs12) ||		///		AGE AT MEASUREMENT
	(pci 0 3 1 3)										||			///			PARENTAL LEAVE ENDS
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") legend(off)

graph save Graph "$graphlib\mothers_act_`country'.gph", replace
graph save Graph "$graphlib\mothers_act_`mylabel'.gph", replace

}

*IT
foreach country in 380  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(3 3.5) recast(area) color(gs12) ||			///		AGE AT MEASUREMENT
	function y=1, range(3.5 3.51) lp(solid) lc(red)			||			///		this is invisible, only needed to label the vertical red line (constructed by xline(.) below)
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") legend(off)

graph save Graph "$graphlib\mothers_act_`country'.gph", replace
graph save Graph "$graphlib\mothers_act_`mylabel'.gph", replace

}

*SK
foreach country in 703  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(2.67 3.17) recast(area) color(gs12) ||			///		AGE AT MEASUREMENT
	(pci 0 3.15 1 3.15)										||			///			PARENTAL LEAVE ENDS
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") legend(off)

graph save Graph "$graphlib\mothers_act_`country'.gph", replace
graph save Graph "$graphlib\mothers_act_`mylabel'.gph", replace

}

* Legend
foreach country in 703  {
	local mylabel: label country `country'
	twoway 																///
	function y = 1, range(2.67 3.17) recast(area) color(gs12) ||			///		AGE AT MEASUREMENT
	(pci 0 3.15 1 3.15)										||			///			PARENTAL LEAVE ENDS
	(line activ hhage14, sort lc(gs0) lp(solid) lw(medium)) || 			///
	(line cashben hhage14, sort lc(gs0) lp(dash) lw(medium)) ||			///
	(line ecec hhage14, sort lc(gs0) lp(shortdash) lw(medium)) 			///
	if country == `country', 											/// 
	xlabel(0.5(0.5)8.0) xlabel(#6) 										///
	legend(order(1  "Age at measurement" 2 "Parental leave ends " 		///
	3 "LFP " 4 "Cash benefit / income "									///
	5 "Formal childcare enrollment (%)"))								///
	xtitle(Child age) 													///
	title("`mylabel'") 

graph save Graph "$graphlib\legend.gph", replace
graph export "$graphlib\legend.pdf", replace


}


cd $graphlib
gr combine mothers_act_40.gph mothers_act_203.gph mothers_act_250.gph ///
mothers_act_300.gph mothers_act_348.gph mothers_act_380.gph mothers_act_703.gph, ///
ycommon title("Maternal labor market return process") 
	graph export "$graphlib\return_all1.tif", replace width(1200)
	graph export "$graphlib\return_all1.pdf", replace







