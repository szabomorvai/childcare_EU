*Anna directory:
cd "C:\Users\Anna\Dropbox (E3 - Lendület)\Eurovi\Data_and_info\mothers"
*global root "C:\Users\Anna\Dropbox (E3 - Lendület)\Eurovi\Data_and_info\mothers"

*Ági directory:
*cd "C:\Users\szabo\OneDrive\Documents\LFS1983-2012_YC\panel\mothers"
*global root "C:\Users\szabo\OneDrive\Documents\LFS1983-2012_YC\panel\eulfs_panel"



global control2 isced* mst* age
*global control3 $control2 age_sq hhnbchld hhnb0014 hhnbch2 hhnbch5 hhnbch8 hhnbch11 hhnbch14 hhnbch17 hhnbch24 hhnbinac
*global control3 $control2 age_sq hhnbchld hhnbinac
global control3 $control2 age_sq
global control4 $control3 yr*  
global control5 $control4 dregion* 


***country-specific final dataset prep*****************************************************************************************************
use "EULFS_eurovi_pooled_final_Anna.dta", clear

********* SAMPLE RESTRICTIONS***************************************************
* keep only mothers, females, with child under 6 and over 2,  those who were born in that very country (because of beliefs, values)
* Those of age 20-50
keep if  sex == 2 & hhage14 < 6 & hhage14 >= 2 ///
& age >= 22 &age <= 52
keep if refyear>2004


***COUNTRY_SPECIFIC cutoffs and samples
***set CUTOFFS here!
gen T=.
replace T=Tjan if country==203
replace T=Tmar if country==250 | country==348 | country==703
replace T=Tmay if country==40 | country==620 | country==300
replace T=Tsep if country==616 | country==705
replace T=Tit if country==380


gen sampleq1b=.
replace sampleq1b=1 if ((T==1 & obsq1T==1) | (T==0 & obsq1C==1)) &  ((Tjan!=. & sample_age_Tjan_q1==1) | (Tmar!=. & sample_age_Tmar_q1==1) | (Tmay!=. & (country!=300) & sample_age_Tmay_q1==1) | (Tmay!=. & (country==300) & sample_age_TmayP_q1==1) |  (Tsep!=. & sample_age_Tsep_q1==1) | (Tit!=. & sample_age_Tit_q1==1))

gen sampleq4b=.
replace sampleq4b=1 if ((T==1 & obsq4T==1) | (T==0 & obsq4C==1)) &  ((Tjan!=. & sample_age_Tjan_q4==1) | (Tmar!=. & sample_age_Tmar_q4==1) | (Tmay!=. & (country!=300) & sample_age_Tmay_q4==1) | (Tmay!=. & (country==300) & sample_age_TmayP_q4==1) | (Tsep!=. & sample_age_Tsep_q4==1) | (Tit!=. & sample_age_Tit_q4==1))

gen sampleq1S=sampleq1b
replace sampleq1S=1 if ((T==1 & obsq1T==1) | (T==0 & obsq1C==1)) & sample_comp==1

gen sampleq4S=sampleq4b
replace sampleq4S=1 if ((T==1 & obsq4T==1) | (T==0 & obsq4C==1)) & sample_comp==1

keep if sampleq4S==1 | sampleq1S==1

gen m=0
replace m=1 if sample_comp!=1
gen mT=m*T

save "EULFS_eurovi_pooled_regsJun2017.dta", replace


***REGS******************************************************************************************************************************
********************************************************************************
*****************************************************************************************************************
use "EULFS_eurovi_pooled_regsJun2017.dta", clear

rename activ activ_real
gen activ=0
*replace activ=1 if avaireas==4
replace activ=1 if seekreas==3

foreach country in 40 203 250 300 348 380 616 620 703 705 {
*baseline q4
tab country if country==`country'
qui regress activ T  [pw=wght] if country==`country' & sampleq4b==1
est store TBq4`country'
qui regress activ T $control5 [pw=wght] if country==`country' & sampleq4b==1
est store TBq4c`country'
*baseline q1
tab country if country==`country'
qui regress activ T  [pw=wght] if country==`country' & sampleq1b==1
est store TBq1`country'
qui regress activ T $control5 [pw=wght] if country==`country' & sampleq1b==1
est store TBq1c`country'

*season corr q4
tab country if country==`country'
qui regress activ T m mT [pw=wght] if country==`country' & sampleq4S==1
est store TSq4`country'
qui regress activ T m mT $control5 [pw=wght] if country==`country' & sampleq4S==1
est store TSq4c`country'
*season corr q1
tab country if country==`country'
qui regress activ T m mT  [pw=wght] if country==`country' & sampleq1S==1
est store TSq1`country'
qui regress activ T m mT $control5 [pw=wght] if country==`country' & sampleq1S==1
est store TSq1c`country'

}
est table T*, keep(T m mT) stats(N r2) p 

outreg2 T [T*] using "C:\Users\Anna\Dropbox (E3 - Lendület)\Eurovi\Results\Reasons_EULFS_10jun2017" , excel replace keep(T m mT) stats(coef pval) alpha(0.01, 0.05, 0.1)

est drop T*
