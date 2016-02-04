## Making a halfway decent graph in Excel

First, we need data to work on.  We're going to use data from a recent chart the WHO published, which could use a little refresh
**Note: these values are read from the chart, and are at least somewhat inaccurate.

I'm using Microsoft Excel 2010 for Windows, so things may look slightly different in your software.

### Creating a bar graph of the total childhood deaths by disease type.
1. Create a basic bar graph. Here, I'll use the first two columns of data, though it's not what we want in the end.
Select columns A and B, and then click **Insert** (top toolbar) --> **Column** --> **2D Clustered Column** (top left)
![bar_01]()

2. Change the data to be the **disease** (column A) as the x variable, and **total deaths** (column N) as y.
    There are a couple ways to do this.
   * If you click on the chart, you should see a purple and blue box outlining the variables.  Your x variable is in purple and y in blue.  Click and drag the blue box over to column N. 
   ![bar_02]()
   * Alternatively, you can tell Excel which column to use. Click **Chart Tools** (top toolbar) --> **Select Data** --> **Edit** -->
Change **Series Values** to be **=Sheet1!$N$2:$N$9**

You should have something that looks like this:
![bar_03]()

3. Time to clean things up.  Easy things first: let's get rid of the __legend__.  We don't need it.  Click on it, hit delete, and instantly your graph is better.
![bar_04]()
4. Better. There's A LOT of grid lines, and they're dark.  Let's make the __grid lines less dominant__ on the graph.
    * Click on the y grid lines (horizontal lines across the graph) and double click.
    * The **Format Major Gridlines** box will come up.  Select **Solid Line** and change the color.  I like the **15% grey**
    * Before you click "okay", click **Line Style**.  Change the line **width** to be **0.2 pt**.  Thin and light focuses your eye on the data, not the grid lines.
![bar_05]()

5.  Better-- but there's still a lot of grid lines.  Let's make the __grid lines less frequent__.  Double click on the y-axis to pull up the **Format Axis** menu.  Change the axis limits using **Axis Options**:
    * minimum: 0
    * maximum: 4
    * major unit: 1 *! important! this is the spacing between the gridlines.
![bar_06]()

6. Time to unrotate the __x-axis titles__. Double click the x-axis, pulling up the **Format Axis** menu.
    * Under **alignment** change the **custom angle** to be **0 degrees**.
    * Now the text is perpendicular to the axis, but overlaps.
![bar_07]()
    * Shrink the font size to 8 point in the **Font menu** (in **Home**).
    * Change the font color to a medium grey.
![bar_08]()

7.  That looks decent, but it'd probably make more sense if the bars were __ordered__ from highest to lowest.
    * On the **home** tab, select **Sort & Filter** --> **Sort Z to A**
![bar_09]()
And now it looks like this:
![bar_10]()

8.  Time to directly __label bars with values__.
    * Right click on the bars and **Add Data Labels**
    * ![bar_11]()
    * Eep!  Lots of digits.  Right click on the labels to **Format Data Labels**
    * On the **Format Data Labels** menu, click **Number** and change from General to **Number** with **1 decimal place**
    * ![bar_12]()
    * On the **Font menu** (in **Home**) increase font size to **12 point**.
    * Change the font color to a grey.
    * Since we have value labels on the bars, we don't need numbers on the **y-axis**.  Click the y-axis and hit **delete**.
    * ![bar_13]()
    * While we're getting rid of superfluous things, there's no reason for the __x-axis tick marks__.  Double click the **x-axis** and select **none** in the **major tick mark type**
    *  ![bar_15]()
9.  

    
