use C:\Users\szabo\OneDrive\Documents\Dropbox\Eurovi\Data_and_info\Long_run_results.dta, clear
global graphlib "C:\Users\szabo\OneDrive\Documents\Dropbox\Eurovi\results\Graph_14sep2017"

reshape long q, i(country estimate) j(time)
rename q q_
reshape wide q, i(country time) j(estimate) string


foreach country in Austria "Czech Republic" France Greece Hungary Italy Slovakia {

twoway (scatter q_mT_est time if country == "`country'", m(O) msiz(medium) mc(dkorange) c(l) lc(dkorange)) (rcap q_mT_high q_mT_low time if country == "`country'", lc( dkorange) legend(order(1 "m*T" 2 "99% CI" 3 "m" 4 "99% CI")))  ///	
		(scatter q_m_est time if country == "`country'", m(S) msiz(small) mc(midblue) c(l) lc(midblue)) (rcap q_m_high q_m_low time if country == "`country'", lc( midblue) ), ///
		xtitle("Quarter after treatment")  ///
		ytitle("Coefficient estimates") ///
		yline(0) ///
		title("`country'") legend(off)
		graph export "$graphlib\C_`country'.tif", replace width(1200)
		graph save Graph "$graphlib\C_`country'.gph", replace
	}	
	
	cd "C:\Users\szabo\OneDrive\Documents\Dropbox\Eurovi\results\Graph_14sep2017"
	gr combine C_Austria.gph C_France.gph  C_Slovakia.gph "C_Czech Republic.gph" C_Hungary.gph  C_Greece.gph C_Italy.gph ///
		,  title("Estimates") ycom
		graph export "$graphlib\Estimates.tif", replace width(1200)


foreach country in Slovakia {

twoway (scatter q_mT_est time if country == "`country'", m(O) msiz(medium) mc(dkorange) c(l) lc(dkorange)) (rcap q_mT_high q_mT_low time if country == "`country'", lc( dkorange) legend(order(1 "m*T" 2 "99% CI" 3 "m" 4 "99% CI")))  ///	
		(scatter q_m_est time if country == "`country'", m(S) msiz(small) mc(midblue) c(l) lc(midblue)) (rcap q_m_high q_m_low time if country == "`country'", lc( midblue) ), ///
		xtitle("Quarter after treatment")  ///
		ytitle("Coefficient estimates") ///
		title("`country'")
		graph export "$graphlib\C_`country'_legend.tif", replace width(1200)
		graph save Graph "$graphlib\C_`country'_legend.gph", replace
	}	
	
