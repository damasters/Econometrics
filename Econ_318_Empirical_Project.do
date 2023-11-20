cd "C:\Users\Daniel\Documents\ECON 318"
ssc install outreg2

use "EmployeeStatus.dta", clear
sort personid
merge 1:1 personid using "EmployeeCharacteristics.dta"
drop _merge
merge 1:1 personid using "Quits.dta"
drop _merge
merge 1:m personid using "Attitudes.dta"
drop _merge
replace age = . if age < 0
replace tenure = . if tenure < 0
replace prior_experience = . if prior_experience < 0
gen treat_post = treatment*post
reg satisfaction treatment post treat_post
outreg2 using attitudes_reg, word

use "EmployeeStatus.dta", clear
sort personid
merge 1:1 personid using "EmployeeCharacteristics.dta"
drop _merge
merge 1:1 personid using "Quits.dta"
drop _merge
merge 1:m personid using "Performance_Panel.dta"
drop _merge
replace performance_score = . if performance_score < 0
replace performance_score = . if performance_score > 100
gen post_treat = treatment*post
reg performance_score treatment post post_treat
outreg2 using performance_panel_reg, word
gen day = 15
gen date = mdy(month,day,year)
format date %tdccyy-NN-DD
bys date treatment: egen avg_performance = mean(performance_score)
twoway (connected avg_performance date if treatment == 0, xline(18626, lpattern(dash)lcolor(black)))(connected avg_performance date if treatment == 1), legend(label(1 "Treatment") label(2 "Control"))