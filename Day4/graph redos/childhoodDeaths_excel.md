## Making a halfway decent graph in Excel

First, we need data to work on.  We're going to use data from a recent chart the WHO published, which could use a little refresh
**Note: these values are read from the chart, and are at least somewhat inaccurate.

I'm using Microsoft Excel 2010 for Windows, so things may look slightly different in your software.

### Creating a bar graph of the total childhood deaths by disease type.
1. Create a basic bar graph. Here, I'll use the first two columns of data, though it's not what we want in the end.
Select columns A and B, and then click **Insert** (top toolbar) --> **Column** --> **2D Clustered Column** (top left)
![bar_01](/Day4/graph redos/bar_01.png)

2. Change the data to be the **disease** (column A) as the x variable, and **total deaths** (column N) as y.
    There are a couple ways to do this.
   * If you click on the chart, you should see a purple and blue box outlining the variables.  Your x variable is in purple and y in blue.  Click and drag the blue box over to column N. 
   ![bar_02](/Day4/graph redos/bar_02.png)
   * Alternatively, you can tell Excel which column to use. Click **Chart Tools** (top toolbar) --> **Select Data** --> **Edit** -->
Change **Series Values** to be **=Sheet1!$N$2:$N$9**

You should have something that looks like this:
![bar_03](/Day4/graph redos/bar_03.png)

3. Time to clean things up.  Easy things first: let's get rid of the _legend_.  We don't need it.  Click on it, hit delete, and instantly your graph is better.
![bar_04](/Day4/graph redos/bar_04.png)
4. Better. There's A LOT of grid lines, and they're dark.  Let's make the _grid lines less dominant_ on the graph.
    * Click on the y grid lines (horizontal lines across the graph) and double click.
    * The **Format Major Gridlines** box will come up.  Select **Solid Line** and change the color.  I like the **15% grey**
    * Before you click "okay", click **Line Style**.  Change the line **width** to be **0.2 pt**.  Thin and light focuses your eye on the data, not the grid lines.
![bar_05](/Day4/graph redos/bar_05.png)

5.  Better-- but there's still a lot of grid lines.  Let's make the _grid lines less frequent_.  Double click on the y-axis to pull up the **Format Axis** menu.  Change the axis limits using **Axis Options**:
    * minimum: 0
    * maximum: 4
    * major unit: 1 *! important! this is the spacing between the gridlines.
![bar_06](/Day4/graph redos/bar_06.png)

6. Time to unrotate the _x-axis titles_. Double click the x-axis, pulling up the **Format Axis** menu.
    * Under **alignment** change the **custom angle** to be **0 degrees**.
    * Now the text is perpendicular to the axis, but overlaps.
![bar_07](/Day4/graph redos/bar_07.png)
    * Shrink the font size to 8 point in the **Font menu** (in **Home**).
    * Change the font color to a medium grey.
![bar_08](/Day4/graph redos/bar_08.png)

7.  That looks decent, but it'd probably make more sense if the bars were _ordered_ from highest to lowest.
    * On the **home** tab, select **Sort & Filter** --> **Sort Z to A**
![bar_09](/Day4/graph redos/bar_09.png)
And now it looks like this:
![bar_10](/Day4/graph redos/bar_10.png)

8.  Time to directly _label bars with values_.
    * Right click on the bars and **Add Data Labels**
    * ![bar_11](/Day4/graph redos/bar_11.png)
    * Eep!  Lots of digits.  Right click on the labels to **Format Data Labels**
    * On the **Format Data Labels** menu, click **Number** and change from General to **Number** with **1 decimal place**
    * ![bar_12](/Day4/graph redos/bar_12.png)
    * On the **Font menu** (in **Home**) increase font size to **14 point**.
    * Change the font color to a grey.
    * Since we have value labels on the bars, we don't need numbers on the **y-axis**.  Click the y-axis and hit **delete**.
    * ![bar_13](/Day4/graph redos/bar_13.png)
    * ![bar_14](/Day4/graph redos/bar_14.png)
    * While we're getting rid of superfluous things, there's no reason for the _x-axis tick marks_.  Double click the **x-axis** and select **none** in the **major tick mark type**
    * ![bar_15](/Day4/graph redos/bar_15.png)
    *  Lastly, let's change the title to be a description of the y-axis. Click on "Title" and type "million deaths worldwide"
    *  Change the font to be **not bold**, **14 point**, and the same grey.
    *  Click and drag the label to sit near the label for neonatal diseases.
    *  ![bar_16](/Day4/graph redos/bar_16.png)
9.  Lastly, a bit of bar magic.  We want to highlight the pneumonia bar, since it's interesting.
    * Double click on thr bars to pull up the **Format Data Point** menu.
    * Under **Series Options** change the **Gap Width** to be **25%** to fatten the bars up.
    * Before you click okay, under **Fill** select **Solid Fill** and change to a grey.  Click close.
    * To select the pneumonia bar, single click the bars, then single click again the pneumonia one.  Right click and **Format Data point**
    * ![bar_17](/Day4/graph redos/bar_17.png)
    * ![bar_18](/Day4/graph redos/bar_18.png)
    * ![bar_19](/Day4/graph redos/bar_19.png)
    * Under **Fill** change to a nice blue.
    * You can do the same thing to the value label for the pneumonia bar (2.0). Select just the 2.0, and change the color to blue.
10.  Okay, last for real.  Get rid of the _border around the plot_
    * Click on the graph, then the **Format** tab under **Chart Tools**
    * Change the **Shape Outline** to **No outline**
    * ![bar_20](/Day4/graph redos/bar_20.png)
    
