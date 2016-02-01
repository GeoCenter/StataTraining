/*
Data visualization warmup: the importance of _looking_ at your data

We're going to load in four sets of y values, with a common x variable.
It's your job to figure out if the data differ.
*/

/* Change to the working directory where you have saved the file, 
using the File --> Change Working Directory or the cd command */
// For example:
// cd "/Users/laurahughes/GitHub/StataTraining/Day3/Data"

// Load in the data
use "quartet.dta", clear


// What do the data look like? -------------------------------------------------
// Explore the y-data and figure out...
// How many missing values are there? 
// What is the mean?
// the median?
// the standard deviation?
// the range?


// What would you conclude about the 4 different variables? --------------------


// Now plot the data. ----------------------------------------------------------
// You can use the dropdown window, or the command line, and any graph you want.
// Hint: you might want to look at twoway scatter plots.


/* If you're pointing-and-clicking, try...
GRAPHICS (top of the menu bar) --> TWOWAY GRAPH (scatter, line, etc.)
Under PLOTS --> CREATE (a plot definition)
Choose your x and y variables and click ACCEPT
Then click SUBMIT to plot

If you want, you can go back and change the plot options in the other 
tabs in the plot window (if/in, y axis, x axis, titles, ...)

*/

/* To type the command, type something like...
graph twoway scatter y x

where y is the name of the variable to use as the y-value, and x is the x-value
*/ 



// Do you notice any differences when you plot the data versus when you look at summary statistics?

