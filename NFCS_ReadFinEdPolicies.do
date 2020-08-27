**CODING NFCS STATE-MANDATED FIN ED GRADUATION REQUIREMENT POLICIES**
*NOTE THAT NFCS STATEQ is not a state fips! 

**MAKE SURE YOU READ THE NOTES FOR NUANCES! LOUISIANA AND FLORIDA ARE THE MOST IMPORTANTED!
rename STATEQ state

gen FinEd=.
replace FinEd=2005 if state==4
replace FinEd=2005 if state==3
replace FinEd=2007 if state==11
replace FinEd=1993 if state==30
replace FinEd=2011 if state==16
replace FinEd=1996 if state==33
replace FinEd=2013 if state==38
replace FinEd=2001 if state==13
replace FinEd=1970 if state==14
replace FinEd=2009 if state==41
replace FinEd=2011 if state==43
replace FinEd=2007 if state==44
replace FinEd=2008 if state==45
replace FinEd=2005 if state==19
**NOTE: LA DROPPED IN 2016 graduating for class of 2018, and then back on the books starting class of 2023**
replace FinEd=1998 if state==23
replace FinEd=2012 if state==17
replace FinEd=2010 if state==26
replace FinEd=2005 if state==34
replace FinEd=2002 if state==51
replace FinEd=2014 if state==37
replace FinEd=2014 if state==36
replace FinEd=2015 if state==47
replace FinEd=2020 if state==49 /*Note: Can opt out if take AP Gov*/
replace FinEd=2017 if state==1
replace FinEd=2014 if state==31
replace FinEd=2024 if state==18 
replace FinEd=2022 if state==29 
replace FinEd=2017 if state==20 
replace FinEd=2014 if state==28
replace FinEd=2009 if state==6 
replace FinEd=2013 if state==15
replace FinEd=2011 if state==35 
replace FinEd=2018 if state==10 /*FL just went from required to required to offer starting AY 2020-2021 */
replace FinEd=2015 if state==24

*States know still without: AK (2), CA (5), CT (7), DC (9), DE (8), HI (12), MA (22), MD (21), MS (25), MT (27), PA (39), RI (40), VT (46), NM (32), SD (42), WA (48), WI (50)



