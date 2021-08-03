***Where Can Childcare Expansion Increase Mothers’ Labor Force Participation? A Comparison of Quasi-Experimental Estimates from 7 Countries
*Agnes Szabo-Morvai* and Anna Lovasz**
*July 27, 2021


cd "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\work"
global root "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\eulfs_panel"
global mothers "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\mothers"

use "$mothers\EULFS_eurovi_pooled_orig.dta", clear 
drop intweek hhlink yearesid mstartwk tempreas tempdur stapro2j monthpr needcare educfild courfild hatfield na111y1d na111d na112j1d na112js na11pr1d na11prs

*sample restrictions
keep if hhage14<10
keep if refyear>2004

	
* Gen T, obs dates, kid ages for every specification for each country
* 1. gen Ts based on birth month (5 month windows). Always leave out the 1st and 2nd month of imputed birth after the cutoff to avoid putting treatment mothers in the control group

*jan cutoff
gen Tjan=.
replace Tjan=0 if (birth_mo_yst==3 | birth_mo_yst==4 | birth_mo_yst==5)
replace Tjan=1 if (birth_mo_yst==10 | birth_mo_yst==11 | birth_mo_yst==12)

*march cutoff
gen Tmar=.
replace Tmar=0 if (birth_mo_yst==5 | birth_mo_yst==6 | birth_mo_yst==7)
replace Tmar=1 if (birth_mo_yst==12 | birth_mo_yst==1 | birth_mo_yst==2)

*may cutoff
gen Tmay=.
replace Tmay=0 if (birth_mo_yst==7 | birth_mo_yst==8 | birth_mo_yst==9)
replace Tmay=1 if (birth_mo_yst==2 | birth_mo_yst==3 | birth_mo_yst==4)

*sept cutoff
gen Tsep=.
replace Tsep=0 if (birth_mo_yst==11 | birth_mo_yst==12 | birth_mo_yst==1)
replace Tsep=1 if (birth_mo_yst==6 | birth_mo_yst==7 | birth_mo_yst==8)

*Italy changing cutoff: may until 2006, then sept
gen Tit=.
replace Tit=0 if (birth_mo_yst==7 | birth_mo_yst==8 | birth_mo_yst==9) & (year==2005 | year==2006)
replace Tit=1 if (birth_mo_yst==2 | birth_mo_yst==3 | birth_mo_yst==4) & (year==2005 | year==2006)
replace Tit=0 if (birth_mo_yst==11 | birth_mo_yst==12 | birth_mo_yst==1) & year>2006
replace Tit=1 if (birth_mo_yst==6 | birth_mo_yst==7 | birth_mo_yst==8) & year>2006

*HU changing cutoff: jan until 2010, then march
gen Thu=.
replace Thu=1 if (birth_mo_yst==10 | birth_mo_yst==11 | birth_mo_yst==12) & year<2010
replace Thu=0 if (birth_mo_yst==3 | birth_mo_yst==4 | birth_mo_yst==5) & year<2010
replace Thu=1 if (birth_mo_yst==12 | birth_mo_yst==1 | birth_mo_yst==2) & year>2009
replace Thu=0 if (birth_mo_yst==5 | birth_mo_yst==6 | birth_mo_yst==7) & year>2009

********************************************************************************************************************************

***** 2. set observation dates - quarter after treatment date
***3 month windows

*sept enrollment
* Before enrolment (placebo)
gen obsq0T=0
replace obsq0T=1 if (rem==7 | rem==8 | rem==9)
gen obsq0C=0
replace obsq0C=1 if (rem==12 | rem==1 | rem==2)
* In 4th quarter (1 quarter after enrolment)
gen obsq4T=0
replace obsq4T=1 if (rem==10 | rem==11 | rem==12)
gen obsq4C=0
replace obsq4C=1 if (rem==3 | rem==4 | rem==5)
* In 1st quarter (2 quarters after enrolment)
gen obsq1T=0
replace obsq1T=1 if (rem==1 | rem==2 | rem==3)
gen obsq1C=0
replace obsq1C=1 if (rem==6 | rem==7 | rem==8)
* In 2nd quarter (3 quarters after enrolment)
gen obsq2T=0
replace obsq2T=1 if (rem==4 | rem==5 | rem==6)
gen obsq2C=0
replace obsq2C=1 if (rem==9 | rem==10 | rem==11)
* In 3rd quarter (3 quarters after enrolment)
gen obsq3T=0
replace obsq3T=1 if (rem==7 | rem==8 | rem==9)
gen obsq3C=0
replace obsq3C=1 if (rem==12 | rem==1 | rem==2)

	
********************************************************************************************************************************************
	
