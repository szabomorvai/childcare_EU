***Where Can Childcare Expansion Increase Mothers’ Labor Force Participation? A Comparison of Quasi-Experimental Estimates from 7 Countries
*Agnes Szabo-Morvai* and Anna Lovasz**
*July 27, 2021
cd "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\work"
global root "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\eulfs_panel"
global mothers "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\Data_and_info\mothers"
global results "C:\Users\szabomorvai.agnes\Dropbox\Research\Eurovi\results"
use "$mothers\EULFS_eurovi_pooled_final.dta", clear
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



