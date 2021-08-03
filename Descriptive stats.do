* Descriptive stats table
* Eurovi 2017/06/13

use	"C:\Users\szabo\OneDrive\Documents\Dropbox\Eurovi\Data_and_info\reg_sample_1Q.dta",	clear
*use	"C:\Users\szabo\OneDrive\Documents\Dropbox\Eurovi\Data_and_info\reg_sample_2Q.dta",	clear
keep if m == 1

**************1Q / 2Q??*******************
global descvars isced2 isced3 isced4 mst_wid mst_sin mst_mar age kidage_qtr activ

*global matrows math_score reading_score 

foreach c in 40	203	250	300	348	380	703 {
	mat M`c' = J(9,4,0)
	*mat rown M1 = $matrows
	mat coln M`c' = `c'Mean_Control `c'Mean_Treat `c'Diff_Pval N
	local i 1
		foreach var in  $descvars {	
			disp "`var'"													
				ttest `var' if country  == `c' , by(T)
				mat M`c' [`i',1] = r(mu_1)
				mat M`c' [`i',2] = r(mu_2)
				mat M`c' [`i',3] = r(p)
				mat M`c' [`i',4] = r(N_1) + r(N_2)	
				local i `i'+1
	}
}
																		

foreach c in 40	203	250	300	348	380	703 {
	matlist M`c'
}



