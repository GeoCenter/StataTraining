/*-------------------------------------------------------------------------------
# Name:		TrainingSetup
# Purpose:	Download github repository and all data/examples for the training
# Author:	Tim Essam, Ph.D.
# Created:	2016/01/01
# Owner:	Tim Essam - USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
#-------------------------------------------------------------------------------
*/
clear

* --- Open Stata
* --- Change directory to where you will be working

* --- Cut and paste the following command into Stata
copy https://github.com/GeoCenter/StataTraining/archive/master.zip StataTraining.zip

* Unzip the contents of the file 
unzipfile StataTraining.zip