***** 3. set kid age at cutoff
* Include only kids of childcare enrolment age
gen sample_age_Tjan_q4=0
replace sample_age_Tjan_q4=1 if kidage_qtr>2.6 & kidage_qtr<3.5
gen sample_age_Tjan_q1=0
replace sample_age_Tjan_q1=1 if kidage_qtr>2.9 & kidage_qtr<3.7

gen sample_age_Tjan_q2=0
replace sample_age_Tjan_q2=1 if kidage_qtr>3.2 & kidage_qtr<4.0
gen sample_age_Tjan_q3=0
replace sample_age_Tjan_q3=1 if kidage_qtr>3.5 & kidage_qtr<4.3
gen sample_age_Tjan_q0=0
replace sample_age_Tjan_q0=1 if kidage_qtr>2.5 & kidage_qtr<3.3

gen sample_age_Tmar_q4=0
replace sample_age_Tmar_q4=1 if kidage_qtr>2.3 & kidage_qtr<3.2
gen sample_age_Tmar_q1=0
replace sample_age_Tmar_q1=1 if kidage_qtr>2.6 & kidage_qtr<3.5

gen sample_age_Tmar_q2=0
replace sample_age_Tmar_q2=1 if kidage_qtr>2.9 & kidage_qtr<3.7
gen sample_age_Tmar_q3=0
replace sample_age_Tmar_q3=1 if kidage_qtr>3.2 & kidage_qtr<4.0

gen sample_age_Tmar_q0=0
replace sample_age_Tmar_q0=1 if kidage_qtr>2.2 & kidage_qtr<3.0

gen sample_age_Tmay_q4=0
replace sample_age_Tmay_q4=1 if kidage_qtr>2.1 & kidage_qtr<3
gen sample_age_Tmay_q1=0
replace sample_age_Tmay_q1=1 if kidage_qtr>2.4 & kidage_qtr<3.3

gen sample_age_Tmay_q2=0
replace sample_age_Tmay_q2=1 if kidage_qtr>2.7 & kidage_qtr<3.6
gen sample_age_Tmay_q3=0
replace sample_age_Tmay_q3=1 if kidage_qtr>3.0 & kidage_qtr<3.9

gen sample_age_Tmay_q0=0
replace sample_age_Tmay_q0=1 if kidage_qtr>2.0 & kidage_qtr<2.9

gen sample_age_TmayP_q4=0
replace sample_age_TmayP_q4=1 if kidage_qtr>3.1 & kidage_qtr<4
gen sample_age_TmayP_q1=0
replace sample_age_TmayP_q1=1 if kidage_qtr>3.4 & kidage_qtr<4.3

gen sample_age_TmayP_q2=0
replace sample_age_TmayP_q2=1 if kidage_qtr>3.7 & kidage_qtr<4.6
gen sample_age_TmayP_q3=0
replace sample_age_TmayP_q3=1 if kidage_qtr>4.0 & kidage_qtr<4.9

gen sample_age_TmayP_q0=0
replace sample_age_TmayP_q0=1 if kidage_qtr>3.0 & kidage_qtr<3.9

gen sample_age_Tsep_q4=0
replace sample_age_Tsep_q4=1 if kidage_qtr>2.9 & kidage_qtr<3.7
gen sample_age_Tsep_q1=0
replace sample_age_Tsep_q1=1 if kidage_qtr>3.2 & kidage_qtr<4

gen sample_age_Tsep_q2=0
replace sample_age_Tsep_q2=1 if kidage_qtr>3.5 & kidage_qtr<4.3
gen sample_age_Tsep_q3=0
replace sample_age_Tsep_q3=1 if kidage_qtr>3.8 & kidage_qtr<4.6

