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

![uConserve Behavioral Research](/web-deliverable/uConserve/img/portfolio/uConserve-BehvioralResearch.png?raw=true "uConserve Behavioral Research")

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

##Web Design
* For mockups we used uxpin.com.
* For our project description page we used a Bootstrap template ([Agency](http://startbootstrap.com/template-overviews/agency/) by [Start Bootstrap](http://startbootstrap.com/)) for our webpage design.
* A prototype website was created with weebly - http://energy-dashboard.weebly.com.

##Link to Project
http://groups.ischool.berkeley.edu/uconserve/

##Limitations
* Unfortunately not every home in the US has meters on all of their resources.
* Some customers do not have data complete data for all 3 resources - electricity, water, and natural gas.  This made finding large enough comparison samples difficult sometimes. 
