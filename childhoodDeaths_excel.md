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

3. Time to clean things up.  Easy things first: let's get rid of the _legend_.  We don't need it.  Click on it, hit delete, and instantly your graph is better.
![bar_04]()
4. Better. There's A LOT of grid lines, and they're dark.  Let's make them less dominant on the graph.
    * Click on the y grid lines (horizontal lines across the graph) and double click.
    * The **Format Major Gridlines** box will come up.  Select **Solid Line** and change the color.  I like the **15% grey**
    * Before you click "okay", click **Line Style**.  Change the line **width** to be 0.2 pt.  Thin and light focuses your eye on the data, not the grid lines.
![bar_05]()
![bar_06]()
5.
