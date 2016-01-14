/* Exercise:

Plot and save the proportion of the spending (disbursements, in millions of USD) 
of each category per fiscal year for USAID

Bonus: Find which sector had the most spending in the timeframe  
Hint: be careful which dates you include! 

Laura Hughes, lhughes@usaid.gov, 12 January 2016

*/

webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"


webuse "pseudocoding_data.dta", clear


describe spent


codebook spent


gen spentAmt = real(spent)


codebook spentAmt 


scalar deflator = 1000000


replace spentAmt = spentAmt / deflator


rename (gorycate fiscalyeartype) (category paymentType)


label variable category "category"


keep if paymentType == "Disbursements" & agency == "USAID"


egen totSpent = sum(spentAmt), by(fiscalyear)


label var totSpent "total spending by fiscal year"


sort fiscalyear category


clist


gen shareByCat = spentAmt / totSpent


label var shareByCat "spending share by category"


table category fiscalyear, c(sum shareByCat) row


egen yearTot = total(shareByCat), by(fiscalyear)


assert yearTot == 1


twoway (scatter shareByCat fiscalyear, sort), by(category)


twoway (connected shareByCat fiscalyear, sort), by(category)


twoway (bar shareByCat fiscalyear), by(category)


encode category, gen(cat_enc)


label var cat_enc "category variable encoded"


xtset cat_enc fiscalyear


xtline shareByCat if fiscalyear >2007, overlay legend(size(small)) scheme(s1color)


save "shareByCat.dta", replace


export excel "shareByCat.xls", firstrow(variables) replace

// Extra credit
drop if fiscalyear < 2009

tabstat spentAmt, by(category) stat(sum)
