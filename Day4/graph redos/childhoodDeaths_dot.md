### Creating a lollipop chart in Excel (Version 2010, Windows).

1. Create a bubble plot with size proportional to the number of deaths, x is type of disease, and y is the percentage of the disease, by country.
    * Select the first country
    * Select bubble plot
    * Specify that column B (numdeaths_Africa) is the size variable.
2. Sort A to Z on total deaths (column N)
3. Delete legend
4. Trick Excel into labelling the x-axis by names
    * Right click on data points and **Add data labels**
    * Right click on data labels and **Format data labels**
    * change to x value with a label position of below.
    * Double click the x-axis to pull up the **Format Axis** options.
    * Change the range of the x-axis to be more reasonable: minium = 0, maximum = 9.
    * Click the x axis numbers and delete it-- we don't need it any more.
    * Later, we'll move the labels to the bottom.
5. Add stems to the lollipops
    * Click on the data points.
    * In the **Chart Tools** --> **Layout** --> **Error Bars**, select **More Error Bar Options**
    * Select **Minus**
    * **No End Cap**
    * Percent = **100%**
    * Go to **Line Color** and change to the same shade of blue.
    * Go to **Line Style** and change the width to **2.5 pt**
    * Click on the horizontal error bars Excel was so kind to add and delete.
6. Clean the y axis
    * Double click on the grid lines to pull up the format window
    * Change the **line color** to be a light grey and the **line style** to have a width of 0.2 pt
    * Double click the y-axis to pull up the **Format Axis** options.
    * Change the major unit to be **0.1**, minium to **0**, maximum to **0.5**
    * Remove the Major tick mark type (set to **none**)
    * On the **Numbers** menu for the axis, change to **percentage** with **0 decimal places**
    * On the **Line Color** menu for the axis, change to **no line**
7. Cleanup 
    * Rename title to be Africa
    * Lighten all fonts: y-axis title, x-axis labels, title
    * Resize the plot so it's more square
    * Adjust the size of the bubble so they aren't so big: double click on the bubbles.
    * Scale bubble by changing **scale bubble size = 50 ** (*** Note: this is an absolute size and will be a problem later)
    * Manually click on each of the labels and move them to the bottom of the axis.  NOTE: Ideally, this plot would flip the x and y axes, so the diseases were on the y, where there's more room.  Unfortunately, Excel doesn't let us do that.
    * And let's re-sort the total diseases, so the most prevalent one is on the left side.
8. Create small mulitples of the other regions
    * Copy the plot and paste 5 times, for the other regions.
    * Select the data for the different columns (remember to change the **y** variable and the **size** variable).
    * Change the title to reflect the different region
    * Readjust the position of the x-labels.
    * Egads! Those bubbles for Americas look to be HUGE-- as big as the one in the Africa plot.  It turns out that Excel scales the largest data point to be a fixed side.  Which means, we can't compare the sizes between plots.  Alas... this can't be (easily) done.
9.  Retreat! Fix stupid Excel
    * Edit the data points, removing the size variable.
    * Change the size of the bubbles: double click bubbles and set **scale bubble size** to 20 so not so huge.
    * Finish copying other regions.
    * Reorder the small multiples by most total deaths (Africa) to least (Europe)
  
