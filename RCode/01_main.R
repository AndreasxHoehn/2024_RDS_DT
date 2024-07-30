### Meta ###

# Author: Andreas Hoehn
# Version: 1.0
# Date: 2024-07-30
# About: The main R code file of this short course

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### Preparation ###

# clean workspace
rm(list = ls())  # remove all objects from work space 
gc(full = TRUE)  # deep clean garbage

# set seed 
set.seed(20240725) 

# install packages if required 
# install.packages(c("parallel","microbenchmark", "tidyverse","data.table"))

# libraries
library(parallel)
library(microbenchmark)
library(data.table)
library(tidyverse)

# identify and set the correct number of cores for running data.table parallel
parallel::detectCores()
data.table::getDTthreads()
data.table::setDTthreads(percent = 100)

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### Source Actual Files ###
# source("RCode/02_create_data.R")         # simulates some data on school exams
source("RCode/03_computer_lab_session.R")  # this file contains our examples 

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
