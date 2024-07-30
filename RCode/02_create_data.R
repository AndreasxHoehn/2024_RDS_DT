### Meta ###

# Author: Andreas Hoehn
# Version: 1.0
# Date: 2024-07-30
# About: This file simulates us some data on final exams 

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

# define an "n" for easy scaleability
n <- 1e+6

# create baseline cohort
dt_base <- data.table::data.table(
  id    = seq(from = 1, to = n, by = 1),                     # "id": a running ID
  males = c(rep(x = 0, times = n/2),                         # "males": 0 - female,
            rep(x = 1, times = n/2)),                        #          1 - male
  bday  = sample(x = seq(from = base::as.Date("1980-01-01"), # "bday": some birthdays
                         to   = base::as.Date("2009-12-31"), 
                         by = "day"),
                 size = n, replace = TRUE),
  school = sample(x = c(1:10), size = n, replace = TRUE))    # "school": school ID 

# ------------- # 

# create some extra observations for linkage; exam results (worse for males than females)
dt_grades <- data.table::data.table(       
  id      = seq(from = 1, to = n, by = 1),              # "id": a running ID
  exam_1  = rbinom(n = n, size = 1, prob = 0.90),       # "exam_1/2": results 
  exam_2  = c(rbinom(n = n/2, size = 1, prob = 0.66),   # of exams with 0 being 
              rbinom(n = n/2, size = 1, prob = 0.33)))  # a fail

# ------------- # 

# save datasets
data.table::fwrite(dt_base,   "RData/dt_base.csv")
data.table::fwrite(dt_grades, "RData/dt_grades.csv")

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
