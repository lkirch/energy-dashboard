# energy-dashboard
uConserve Home Energy Dashboard
=========

##Project Description and Goals
Given that the number of people in the world is rapidly increasing as well as the number of consumer electronics households own, we can expect increased demand for energy and subsequently an increased carbon footprint.  How can we encourage consumers to decrease their energy consumption?  Currently there are disparate reports and data that exist, but are not presented in a coherent manner in order to show people what resources their homes are using, how their usage compares with others, and how they can make concrete changes in their behavior to achieve cost savings, reduce their carbon footprint, and reduce their demand of scarce resources.  By putting all of this information together in one easy place and giving consumers actionable advice, municipalities can work toward reaching mandated goals for clean air quality, meet energy demand, and more efficiently use our scarce resources.

Our goal is to drive awareness and conservation of the world’s natural resources through compelling analytics, insightful visualizations, and targeted, actionable conservation recommendations.

The uConserve dashboard is the manifestation of our mission in the form of a web application, an in-home wall unit device, and a tablet application that allows users to see, understand, and intelligently change their resource consumption habits
  
##Project Scope
* To build in as much live, open source data into the home energy dashboard as possible in a clean, intuitive, usable manner. 
* Be able to make a significant impact on how people view their energy consumption and offer them actionable ways to reduce or more efficiently use their scarce resources.
* Illustrate what their homes are using, compare with others, highlight potential savings, leaks, and waste points in the system.  
* Show consumers’ electricity, gas, and water usage as well as their carbon footprint.  
* Compare with median electricity, gas, and water usage statistics.  
* Show total YTD, monthly, and daily costs.  
* If possible, break down costs by appliance and flag appliances or watering devices that may be leaking or could be turned off. 
* 

###Behavioral Research
![uConserve Behavioral Research](/web-deliverable/uConserve/img/portfolio/uConserve-BehavioralResearch.png?raw=true "uConserve Behavioral Research")

![uConserve Thought Process](/web-deliverable/uConserve/img/portfolio/uConserve-ThoughtProcess.png?raw=true "uConserve Thought Process")

![uConserve Project Flow](/web-deliverable/uConserve/img/portfolio/uConserve-Mindmap.png?raw=true "uConserve Project Flow")
 
##Datasets
* Pecan Street Inc. Dataport 2015 - the world’s largest source of circuit level, disaggregated and whole-home electricity use data, smart water meter data, smart natural gas meter data, time-stamped weather data, and metadata and annual participant survey data of 1,200+ individual residences in Texas, California, and Colorado - https://dataport.pecanstreet.org
* CoolClimate API from UC Berkeley's CoolClimate Network - http://coolclimate.berkeley.edu/api
* US Environmental Protection Agency Clean Energy Calculations and References - http://www.epa.gov/cleanenergy/energy-resources/refs.html

##Development and Analysis Tools
* Data was stored in postgreSQL running on a SoftLayer ubuntu server.
* R and python were used to analyze the data and create statistical analysis, forecasts, and appliance analysis of resource usage.
* The pipeline was hooked into a shiny server to generate dynamic displays.

![uConserve Data Sources and Tools](/web-deliverable/uConserve/img/portfolio/uConserve-data-sources-tools.png?raw=true "uConserve Data Sources and Tools")

##User Experience
* Initial Idea
![uConserve Initial Idea](/web-deliverable/uConserve/img/portfolio/uConserve-InitialMockupSketch.jpg?raw=true "uConserve Initial Idea")

* Website
![uConserve Web - Homepage](/web-deliverable/uConserve/img/portfolio/uConserve-Web-Homepage.png?raw=true "uConserve Web - Homepage")
![uConserve Web - Electricity](/web-deliverable/uConserve/img/portfolio/uConserve-Web-Electricity.png?raw=true "uConserve Web - Electricity")
![uConserve Web - Rankings](/web-deliverable/uConserve/img/portfolio/uConserve-Web-Rankings.png?raw=true "uConserve Web - Rankings")

* In-Home Wall Device
![uConserve Wall Unit](/web-deliverable/uConserve/img/portfolio/uConserve-Wall-Unit.png?raw=true "uConserve Wall Unit")

* Tablet Version 
![uConserve Tablet Version](/web-deliverable/uConserve/img/portfolio/uConserve-Tablet-Version.png?raw=true "uConserve Tablet Version")


##Web Design
* For mockups we used [UXPin](http://uxpin.com).
* For our project description page we used a Bootstrap template ([Agency](http://startbootstrap.com/template-overviews/agency/) by [Start Bootstrap](http://startbootstrap.com/)) for our webpage design.
* A prototype website was created with weebly - http://energy-dashboard.weebly.com.

##Link to Project
http://groups.ischool.berkeley.edu/uconserve/

##Forecasting Analysis
* We used ARIMA models to predict energy usage for each between today and the end of the month. This allowed us to provide real-time predictions for the end-of-month bill.

* Model performance was very strong. Tested on 3 separate users for days in winter and summer, our model predicted within 3 kWh of the day’s actual usage.

* Summed at the month level (for bill prediction), we had an error rate of less than 1%.

* We optimized our ARIMA model by grid searching on two primary parameters: the auto-regressive term, and the moving average term.

* Providing accurate end-of-month predictions allows the user to feel confident in the number they are working against. They can set goals and see how they performed against the prediction when the end of the month comes around.

* For our “don’t water” recommendation, we looked at precipitation predictions for the following 5 days. Weather data was provided along with electricity usage data in the Pecan Street dataset.

##[Usage Analysis](http://energy-dashboard.weebly.com/technology-blogs/behind-the-scene-technology)

##[Anomaly Detection](http://energy-dashboard.weebly.com/technology-blogs/appliance-detection)

##Limitations
* Unfortunately not every home in the US has meters on all of their resources.
* Some customers do not have data complete data for all 3 resources - electricity, water, and natural gas.  This made finding large enough comparison samples difficult sometimes. 
