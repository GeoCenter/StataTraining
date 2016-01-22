clear
set seed 25

range id 1 50 50


gen x1 = runiformint(0, 100)

set seed 13
gen y1 = runiformint(0, 100)

set seed 1
gen sign = runiform(-1, 1)

gen y2 = x1 + y1 
gen y3 = id + sign * y1 * 0.2
gen x2 = x1

gen y4 = y1

gen gauss = rnormal(0, 0.2)

replace y4 = 175 if y4 > 98

gen facet = y1 >= 50

gen yStr = string(y1)



// scatter plot ----------------------------------------------------------------
twoway(scatter y2 x1 in 1/40), play(peachTheme)

graph export "scatter.pdf", as(pdf) replace


// line
twoway(line y3 id in 1/20, sort)

// connected
//twoway(connected y1 x1)

// area
twoway(area y3 id in 5/20, sort)

// bar
gr bar (asis) id in 1/4, over(id, reverse)

// hbar
gr hbar (asis) id in 1/4, over(id)

// box
gr box y4 y2

gr hbox y2 y4

// hist
hist gauss, w(0.2)
