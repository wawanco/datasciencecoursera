---
title: "Getting and Cleaning Data Course Project"
author: "Thibault Rodriguez"
---

Dependencies:
dplyr

unzip file in working dir
assume dir name "UCI HAR Dataset" in wd
Inertial Signals not used

First read
Merge X, y and subject indpendently using rbind()
then merge X, y and subject together unsing c bing to create a unique DS
first clean each column separately:
-> add column name for subjects
-> add collumn name for x
-> remove unused x colum
-> define y as a categorical variable 
-> replace y levels  by labels
-> rename y colomun with more explicit label : activity

As indicated in features info, mean (resp. std) measurements have the following structure : <measure>-mean() (or <measure>-std())
I build the regexp that recognize these patterns and select only the resulting columns.
