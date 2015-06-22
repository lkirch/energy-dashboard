
# coding: utf-8

# Process per-minute KW usage data for home
# Behavioral questions:
# - Air conditioner usage hours: check Weekday work hours and weekend work hours. 
# - When are the high usage hours
# - When are low usage hours
# - Frequency of refrigerator usage
# - Frequency of air conditioner usage

# In[1]:

import os
import numpy as np
from pandas import Series, DataFrame
import pandas as pd
from datetime import datetime
import matplotlib
import matplotlib.pyplot as plt
from sklearn.cluster import MiniBatchKMeans
from sklearn.cluster import DBSCAN
#Matplot configuration
get_ipython().magic(u'matplotlib inline')
matplotlib.rcParams.update({'font.size': 22})
colorlist = ['g', 'c', 'm', 'y','g', 'c', 'm', 'y', 'g', 'c', 'm', 'y', 'g', 'c', 'm', 'y' ]

os.chdir("C:/Users/nitpatwa/Google Drive/data science/w210/project/pecan/energy-dashboard/data/")
#print os.getcwd()


# In[2]:

dfElec = pd.read_table("2013-elec-id-6673.csv", sep=';')
#dfElec = pd.read_table("2013-elec-7531.csv", sep=';')
#dfElec = pd.read_table("2013-elec-3723-pv.csv", sep=';')
#print dfElec
dfElec = dfElec.fillna(0)
dfElec['localminute']= dfElec['localminute'].map(lambda x: x[0:19])
#print dfElec['localminute'][0]

# convert other columns into meaningful data: get label for circuit responsible for max contribution


# In[3]:

#Pick two columns from DataFrame - they will become Series
use = dfElec['use']
localdatetime = dfElec['localminute']
print type(use), type(localdatetime)

#Series is a dictionary, so values can be extracted
#convert series's values list into Panda date/time object list

datevalues = pd.to_datetime(localdatetime.values)
print type(datevalues)
print type(use.values)
#create a TimeSeries with use-values as data and datavalues as index
tsElec = Series(use.values, index=datevalues)
print type(tsElec)

# hourly 
tsHourly = tsElec.resample('H', how='sum', closed='left', label='left')/60
# ts.at_time(time(10,0)) will have info at that time only
# ts.between_time((time(10,0), time(11,0)) will have info in that window only

# weekday
tsDaily = tsHourly.resample('D', how='sum', closed='left', label='left')
# Weekly
tsWeekly = tsDaily.resample('W-MON', how='sum', closed='left', label='right')
# Monthly
tsMonthly = tsDaily.resample('M', how='sum', closed='left', label='right')

# groupby means
XHourlyG = tsHourly.groupby(lambda x: x.hour).sum()  # creates panda series
XWeekdayG = tsHourly.groupby(lambda x: x.weekday).sum()

# break into seasons and plot on each hour on each weekday. 
# seasons based on monthly graphs
tsWinter = tsHourly['2013-01':'2013-03'].append(tsHourly['2013-12'])
tsSpring = tsHourly['2013-04':'2013-06-14']
tsSummer = tsHourly['2013-06-15':'2013-09-14']
tsFall = tsHourly['2013-09-15': '2013-11']

WinterHourlyG = tsWinter.groupby(lambda x: x.hour).sum()  # creates panda series
WinterWeekdayG = tsWinter.groupby(lambda x: x.weekday).sum()
SpringHourlyG = tsSpring.groupby(lambda x: x.hour).sum()  # creates panda series
SpringWeekdayG = tsSpring.groupby(lambda x: x.weekday).sum()
SummerHourlyG = tsSummer.groupby(lambda x: x.hour).sum()  # creates panda series
SummerWeekdayG = tsSummer.groupby(lambda x: x.weekday).sum()
FallHourlyG = tsFall.groupby(lambda x: x.hour).sum()  # creates panda series
FallWeekdayG = tsFall.groupby(lambda x: x.weekday).sum()
# crosscheck

print tsElec.sum()/60
print tsDaily.sum()
print tsWeekly.sum()
print tsMonthly.sum()
print XHourlyG.sum()
print XWeekdayG.sum()
print (tsWinter.sum() + tsSpring.sum() + tsSummer.sum() + tsFall.sum())

print XWeekdayG
print WinterWeekdayG
print SpringWeekdayG
print SummerWeekdayG
print FallWeekdayG


# In[4]:

# plot the values
fig0 = plt.figure(figsize=(50,50))
ax0=fig0.add_subplot(7,1,1)
ax1=fig0.add_subplot(7,1,2)
ax2=fig0.add_subplot(7,1,3)
ax3=fig0.add_subplot(7,1,4)
ax4=fig0.add_subplot(7,1,5)
ax5=fig0.add_subplot(7,1,6)
ax6=fig0.add_subplot(7,1,7)

