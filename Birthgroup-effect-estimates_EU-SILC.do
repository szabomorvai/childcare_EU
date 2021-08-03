********************
***reduced form estimates, i.e. effect of birthdate group on activity*****************************************************************************
********************************************************************************



*************************************************************************************************************************
* Anna könyvtárai
global source C:\Users\Toshiba\Dropbox\data\
global adatok C:\Users\Toshiba\Dropbox\data\

* Ági könyvtárai
*global adatok D:\Agi\EUSILC\Out
*global source D:\Agi\EUSILC\Out

****************************************************************************************************************************
***MOTHERS********

***no  birthquarter info for DE, IE, MT, NL, SI, UK!!!
foreach i in AT	BG	CH	CY	CZ	DK	EE	ES	FI	FR	GR HR	HU	IS	IT	LT	LU	LV	NO	PL	PT	RO	SE	SK {
*foreach i in AT HU IT CZ PL RO SK {
*foreach i in HU {

use "$source\mothers_graph_2005_2010.dta", clear
keep if country=="`i'"
qui tab year, gen(dyear)
qui tab int_qtr, gen(dint_qtr)
*tab country

***set age interval here
keep if kidage_qtr>2.9 & kidage_qtr<3.6
*keep if kidage_qtr==3 | kidage_qtr==3.25
*keep if kidage_qtr==3.5
*keep if (group_qtr==3 & int_qtr==1) | (group_qtr==4 & int_qtr==2 ) | (group_qtr==1 & int_qtr==3 )
*keep if kidage_R==3
drop if group_qtr==2

***set interview date
*keep if int_qtr<4
*keep if int_qtr==1 | int_qtr==2
*keep if int_qtr==1

keep mother_id year group* dyear* dint_qtr* kidage_*  emp* act* p_x_wght

*qui regress act_R group_qtr1 group_qtr2 group_qtr4 dyear* [pw=p_x_wght]
qui regress act_R group_qtr4 group_qtr1 dyear* [pw=p_x_wght]
*qui regress act_R group_qtr4 dyear* [pw=p_x_wght]
est store groupqtr_`i'
}

*est table groupqtr*, keep(group_qtr1 group_qtr2 group_qtr4) p b(%9.4f) stats(N adjusted r2 aic)
*est table groupqtr*, star b(%9.4f) stats(N adjusted r2 aic)
*est table groupqtr*, keep(group_qtr1 group_qtr2 group_qtr4 ) star b(%9.4f) stats(N adjusted r2 aic)
*est table groupqtr*, keep(group_qtr4 group_qtr1 ) p b(%9.4f) stats(N adjusted r2 aic)
est table groupqtr*, keep(group_qtr4 group_qtr1) star b(%9.4f) stats(N adjusted r2 aic)
xml_tab groupqtr*, save ("reduced_all_dec3_v2.xls") stats(N r2_a) replace below

est drop groupqtr*

*****************************************************************************************************************************************
