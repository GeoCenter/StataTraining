clear

* --- Exercise 1 --- *

* Run the lines below to set up a wide dataframe (highlight all the lines below up to Question 1
* and then press ctrl + d to input the dataframe)
input str3 country str5 agency q1FY2009 q2FY2009 q3FY2009 q4FY2009 q1FY2010 q2FY2010 q3FY2010 q4FY2010
"AFG"	"USAID"	399	361	254	71	378	398	85	39
"ALB"	"USAID"	45	282	40	285	306	230	398	216
"ANG"	"USAID"	354	24	19	252	146	123	369	376
"ARM"	"USAID"	86	89	127	212	394	255	141	74
"AZE"	"USAID"	116	239	330	34	92	315	312	220
end

* --- Question 1: 
* Use the "reshape" (long) command to create a new variable named "year"
* What does the resulting data frame look like? How many quarter variables are left?
reshape long q1FY q2FY q3FY q4FY, i(country) j(year)

* --- Question 2: 
* Use the "rename" command to rename the remaining variables (quarter) in a 
* manner that allows you to reshape again. Then, use the "reshape" (long) command
* to create a tidy data frame.  
rename *FY *
reshape long q@, i(country year) j(quarter)
rename q frequency 

* --- Question 3:
* Use the "table" command to create a two-way table of the average frequency
* by country and year
table country year, c(mean frequency)

* -----------------------------------------------------------------------------*

* --- Exercise 2 --- *

* Run the lines below to set up a wide dataframe (highlight all the lines below up to Question 1
* and then press ctrl + d to input the dataframe)
clear
input cid date changeAg changeSrvices
1 2015	8.28 4.12 
1 2016  9.23 5.69
2 2015 9.10 -5.23 
2 2016 10.55 6.92
end
label variable cid "country id"
label variable date "year"
label variable changeAg "Agricultural growth (% of GDP)"
label variable changeSrvices "Service growth (% of GDP)"

* --- Question 1: 
* Reshape (long) the dataframe to create a new variable called gdpType. It should contain
* the string values currently contained in the variables found in columns 3 and 4.
* Hint: use the "string" option when specifying the j variable in your reshape
reshape long change, i(cid date) j(gdpType, string)

* --- Question 2: Use the replace command to change all the occurences of "Ag" to
* "Agriculture" and to change all occurences of "Srvices" to "Services"
replace gdpType = "Agriculture" if gdpType == "Ag"
replace gdpType = "Services" if gdpType == "Srvices"

* --- Question 3: Rename the "change" variable to be more descriptive



* -----------------------------------------------------------------------------*
* --- Exercise 3 --- *
clear
input str11 CountryName	str3 CountryCode	str35 SeriesName	year2012
"Afghanistan"	"AFG"	Ag	24.60324707
"Afghanistan"	"AFG"	GDP	14.43474129
"Afghanistan"	"AFG"	Tax	7.471638846
"Kenya"	"KEN"	Ag	29.08937253
"Kenya"	"KEN"	GDP	4.554912438
"Kenya"	"KEN"	Tax	15.87837126
"Pakistan"	"PAK"	Ag	24.54909124
"Pakistan"	"PAK"	GDP	3.50703342
"Pakistan"	"PAK"	Tax	10.09935899
"Senegal"	"SEN"	Ag	16.72581231
"Senegal"	"SEN"	GDP	4.363200853
"Senegal"	"SEN"	Tax	19.182225
end

* --- Quesiton 1: Reshape (wide) the dataframe to create three new variables that contain
* the values for the SeriesName variable. 
* Hint: use the ", string" option for the j variable. Also, when reshaping wide
* you do not need to use the "@" character, just the stub 
 
reshape wide year2012, i(CountryName) j(SeriesName, string)

* --- Quesiton 2: Rename the resulting variables and create a new variable called "year"
* that takes the appropriate value of the year given in the original dataframe.

* --- Question 3: Do you think the dataframe needed to be reshaped wide? Why or why not?





* -----------------------------------------------------------------------------*


* --- Extra Credit: Exercise 4 --- *

* Reshaping long to wide *

* Run the lines below to set up a messy dataframe (highlight all the lines below
* question 1 and press ctrl+d)
clear
input str5 person	str5 software year2014 year2015 year2016
"Tim" "Stata"	5.93	2.40	10.25
"Tim" "R"	100	56	515
"Laura" "Stata"	3.09	4.26	7.93
"Laura" "R"	917	751		253
"Aaron" "Stata"	3.09	4.26	5.23
"Aaron" "R"	115	235	613
"Doug" "Stata"	7.35	3.23	1.3
"Doug" "R"	478	646	920
end

* Attach variable labels
label variable software "type of software"
label variable year2014 "github commits for 2014"
label variable year2015 "github commits for 2015"
label variable year2016 "github commits for 2016"

* --- Question 1:
* Reshape the data so that "Stata" and "R" are new variables in a tidy data frame
* Use the "reshape" (wide) command to create new variables for the types of software

* Hint 1: when reshaping long --> wide your i variable (unique ID) is the variable
* that will be unique only after reshaping.

* Hint 2: the j variable is the existing string variable you want to reshape into a
* new column. You will need to use the ", string" option when reshaping

* Hint 3: use the * (wildcard) instead of the @ character in the first half of the reshape
* command
reshape wide year*, i(person) j(software, string)

* --- Question 2:
* Reshape the data (long) so that "R" and "Stata" form their own columns and can be sorted by year
* Hint: use the "@" where you expect the year value to appear
reshape long year@R year@Stata, i(person) j(time)
rename (yearR yearStata) (R Stata)

* --- Question 3: Use the table or tabstat (help table or help tabstat) command to summarize the data 
* Who coded the most in R, in total, over the 3 years?
* Who coded the most in Stata, on average, over the last 3 years?
table person time, c(sum R mean Stata) row col
tabstat 


* Bonus part 2: Redo the exercise, this time use the reshape long command first followed
* by the reshape wide command. 
reshape long year@, i(person software) j(year2)
rename year code
reshape wide code, i(person year) j(software, string)
rename (codeR codeStata) (R Stata)