tsElec.plot(ax=ax0, title="per-minute")
tsHourly.plot(ax=ax1, title="Hourly")
tsDaily.plot(ax=ax2, title="Daily")
tsWeekly.plot(ax=ax3, title="Weekly")
tsMonthly.plot(ax=ax4, title="Monthy")
XHourlyG.plot(ax=ax5, title="HourlyGroup")
XWeekdayG.plot(ax=ax6, title="WeekdayGroup")





# WinterHourlyG.plot(data, kind='line', ax=None, figsize=None, use_index=True, title=None, grid=None, legend=False, style=None, logx=False, logy=False, loglog=False, xticks=None, yticks=None, xlim=None, ylim=None, rot=None, fontsize=None, colormap=None, table=False, yerr=None, xerr=None, label=None, secondary_y=False, **kwds)
# Make plots of Series using matplotlib / pylab.
# 
# Parameters
# ----------
# data : Series
# 
# kind : str
#     - 'line' : line plot (default)
#     - 'bar' : vertical bar plot
#     - 'barh' : horizontal bar plot
#     - 'hist' : histogram
#     - 'box' : boxplot
#     - 'kde' : Kernel Density Estimation plot
#     - 'density' : same as 'kde'
#     - 'area' : area plot
#     - 'pie' : pie plot
#     
# ax : matplotlib axes object
#     If not passed, uses gca()
# figsize : a tuple (width, height) in inches
# use_index : boolean, default True
#     Use index as ticks for x axis
# title : string
#     Title to use for the plot
# grid : boolean, default None (matlab style default)
#     Axis grid lines
# legend : False/True/'reverse'
#     Place legend on axis subplots
# style : list or dict
#     matplotlib line style per column
# logx : boolean, default False
#     Use log scaling on x axis
# logy : boolean, default False
#     Use log scaling on y axis
# loglog : boolean, default False
#     Use log scaling on both x and y axes
# xticks : sequence
#     Values to use for the xticks
# yticks : sequence
#     Values to use for the yticks
# xlim : 2-tuple/list
# ylim : 2-tuple/list
# rot : int, default None
#     Rotation for ticks (xticks for vertical, yticks for horizontal plots)
# fontsize : int, default None
#     Font size for xticks and yticks
# colormap : str or matplotlib colormap object, default None
#     Colormap to select colors from. If string, load colormap with that name
#     from matplotlib.
# colorbar : boolean, optional
#     If True, plot colorbar (only relevant for 'scatter' and 'hexbin' plots)
# position : float
#     Specify relative alignments for bar plot layout.
#     From 0 (left/bottom-end) to 1 (right/top-end). Default is 0.5 (center)
# layout : tuple (optional)
#     (rows, columns) for the layout of the plot
# table : boolean, Series or DataFrame, default False
#     If True, draw a table using the data in the DataFrame and the data will
#     be transposed to meet matplotlib's default layout.
#     If a Series or DataFrame is passed, use passed data to draw a table.
# yerr : DataFrame, Series, array-like, dict and str
#     See :ref:`Plotting with Error Bars <visualization.errorbars>` for detail.
# xerr : same types as yerr.
# label : label argument to provide to plot
# secondary_y : boolean or sequence of ints, default False
#     If True then y-axis will be on the right
# mark_right : boolean, default True
#     When using a secondary_y axis, automatically mark the column
#     labels with "(right)" in the legend
# kwds : keywords
#     Options to pass to matplotlib plotting method
# 
# Returns
# -------
# axes : matplotlib.AxesSubplot or np.array of them
# 
# Notes
# -----
# 
# - See matplotlib documentation online for more on this subject
# - If `kind` = 'bar' or 'barh', you can specify relative alignments
#   for bar plot layout by `position` keyword.
#   From 0 (left/bottom-end) to 1 (right/top-end). Default is 0.5 (center)

# In[5]:

fig0 = plt.figure(figsize=(50,20))
ax0=fig0.add_subplot(1,1,1)
WinterHourlyG.plot(ax=ax0, title="HourlyGroup", legend='Winter')
SpringHourlyG.plot(ax=ax0, title="HourlyGroup", legend='Spring')
SummerHourlyG.plot(ax=ax0, title="HourlyGroup", legend='Summer')
FallHourlyG.plot(ax=ax0, title="HourlyGroup", legend='Fall')

fig1 = plt.figure(figsize=(50,20))
ax4=fig1.add_subplot(1,1,1)

WinterWeekdayG.plot(ax=ax4, title="WeekdayGroup")
SpringWeekdayG.plot(ax=ax4, title="WeekdayGroup")
SummerWeekdayG.plot(ax=ax4, title="WeekdayGroup")
FallWeekdayG.plot(ax=ax4, title="WeekdayGroup")


