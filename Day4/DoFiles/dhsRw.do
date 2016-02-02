/*
Process and clean DHS data on Rwanda nutrition, 2014-2015
Laura Hughes, lhughes@usaid.gov
*/

clear
import delimited "/Users/laurahughes/GitHub/StataTraining/Day4/Data/dhs_data_rwanda.csv", delimiter(comma, collapse) varnames(1) rowrange(1) encoding(ISO-8859-1)

reshape long percentless3sd_@ percentless2sd_@ meanz_@ percentmore2sd_@, i(group) j(measurement, string)

export 
