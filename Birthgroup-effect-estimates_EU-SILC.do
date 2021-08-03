***Where Can Childcare Expansion Increase Mothers’ Labor Force Participation? A Comparison of Quasi-Experimental Estimates from 7 Countries
*Agnes Szabo-Morvai* and Anna Lovasz**
*July 27, 2021



***reduced form estimates, i.e. effect of birthdate group on activity****************************************************************************
***MOTHERS********

***no  birthquarter info for DE, IE, MT, NL, SI, UK!!!
foreach i in AT	CZ	FR	GR HU	IT	SK {

use "$source\eusilc_mothers.dta", clear
keep if country=="`i'"
qui tab year, gen(dyear)
qui tab int_qtr, gen(dint_qtr)

***set age interval here
keep if kidage_qtr>2.9 & kidage_qtr<3.6
drop if group_qtr==2

keep mother_id year group* dyear* dint_qtr* kidage_*  emp* act* p_x_wght

qui regress act_R group_qtr4 group_qtr1 dyear* [pw=p_x_wght]
est store groupqtr_`i'
}

est table groupqtr*, keep(group_qtr4 group_qtr1) star b(%9.4f) stats(N adjusted r2 aic)
xml_tab groupqtr*, save ("reduced_all.xls") stats(N r2_a) replace below

est drop groupqtr*

*****************************************************************************************************************************************
