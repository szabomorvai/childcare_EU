***Where Can Childcare Expansion Increase Mothers’ Labor Force Participation? A Comparison of Quasi-Experimental Estimates from 7 Countries
*Agnes Szabo-Morvai* and Anna Lovasz**
*July 27, 2021


cd "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\work"
global root "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\eulfs_panel"
global mothers "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\mothers"
global results "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\results"


global control2 isced* mst* age
global control3 $control2 age_sq
global control4 $control3 yr*  
global control5 $control4 dregion* 


***country-specific final dataset prep*****************************************************************************************************
use "$mothers\EULFS_eurovi_pooled_final.dta", clear

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
replace T=Tmar if country==250 | country==703
replace T=Tmay if country==40 | country==620 | country==300
replace T=Tsep if country==616 | country==705 | country==724
replace T=Tit if country==380
replace T=Thu if country==348

* Samples for baseline regressions

gen sampleq0b=.
replace sampleq0b=1 if ((T==1 & obsq0T==1) | (T==0 & obsq0C==1)) &  ((Tjan!=. & sample_age_Tjan_q0==1) | (Tmar!=. & sample_age_Tmar_q0==1) | (Tmay!=. & (country!=300) & sample_age_Tmay_q0==1) | (Tmay!=. & (country==300) & sample_age_TmayP_q0==1) | (Tsep!=. & sample_age_Tsep_q0==1) | (Tit!=. & sample_age_Tit_q0==1) | (Thu!=. & sample_age_Thu_q0==1) )

gen sampleq1b=.
replace sampleq1b=1 if ((T==1 & obsq1T==1) | (T==0 & obsq1C==1)) &  ((Tjan!=. & sample_age_Tjan_q1==1) | (Tmar!=. & sample_age_Tmar_q1==1) | (Tmay!=. & (country!=300) & sample_age_Tmay_q1==1) | (Tmay!=. & (country==300) & sample_age_TmayP_q1==1) |  (Tsep!=. & sample_age_Tsep_q1==1) | (Tit!=. & sample_age_Tit_q1==1) | (Thu!=. & sample_age_Thu_q1==1)  )

gen sampleq2b=.
replace sampleq2b=1 if ((T==1 & obsq2T==1) | (T==0 & obsq2C==1)) &  ((Tjan!=. & sample_age_Tjan_q2==1) | (Tmar!=. & sample_age_Tmar_q2==1) | (Tmay!=. & (country!=300) & sample_age_Tmay_q2==1) | (Tmay!=. & (country==300) & sample_age_TmayP_q2==1) |  (Tsep!=. & sample_age_Tsep_q2==1) | (Tit!=. & sample_age_Tit_q2==1) | (Thu!=. & sample_age_Thu_q2==1)  )

gen sampleq3b=.
replace sampleq3b=1 if ((T==1 & obsq3T==1) | (T==0 & obsq3C==1)) &  ((Tjan!=. & sample_age_Tjan_q3==1) | (Tmar!=. & sample_age_Tmar_q3==1) | (Tmay!=. & (country!=300) & sample_age_Tmay_q3==1) | (Tmay!=. & (country==300) & sample_age_TmayP_q3==1) | (Tsep!=. & sample_age_Tsep_q3==1) | (Tit!=. & sample_age_Tit_q3==1) | (Thu!=. & sample_age_Thu_q3==1) )

gen sampleq4b=.
replace sampleq4b=1 if ((T==1 & obsq4T==1) | (T==0 & obsq4C==1)) &  ((Tjan!=. & sample_age_Tjan_q4==1) | (Tmar!=. & sample_age_Tmar_q4==1) | (Tmay!=. & (country!=300) & sample_age_Tmay_q4==1) | (Tmay!=. & (country==300) & sample_age_TmayP_q4==1) | (Tsep!=. & sample_age_Tsep_q4==1) | (Tit!=. & sample_age_Tit_q4==1) | (Thu!=. & sample_age_Thu_q4==1) )

* Samples for seasonally corrected regressions

gen sampleq0S=sampleq0b
replace sampleq0S=1 if ((T==1 & obsq0T==1) | (T==0 & obsq0C==1)) & sample_comp==1

gen sampleq1S=sampleq1b
replace sampleq1S=1 if ((T==1 & obsq1T==1) | (T==0 & obsq1C==1)) & sample_comp==1

gen sampleq2S=sampleq2b
replace sampleq2S=1 if ((T==1 & obsq2T==1) | (T==0 & obsq2C==1)) & sample_comp==1

gen sampleq3S=sampleq3b
replace sampleq3S=1 if ((T==1 & obsq3T==1) | (T==0 & obsq3C==1)) & sample_comp==1

gen sampleq4S=sampleq4b
replace sampleq4S=1 if ((T==1 & obsq4T==1) | (T==0 & obsq4C==1)) & sample_comp==1


*keep if sampleq4S==1 | sampleq1S==1
keep if sampleq4S==1 | sampleq1S==1 | sampleq2S==1 | sampleq3S==1 | sampleq0S==1

gen m=0
replace m=1 if sample_comp!=1
gen mT=m*T

save "$mothers\EULFS_eurovi_pooled_regs.dta", replace


***REGS******************************************************************************************************************************
********************************************************************************
*****************************************************************************************************************
use "$mothers\EULFS_eurovi_pooled_regs.dta", clear

foreach country in 40 203 250 300 348 380 703 {
*foreach country in 724 {

tab country if country==`country'
*baseline q4
qui regress activ T $control5 [pw=wght] if country==`country' & sampleq4b==1
est store TBq4`country'
*baseline q1
qui regress activ T $control5 [pw=wght] if country==`country' & sampleq1b==1
est store TBq1`country'
*baseline q2
qui regress activ T $control5 [pw=wght] if country==`country' & sampleq2b==1
est store TBq2`country'
*baseline q3
qui regress activ T $control5 [pw=wght] if country==`country' & sampleq3b==1
est store TBq3`country'


*season corr q0: placebo - measured before enrolment
qui regress activ T m mT $control5 [pw=wght] if country==`country' & sampleq0S==1
est store TSq0`country'
*season corr q4: measured in Q4, 1 quarter after enrolment
qui regress activ T m mT $control5 [pw=wght] if country==`country' & sampleq4S==1
est store TSq4`country'
*season corr q1: measured in Q1, 2 quarters after enrolment
qui regress activ T m mT $control5 [pw=wght] if country==`country' & sampleq1S==1
est store TSq1`country'
*season corr q2: measured in Q2, 3 quarters after enrolment
qui regress activ T m mT $control5 [pw=wght] if country==`country' & sampleq2S==1
est store TSq2`country'
*season corr q3: measured in Q3, 4 quarters after enrolment
qui regress activ T m mT $control5 [pw=wght] if country==`country' & sampleq3S==1
est store TSq3`country'
}
est table T*, keep(T m mT) stats(N r2) p 

outreg2 T [T*] using "C:\Users\Anna\Dropbox (E3 - Lendület)\Eurovi\Results\regs_LRv2_ci_29jun2017" , excel replace keep(T m mT) ci
outreg2 T [T*] using "C:\Users\Anna\Dropbox (E3 - Lendület)\Eurovi\Results\regs_LRv2_29jun2017" , excel replace keep(T m mT) stats(coef pval) alpha(0.01, 0.05, 0.1)

est drop T*
