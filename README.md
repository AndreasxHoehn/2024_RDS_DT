# 2024_RDS_DT
 

## Pre-Requisits

Please note that this pipeline was not tested for network installations of R and/or cloud-based storage of files. 
The pipeline was created with R 4.4.1 (+ R Studio build 402). Please note that R's data.table package does not require 
any particular recent version of R and is highly backward-compatible (unlike some tidyverse packages).


## Folder Structure

This folder contains all course materials for the course in Edinburgh on 15/08/2024, including slides and data, and R Code. 
All materials can be downloaded as a bundled zip folder. You do not need a GitHub account to download materials. If you are 
a GitHub user, you can alternatively fork this repository.

`Slides/`: contains all slides either in power point or PDF format.

`RData/`: contains our example data sets - a simulated baseline cohort of N = 1,000,000 capturing some basic demographic 
information, alongside a separate file containing exam grades for the baseline cohort. The creation of the dataset is 
fully documented in the folder `RCode/02_create_data.R`. Please note that the dataset was already created and that it is not 
required to re-create it.

`RCode/`: contains all R code files in a reproducible pipeline format. 


## Running the Pipeline 

In order to run the pipeline, please open R-studio in project mode (double click on `2024_RDS_DT.Rproj` in the overarching folder). 
You can then open `RCode/01_main.R` to run all pre-requisits up to Line 40. It is then recommended to switch to open and run 
`RCode/03_computer_lab_session.R` and go through the examples step by step. 


## Feedback and Inquiries 

Please direct all questions and feedback to: andreas.hoehn@glasgow.ac.uk.

Please also let me know if you would be interested in this course being run for your organisation or team.