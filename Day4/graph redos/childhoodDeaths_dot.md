### Creating a lollipop chart in Excel (Version 2010, Windows).

1. Create a bubble plot with size proportional to the number of deaths, x is type of disease, and y is the percentage of teh disease, by country.
    * Select the first country
    * Select bubble plot
    * Specify that column B (numdeaths_Africa) is the size variable.
2. Sort Z to A on total deaths (column N)
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
    * Scale bubble to 50%
    * 
  