gen sample_age_Tsep_q0=0
replace sample_age_Tsep_q0=1 if kidage_qtr>2.8 & kidage_qtr<3.6

gen sample_age_TsepPr_q4=0
replace sample_age_TsepPr_q4=1 if kidage_qtr>1.9 & kidage_qtr<2.7
gen sample_age_TsepPr_q1=0
replace sample_age_TsepPr_q1=1 if kidage_qtr>2.2 & kidage_qtr<3

gen sample_age_TsepPr_q2=0
replace sample_age_TsepPr_q2=1 if kidage_qtr>2.5 & kidage_qtr<3.3
gen sample_age_TsepPr_q3=0
replace sample_age_TsepPr_q3=1 if kidage_qtr>2.8 & kidage_qtr<3.6

gen sample_age_TsepPr_q0=0
replace sample_age_TsepPr_q0=1 if kidage_qtr>1.8 & kidage_qtr<2.6

*Tit post enrollment assumed:
gen sample_age_Tit_q4=0
replace sample_age_Tit_q4=1 if kidage_qtr>2.9 & kidage_qtr<3.7  & year>2006
replace sample_age_Tit_q4=1 if kidage_qtr>3.1 & kidage_qtr<4 & (year==2005 | year==2006)
gen sample_age_Tit_q1=0
replace sample_age_Tit_q1=1 if kidage_qtr>3.2 & kidage_qtr<4  & year>2006
replace sample_age_Tit_q1=1 if kidage_qtr>3.4 & kidage_qtr<4.3 & (year==2005 | year==2006)

gen sample_age_Tit_q2=0
replace sample_age_Tit_q2=1 if kidage_qtr>3.5 & kidage_qtr<4.3  & year>2006
replace sample_age_Tit_q2=1 if kidage_qtr>3.7 & kidage_qtr<4.6 & (year==2005 | year==2006)
gen sample_age_Tit_q3=0
replace sample_age_Tit_q3=1 if kidage_qtr>3.8 & kidage_qtr<4.6  & year>2006
replace sample_age_Tit_q3=1 if kidage_qtr>4.0 & kidage_qtr<4.9 & (year==2005 | year==2006)

gen sample_age_Tit_q0=0
replace sample_age_Tit_q0=1 if kidage_qtr>2.8 & kidage_qtr<3.6  & year>2006
replace sample_age_Tit_q0=1 if kidage_qtr>3.0 & kidage_qtr<3.9 & (year==2005 | year==2006)

*Thu:
gen sample_age_Thu_q4=0
replace sample_age_Thu_q4=1 if kidage_qtr>2.3 & kidage_qtr<3.2  & year>2009
replace sample_age_Thu_q4=1 if kidage_qtr>2.6 & kidage_qtr<3.5 & year<2010
gen sample_age_Thu_q1=0
replace sample_age_Thu_q1=1 if kidage_qtr>2.6 & kidage_qtr<3.5  & year>2009
replace sample_age_Thu_q1=1 if kidage_qtr>2.9 & kidage_qtr<3.7 & year<2010

gen sample_age_Thu_q2=0
replace sample_age_Thu_q2=1 if kidage_qtr>2.9 & kidage_qtr<3.8  & year>2009
replace sample_age_Thu_q2=1 if kidage_qtr>3.2 & kidage_qtr<4.0 & year<2010
gen sample_age_Thu_q3=0
replace sample_age_Thu_q3=1 if kidage_qtr>3.2 & kidage_qtr<4.1  & year>2009
replace sample_age_Thu_q3=1 if kidage_qtr>3.5 & kidage_qtr<4.3 & year<2010

gen sample_age_Thu_q0=0
replace sample_age_Thu_q0=1 if kidage_qtr>2.2 & kidage_qtr<3.1  & year>2009
replace sample_age_Thu_q0=1 if kidage_qtr>2.5 & kidage_qtr<3.3 & year<2010

gen sample_comp=0
replace sample_comp=1 if kidage_qtr<7 & kidage_qtr>4.5


gen age_sq = age^2
	
save "$mothers\EULFS_eurovi_pooled_final.dta", replace

********************************************************************************************************************************************************