# In[6]:

#Histogram of values
fig1 = plt.figure(figsize=(50,50))
ax0=fig1.add_subplot(5,1,1)
ax1=fig1.add_subplot(5,1,2)
ax2=fig1.add_subplot(5,1,3)
ax3=fig1.add_subplot(5,1,4)
ax4=fig1.add_subplot(5,1,5)

tsElec.hist(bins=1000, ax=ax0, color=colorlist[0])
tsHourly.hist(bins=1000, ax=ax1, color=colorlist[1])
tsDaily.hist(bins=16, ax=ax2, color=colorlist[2])
tsWeekly.hist(bins=8, ax=ax3, color=colorlist[3])
tsMonthly.hist(bins=4, ax=ax4, color=colorlist[4])


# In[95]:

print "Your average usage at any minute is equivalent of ", int(10*tsElec.mean()), " 100W lightbulbs"
print "Yearly Power KWH", int(tsElec.sum()/60)
print "Monthly KWH"
print "Jan:", int(tsElec['2013-01'].sum()/60)
print "Feb:", int(tsElec['2013-02'].sum()/60)
print "Mar:", int(tsElec['2013-03'].sum()/60)
print "Apr:", int(tsElec['2013-04'].sum()/60)
print "May:", int(tsElec['2013-05'].sum()/60)
print "Jun:", int(tsElec['2013-06'].sum()/60)
print "Jul:", int(tsElec['2013-07'].sum()/60)
print "Aug:", int(tsElec['2013-08'].sum()/60)
print "Sep:", int(tsElec['2013-09'].sum()/60)
print "Oct:", int(tsElec['2013-10'].sum()/60)
print "Nov:", int(tsElec['2013-11'].sum()/60)
print "Dec:", int(tsElec['2013-12'].sum()/60)
#print tsMonthly

print
print "Minute Statistics"
print tsElec.describe()
print 
print "Hourly Statistics"
print tsHourly.describe()
#print "Weekday Statistics", tsweekday.describe()
#print "Hourly Statistics", tsHourly.describe()



# In[8]:

day = '2013-08-01'

X = np.reshape(tsElec[day].values, (-1, 1))
print X.shape[0], X.shape[1]
print tsElec[day].describe()
dbs = DBSCAN(eps=0.3, min_samples=5)
dbs.fit(X)
print len(set(dbs.labels_))

print X[dbs.labels_ == -1]

fig0 = plt.figure(figsize=(20,20))
ax0=fig0.add_subplot(4,1,1)

tsElec[day].plot(ax=ax0, title="Daily TimeSeries")


# In[8]:




# In[9]:

X = np.reshape(tsElec.values, (-1, 1))
print X.shape[0], X.shape[1]
print X.sum()/60

# Clustering of values
num_comp = 5 # ASK - KMEANS IS NOT CAPTURING THE HIGH VALUE USAGE. WHAT IS WRONG?
k_means = MiniBatchKMeans(n_clusters=num_comp)

k_means.fit(X)
print k_means.cluster_centers_
lv = k_means.cluster_centers_

# Convert individual values into cluster centers
Y = k_means.predict(X)
#print lv.shape, Y
Xnew = lv[Y]


#check total error
print Xnew.sum()/60, "% error", 100*(Xnew.sum()-X.sum())/X.sum()

#Get a new series and plot it.
tsElecNew = Series(np.reshape(Xnew, -1), index=datevalues)


# In[9]:




# In[10]:

fig0 = plt.figure(figsize=(50,50))
ax0=fig0.add_subplot(6,1,1)
ax1=fig0.add_subplot(6,1,2)

tsElec.plot(ax=ax0, title="per-minute")
tsElecNew.plot(ax=ax1, title="KMeans-quantized per minute")


# In[11]:

fig = plt.figure(figsize=(40,40))
ax1=fig.add_subplot(2,2,1)
ax2=fig.add_subplot(2,2,2)
ax3=fig.add_subplot(2,2,3)
ax4=fig.add_subplot(2,2,4)

tsElec['2013-01-15'].plot(ax=ax1, title='winter')
tsElec['2013-04-15'].plot(ax=ax2, title='spring')
tsElec['2013-07-15'].plot(ax=ax3, title='summer')
tsElec['2013-10-15'].plot(ax=ax4, title='fall')


# In[12]:

fig = plt.figure(figsize=(40,20))
ax1=fig.add_subplot(2,2,1)
ax2=fig.add_subplot(2,2,2)
ax3=fig.add_subplot(2,2,3)
ax4=fig.add_subplot(2,2,4)

