* Purpose: Solution to in-class merge exercise
* Author: Tim Essam (GeoCenter)`
* Date: 2016.01.13

* Set web url to point to Github repo for easy merging
webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
global dataurl "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"

* Review both datasets to see what unique id we should merge on
webuse "ind2.dta", clear
clist
isid id hid

* Review the using dataset before jumping into the merge syntax
webuse "hh3.dta", clear
clist

* Looks like there are some repeated observations in the using data; We can delete
* them or do a many to many merge,, but this can be risky
* We are going to delete the duplicates
duplicates report 

* Instead of hard-coding the drop, let's make it general so we can apply it to a full dataset
* Imagine if we had 10,000 observations, it wouldn't be feasible to type: 
* 	drop in 2
*	drop in 5
* 	drop in xx...
* We can use the bysort command to generate a tracking variable within each hid unit
bysort hid: gen id = _n
clist

* Now, we know that when id == 2 we want to remove these observations
drop if id == 2
clist
isid hid

* Do not forget to save the updated file!!! We'll use a temp file here so you 
* do not have navigate to a new directory. A good resource is 
* here: http://www.cpc.unc.edu/research/tools/data_analysis/statatutorial/misc/temp_files
* Warning: temp files can be tricky to use, they are local in nature so they only exist
* within a chunk of code or a program. We need to run this code all at once or Stata will
* not be able to find `temp1' in the merge line below.
tempfile temp1
save "`temp1'"

* Can also save to a local directory:
saveold "C:\Users\t\Documents\GitHub\StataTraining\Day2\Data\merge_hw.dta

* Both datasets have a hid variable so it looks like we will be merging to that
webuse "ind2.dta", clear
merge m:1 hid using "`temp1'"

* Keep observations that appear in both datasets
keep if _merge == 3
clist


* Alternative solution, using a stata file saved on your machine (here, I am pulling from repo).
webuse "ind2.dta", clear
merge m:1 hid using "$dataurl/merge_hw"
keep if _merge == 3

clist
