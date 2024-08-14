### Meta ###

# Author: Andreas Hoehn
# Version: 1.0
# Date: 2024-08-14
# About: The  R code file of this short course setting up all pre-requisites 
# Run until L40, then switch to file 'RCode/03_computer_lab_session.R'

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
parallel::detectCores()                   # how many cores?
data.table::getDTthreads()                # how many currently used by dt?
data.table::setDTthreads(percent = 100)   # lets ramp this up
data.table::getDTthreads()                # let's check again

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### Source Actual Files ###
# source("RCode/02_create_data.R")         # simulates some data on school exams
source("RCode/03_computer_lab_session.R")  # this file contains our examples 

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