tsElec['2013-08-01 00' : '2013-08-01 05'].plot(ax=ax1, title='night hours')
tsElec['2013-08-01 06' : '2013-08-01 11'].plot(ax=ax2, title='morning hours')
tsElec['2013-08-01 12' : '2013-08-01 17'].plot(ax=ax3, title='afternoon hours')
tsElec['2013-08-01 22' : '2013-08-01 22'].plot(ax=ax4, title='evening hours')


# In[12]:




# plot quickstart guide
# fig = plt.figure()  # figure object
# ax1 = fig.add_subplot(2,2,1) # first plot of a 2x2 grid
# ax2 = fig.add_subplot(2,2,2) # second plot of a 2x2 grid
# ax3 = fig.add_subplot(2,2,3) # third plot
# ax1.hist(randn(100), bins=20, color='k', alpha=0.3)
# ax2.scatter(np.arange(30), np.arange(30 +3*randn(30)))
# ax3.plot(x, y, color='g')
# ax.set_title('my plot')
# ax.set_xlabel('x label')
# ax.set_xticks([0, 100, 200, 300])
# 
# 
# fig, axes = plt.subplot(nrows, ncols)

# In[13]:

#Histogram has 4 modes. So break tsElec series into 4 bins and analyze each one
# want to create 4 series, each having same time-index, but separate bins.
# Could also create a dataFrame with 4 columns.
# How does one go from series to frame?

ts1 = tsElec.where(tsElec < 1.7)
ts2 = tsElec.where((tsElec >= 1.7) & (tsElec < 3))
ts3 = tsElec.where((tsElec >= 3) & (tsElec < 5))
ts4 = tsElec.where((tsElec >= 5) & (tsElec < 100))

sumall = tsElec.sum()/60
sum1 = ts1.sum()/60
sum2 = ts2.sum()/60
sum3 = ts3.sum()/60
sum4 = ts4.sum()/60

print "Total Power KWH:", sumall, "% contribution:", 100*sum1/sumall, 100*sum2/sumall, 100*sum3/sumall, 100*sum4/sumall
 


# In[14]:

fig0 = plt.figure(figsize=(25,25))
ax0=fig0.add_subplot(1,1,1)


ts1.plot(ax=ax0)
ts2.plot(ax=ax0)
ts3.plot(ax=ax0)
ts4.plot(ax=ax0)
    


# In[47]:

#Change and duration detection
tsShifted = tsElec.shift(1, freq='min')

print tsElec[1:]
print tsShifted[0:-1]

#tsChange= np.divide(tsElec, tsShifted)
#tsChange = tsChange.map(lambda x: 1.0 if ((x > 0.83) & (x < 1.2)) else x) # ternary expressions
#print tsChange.count()


# In[105]:

#print diff(tsElec.index, tsShifted.index)
tsFrame = DataFrame({'tsElec':tsElec[1:].values, 'tsShifted':tsShifted[0:-1].values}, index=tsElec.index[1:])
tsFrame['same'] =  ((tsFrame['tsElec']/tsFrame['tsShifted'] > 0.83) & (tsFrame['tsElec']/tsFrame['tsShifted'] < 1.2)) 
tsFrame['value'] = (~tsFrame['same'])*(tsFrame['tsElec'] - tsFrame['tsShifted']) # change values
#print tsFrame

#how to smooth the values within 20%?
def rounder(x):
    if (abs(x) < 0.5):
        y = round(x,1)
    elif (abs(x) < 1.5): 
        y = round(x,1)
    else:
        y = round(x)
    return y
# outlist = (starttime, value, duration)

values = tsFrame['value']
valuesrounded = values.map(lambda x: rounder(x))
valuesnonzero = valuesrounded[valuesrounded != 0]
print len(values), len(valuesnonzero)
print valuesnonzero.describe()

fig1 = plt.figure(figsize=(50,50))
ax0=fig1.add_subplot(1,1,1)
valuesnonzero.hist(bins=100, ax=ax0, color=colorlist[1])

#how to convert it into (time, change-value, duration-in-minute)?

outlist1 = []
outlist2 = []
zerolen = 0
pastnonzero1 = 0
pastnonzero2 = 0

for i in range(len(valuesrounded)):
    if (valuesrounded[i] == 0):
        zerolen += 1
    else:
        outlist1.append([i, pastnonzero1, zerolen])  # separate line for every change
        pastnonzero1 = valuesrounded[i]

        if (zerolen > 0):
            outlist2.append([i, pastnonzero2, zerolen])
            pastnonzero2 = valuesrounded[i]
        else:
            pastnonzero2 = valuesrounded[i] + pastnonzero2  # accumulate change over multiple minutes
        zerolen = 0

print outlist1, outlist2
# how to seperate above into summer and not summer


# In[96]:




# In[ ]:



