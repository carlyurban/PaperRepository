
*****NOTES: TO RUN THIS FILE, DOWNLOAD AND CONVERT TO STATA THE 2012, 2015, AND 2018 STATE-BY-STATE NFCS FILES FROM USFINANCIALCAPABILITY.ORG/DOWNLOADS***

clear all
set more off
cd "/Users/carlyurban/Dropbox/Youth Employment Fin Ed"
use "Data/NFCS2018"
gen year=2018


append using "Data/NFCS2012"
replace year=2012 if year==.
append using "Data/NFCS2015"
replace year=2015 if year==.

do Analysis/NFCS_Statenums



 // The Labeller

rename A2 zipcode
rename A3 gender
gen  age=A3A
rename A3B gender_age
rename A4_1 white
rename A4_2 black
rename A4_3 hispanic
rename A4_4_2015 asian
rename A4_7 hawaiian
rename A4_5 native
rename A4_6 ethnicity_other
rename A4A ethnicity
rename A30 reservation

rename A5 educ
replace educ=A5_2012 if year==2012
replace educ=A5_2015 if year==2015

rename A6 marst
rename A7A marst_living
rename A8 hh_inc
rename A11 num_dependents
rename AM21 mil_ever
rename AM30 mil_compl
rename AM31 mil_ret
rename AM32 mil_branch
rename AM22 mil_spouse
rename X3 qversion
rename X4 mil_dummy
rename A9 empl
rename A10 empl_spouse
rename A10A retire_hh
rename AM7_2012 mil_spouse_branch
rename AM3_2012 mil_spouse_grade
rename AM29 mil_spouse_active
rename X5 mil_active_dummy
rename AM24 mil_spouse_station
rename AM25 mil_station_quarters
rename A21_2015 coll_pt
rename A22_2015 coll_type
rename A14 fin_know_who
rename J1 fin_sat
replace fin_sat=. if fin_sat>10
rename J2 fin_risk
rename J3 fin_bal
rename J4 fin_diff
gen fin_diff_some=0
replace fin_diff_some=1 if fin_diff<3
gen fin_diff_severe=0
replace fin_diff_severe=1 if fin_diff==1

rename J5 fin_rainyday
replace fin_rainyday=0 if fin_rainyday==2
rename J6 fin_college
rename J8 fin_retireclac
rename J9 fin_preretirecalc
rename J10 fin_incdrop
rename J20 fin_2k
rename J30 fin_timehoriz
rename J31 fin_budget
rename J32 fin_creditrecord
rename J33_1 fin_retireworry
rename J33_2 fin_goals
rename B1 hh_checking
rename B2 hh_saving
rename B4 hh_overdraw
rename B30 hh_prepdebit
rename B31 hh_phonepay
rename C1_2012 retire_empl
rename C2_2012 retire_whoseempl
rename C3_2012 retire_choose
rename C4_2012 retire_nonempl
rename C5_2012 retire_contrib
rename C10_2012 retire_loan
rename C11_2012 retire_hardship
rename B14 hh_invest

rename F2_4 cc_latefee
replace cc_latefee=0 if cc_latefee==2

rename F2_5 cc_limitfee

rename G23 debt_toomuch
replace debt_toomuch=. if debt_toomuch>90




gen fin_bal_better=.
replace fin_bal_better=1 if fin_bal==1
replace fin_bal_better=0 if fin_bal==3
replace fin_bal_better=-1 if fin_bal==2

gen overspend=0
replace overspend=1 if fin_bal_better==-1

gen saving=0
replace saving=1 if fin_bal_better==1

/****************
***CREATE FWB****
****************/

gen qfwb1_3=.
gen qfwb1_5=.
gen qfwb1_8=.
gen qfwb1_13=.
gen qfwb1_17=.
gen qfwb1_19=.
gen qfwb2_1=. 
gen qfwb2_2=.
gen qfwb2_4=.
gen qfwb2_5=.

replace qfwb2_2=0 if J42_2==5
replace qfwb2_2=1 if J42_2==4
replace qfwb2_2=2 if J42_2==3
replace qfwb2_2=3 if J42_2==2
replace qfwb2_2=4 if J42_2==1
replace qfwb2_2=. if J42_2==98|J42_2==99

replace qfwb2_5=J42_1-1
replace qfwb2_5=. if J42_1==98|J42_1==99

replace qfwb1_17=0 if J41_1==5
replace qfwb1_17=1 if J41_1==4
replace qfwb1_17=2 if J41_1==3
replace qfwb1_17=3 if J41_1==2
replace qfwb1_17=4 if J41_1==1
replace qfwb1_17=. if J41_1==98|J41_1==99

replace qfwb1_5=0 if J41_2==5
replace qfwb1_5=1 if J41_2==4
replace qfwb1_5=2 if J41_2==3
replace qfwb1_5=3 if J41_2==2
replace qfwb1_5=4 if J41_2==1

replace qfwb1_13=0 if J41_3==5
replace qfwb1_13=1 if J41_3==4
replace qfwb1_13=2 if J41_3==3
replace qfwb1_13=3 if J41_3==2
replace qfwb1_13=4 if J41_3==1

rename qfwb1_3 fwb1_exp
rename qfwb1_5 fwb2_getby
rename qfwb1_8 fwb3_secure
rename qfwb1_13 fwb4_concern
rename qfwb1_17 fwb5_never
rename qfwb1_19 fwb6_enjoy
rename qfwb2_1 fwb7_behind
rename qfwb2_2 fwb8_control
rename qfwb2_4 fwb9_strain
rename qfwb2_5 fwb10_left

gen age18_61= 1 if A3A<=61
replace age18_61=0 if A3A>61 & A3A!=.

gen self=1

pfwb fwb

/**************
**CREATE PFWB**
****************/
**Fin satisfaction, Because of my money situation...**
gen pfwb1_17=4 if fin_sat==10|fin_sat==9
replace pfwb1_17=3 if fin_sat==8|fin_sat==7
replace pfwb1_17=2 if fin_sat==6|fin_sat==5
replace pfwb1_17=1 if fin_sat==3|fin_sat==4
replace pfwb1_17=0 if fin_sat==1|fin_sat==2

**Money left over at the end of the month, expenses<>=income**
gen pfwb2_5=4 if fin_bal==1
replace pfwb2_5=0 if fin_bal==2
replace pfwb2_5=2 if fin_bal==3


**Finances control my life==too much debt?**
gen pfwb2_2=4 if debt_toomuch==1
replace pfwb2_2=3 if debt_toomuch==2|debt_toomuch==3
replace pfwb2_2=2 if debt_toomuch==4
replace pfwb2_2=1 if debt_toomuch==6|debt_toomuch==5
replace pfwb2_2=0 if debt_toomuch==7


**Concerned money I have won't last=> how difficult is it for you to cover your expenses....
gen pfwb1_13=.								
replace pfwb1_13=0 if fin_diff==1
replace pfwb1_13=2 if fin_diff==2
replace pfwb1_13=4 if fin_diff==3


**Emergency Savings=just getting by financially
gen pfwb1_5=4 if fin_2k==1
replace  pfwb1_5=3 if fin_2k==2
replace  pfwb1_5=1 if fin_2k==3
replace  pfwb1_5=0  if fin_2k==4



replace fwb8_control=pfwb2_2
replace fwb10_left=pfwb2_5
replace fwb2_getby=pfwb1_5
replace fwb5_never=pfwb1_17
replace fwb4_concern=pfwb1_13



pfwb PseudFWB
