**NOTE: MAKE SURE TO INSTALL PFWB PRIOR TO RUNNING CODE***
***CODE CREATES DATA FOR STATE-LEVEL and NATIONAL-LEVEL FWB FROM THE 2018 NFCS**
clear all
set more off
cd "/Users/carlyurban/Dropbox/Youth Employment Fin Ed"
use "Data/NFCS2018"

/*CREATE FWB MEASURE*/

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


do Analysis/NFCS_Statenums


gen Over61=1 if age18_61==0
gen Under62=1 if age18_61==1
gen fwb_under62=fwb*Under62
gen fwb_over61=fwb*Over61

gen Below_10th=1 if fwb<31 & fwb!=.
gen Above_90th=1 if fwb>74 & fwb!=.


gen VeryLow=1 if fwb<=29 & fwb!=.
gen VeryHigh=1 if fwb>=68 & fwb!=.
gen Low=1 if fwb<=37&fwb>=30 & fwb!=.
gen MediumLow=1 if fwb<=49&fwb>=38 & fwb!=.
gen MediumHigh=1 if fwb<=57&fwb>=50 & fwb!=.
gen High=1 if fwb>=58 & fwb<=67 & fwb!=.


gen VeryLow_over61=1 if VeryLow==1& Over61==1
gen VeryHigh_over61=1 if VeryHigh==1& Over61==1
gen Low_over61=1 if Low==1& Over61==1
gen MediumLow_over61=1 if MediumLow==1& Over61==1
gen MediumHigh_over61=1 if MediumHigh==1& Over61==1
gen High_over61=1 if High==1& Over61==1


gen VeryLow_under62=1 if VeryLow==1& Under62==1
gen VeryHigh_under62=1 if VeryHigh==1& Under62==1
gen Low_under62=1 if Low==1& Under62==1
gen MediumLow_under62=1 if MediumLow==1& Under62==1
gen MediumHigh_under62=1 if MediumHigh==1& Under62==1
gen High_under62=1 if High==1& Under62==1


**GENERATE 1's for COINTS
gen Num_in_State=1
gen Num_in_Country=1
gen US=1



tab state, gen(state)

***DETERMINE IF EACH STATE IS STATISTICALLY DIFFERENT FROM OTHER'S AVERAGES***
set more off
forvalues i==1(1)51{
tab state if state`i'==1

reg fwb state`i' [aweight=wgt_s3]
eststo fwbstate`i'
reg fwb_under62 state`i' [aweight=wgt_s3]
eststo fwb_under62_state`i'
reg fwb_over61 state`i' [aweight=wgt_s3]
eststo fwb_over61_state`i'

}
esttab fwbstate* using Results/FWB_state_means.csv, replace star(* 0.10 ** 0.05 *** 0.01) 
esttab fwb_under62* using Results/FWB_state_means_under62.csv, replace star(* 0.10 ** 0.05 *** 0.01) 
esttab fwb_over61* using Results/FWB_state_means_over61.csv, replace star(* 0.10 ** 0.05 *** 0.01) 


****CREATE NATIONAL DATA****
preserve

collapse (mean) fwb fwb_under62 fwb_over61  ///
(sd) sd=fwb sd_young=fwb_under62 sd_old=fwb_over61 ///
(p10) p10=fwb p10_young=fwb_under62 p10_old=fwb_over61 ///
(p25) p25=fwb p25_young=fwb_under62 p25_old=fwb_over61 ///
(p50) p50=fwb p50_young=fwb_under62 p50_old=fwb_over61 ///
(p75) p75=fwb p75_young=fwb_under62 p75_old=fwb_over61 ///
(p90) p90=fwb p90_young=fwb_under62 p90_old=fwb_over61 ///
(count) Num_in_Country Below_10th Above_90th VeryLow VeryHigh ///
[aweight=wgt_n2], by(US)


gen Percent_Below10th=Below_10th/Num_in_Country
gen Percent_Above90th=Above_90th/Num_in_Country

gen Percent_VeryLow=VeryLow/Num_in_Country
gen Percent_VeryHigh=VeryHigh/Num_in_Country

save Data/USLevelNFCS.dta, replace

restore


****CREATE STATE LEVEL DATA*****
collapse (mean) fwb fwb_under62 fwb_over61 (sd) ///
sd=fwb sd_young=fwb_under62 sd_old=fwb_over61 ///
(p10) p10=fwb p10_young=fwb_under62 p10_old=fwb_over61 ///
(p25) p25=fwb p25_young=fwb_under62 p25_old=fwb_over61 ///
(p50) p50=fwb p50_young=fwb_under62 p50_old=fwb_over61 ///
(p75) p75=fwb p75_young=fwb_under62 p75_old=fwb_over61 ///
(p90) p90=fwb p90_young=fwb_under62 p90_old=fwb_over61 ///
(count) Num_in_State Over61 Under62 Below_10th Above_90th  ///
VeryLow VeryHigh Low MediumLow MediumHigh High ///
VeryLow_over61 VeryHigh_over61 Low_over61 MediumLow_over61 MediumHigh_over61 High_over61 ///
VeryLow_under62 VeryHigh_under62 Low_under62 MediumLow_under62 MediumHigh_under62 High_under62 ///
[aweight=wgt_s3], by(state)

gen Percent_Below10th=Below_10th/Num_in_State
gen Percent_Above90th=Above_90th/Num_in_State

gen Percent_VeryLow=VeryLow/Num_in_State
gen Percent_VeryHigh=VeryHigh/Num_in_State
gen Percent_High=High/Num_in_State
gen Percent_Low=Low/Num_in_State
gen Percent_MediumLow=MediumLow/Num_in_State
gen Percent_MediumHigh=MediumHigh/Num_in_State


gen Percent_VeryLow_over61=VeryLow_over61/Over61
gen Percent_VeryHigh_over61=VeryHigh_over61/Over61
gen Percent_High_over61=High_over61/Over61
gen Percent_Low_over61=Low_over61/Over61
gen Percent_MediumLow_over61=MediumLow_over61/Over61
gen Percent_MediumHigh_over61=MediumHigh_over61/Over61


gen Percent_VeryLow_under62=VeryLow_under62/Under62
gen Percent_VeryHigh_under62=VeryHigh_under62/Under62
gen Percent_High_under62=High_under62/Under62
gen Percent_Low_under62=Low_under62/Under62
gen Percent_MediumLow_under62=MediumLow_under62/Under62
gen Percent_MediumHigh_under62=MediumHigh_under62/Under62




save Data/StateLevelNFCS.dta, replace

