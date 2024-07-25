### Meta ###

# Author: Andreas Hoehn
# Version: 1.0
# Date: 2024-07-23
# About: The main R code file of this short course

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [1]: Loading Data and Basic Benchmarking of Memory and Time ###

# [1.1] What is a data.table?
# [1.2] Benchmarking time
# [1.3] Benchmarking memory 

# ------------- # 

# [1.1] What is a data.table? Almost the same as a classic data.frame! 
# --> Let's look at one!

# load some data
dt_base   <- data.table::fread("RData/dt_base.csv")
dt_grades <- data.table::fread("RData/dt_grades.csv")

# how do they look?
dt_base
dt_grades

# how do they merge? The basic R merge performs quite well!
dt_base_grades <- base::merge(x  = dt_base,
                              y  = dt_grades,
                              by = c("id"))
dt_base_grades

# or if you want it even faster: dt_base_grades <- dt_base[dt_grades, on = "id"]
# gets even faster when datasets are sorted by the same key, for example "id"

# ------------- # 

# [1.2] Benchmarking time

# loading a data set is straightforward - but lets benchmark it!
# we work with microbenchmark::microbenchmark for this purpose

# via base R
microbenchmark::microbenchmark(
  read.csv(file = "RData/dt_base.csv"),
  unit = "seconds", times = 1) 

# via the tidyverse
microbenchmark::microbenchmark(
  readr::read_csv(file = "RData/dt_base.csv", show_col_types = FALSE),
  unit = "seconds", times = 1) 

# via the data.table function
microbenchmark::microbenchmark(
  data.table::fread(file = "RData/dt_base.csv"),
  unit = "seconds", times = 1) 

# ------------- # 

# [1.2] Benchmarking memory (RAM)

# let's look at our object - can the same information be saved differently?
dt_base

# how large is our object to start with
format(object.size(dt_base), unit = "Mb")    # ~ 19MB in RAM

# Can we reduce the dataset?
# convert id from numeric with integer as there is no need for decimals
# we do this with the basic data.table operator " := " which is "assignment by reference"
dt_base[, id    := as.integer(id)]
format(object.size(dt_base), unit = "Mb")   # ~ 15MB in RAM

# ------------- # 

# [1.3] Tracing the Location of Objects within Memory (RAM)

# this returns the address of the object 
tracemem(dt_base)

# let's create a new variable 
dt_base[, new_var := 99]
tracemem(dt_base)  # no change in location!

# we can even create a new dataset
dt_base2 <- dt_base
tracemem(dt_base)  == tracemem(dt_base)  # still no change in location!

# let's create a new variable the base R way!
dt_base$new_var <- 99    # tracemem flags changes in location right away
tracemem(dt_base)

# !TASK!: does this also happen with "%>%s" ?


# lets turn tracing off again
base::untracemem(dt_base)

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [2]: Basic data.table commands ###

# [2.1] How do I subset?
# [2.2] How do I create new variables?
# [2.3] How do I aggregate and return columns?
# [2.4] How do I aggregate and return columns by group?

# ------------- # 

# [2.1] How do we subset?

# the standard format for all commands is "data[subset, execute]"
# internal subsets will not alter the object!

# let's have a look at our dataset again
dt_base_grades

# subset (internal only, no new object is created, data object unchanged)
dt_base_grades[id == 1, ]              # subset where id is "1"
dt_base_grades[males == 0, ]           # subset where its a female 
dt_base_grades[id %in% dt_grades$id, ] # comparison with vectors: subset id match
dt_base_grades                         

# !TASK!: Subset - born in 21st century?


# subset and assign to a new object which will appear in the work space
# subsets will become permanent  if assigned to a new object (or the old object)
dt_base_grades_f <- dt_base_grades[males == 0, ]
dt_base_grades_f # a new object in which the subset of the old object is stored 
                 # old object will remain unchanged

# ------------- # 

# [2.2] How do we create new variables?

# reminder: the standard format for all commands is "data[subset, execute]"
# with data.table, new variables are created using the ":=" operation
# it's an assignment by reference - we already know what this means

# recode without subset: everybody took the exams 
dt_base_grades
dt_base_grades[, took_both := as.integer(1)]
dt_base_grades # everybody took the exam

# note: location in memory has not changed!
# try "tracemem(dt_base_grades)" before and after
# also compare with location after running "dt_base_grades$took_both <- as.integer(1)"

# recode with subset: not everybody passed the exams (means)
dt_base_grades[, passed_both := as.integer(0)]           # initialise 
dt_base_grades[exam_1 == 1 & exam_2 == 1, passed_both := 1]

# !TASK!: recode with subset - new variable for those who passed only the first
# ....

# ------------- # 

# [2.3] How do I aggregate and return columns?

# some basic return and assignment
# reminder: the standard format for all commands is "data[subset, execute]"
dt_base_grades[, .(median(bday))]                           # return the median of a variable
dt_base_grades[, .(median_bday = median(bday))]             # return the median of a variable with new col name
result_1 <- dt_base_grades[, .(median_bday = median(bday))] # return the median of a variable with new col name

# subsetting, aggregating and returning: how many passed?   --> ".N" is the fast count!
dt_base_grades[passed_both == 1, .(num_identified = .N)] 

# !TASK!: subsetting, aggregating and returning --> how many females passed both?
# ....

# ------------- # 

# [2.4] How do I aggregate and return columns by group?

# aggregating and returning for multiple groups separately can get tedious ... 
dt_base_grades[passed_both == 1, .(num_identified = .N)] # how many passed?
dt_base_grades[passed_both == 0, .(num_identified = .N)] # how many did not pass?

# solution: aggregate and return by group
# the standard format then changes to "data[subset, execute, by]"
dt_base_grades[, .(num_identified = .N), by = c("passed_both")] # how many did/ did not pass?

# solution: aggregate and return for multiple groups
# the standard format then changes to "data[subset, execute, by]"
dt_base_grades[, .(num_identified = .N), by = c("passed_both", "males")] 

# !TASK!: create a new object which captures how many born after 
# 2000/01/01 did pass / did not pass - by school
# ....

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [3]: More advanced data.table commands ###

# [3.1] from wide to long and setting keys
# [3.2] from long to wide

# ------------- # 

# [3.1] from wide to long

# this is classic wide format, quite often saving things in long format is more efficient
dt_grades_long <- data.table::melt(data = dt_grades, id.vars = c("id"))

# keying a data.table sorts the data rapidly
setkey(dt_grades_long, id)

# watch out - reshaping can create larger objects as an additional column is required 
format(object.size(dt_grades), unit = "Mb")
format(object.size(dt_grades_long), unit = "Mb")

# ------------- # 

# [3.2] from wide to long

# inspect the long-format dataset
dt_grades_long

# we want to reshape over id for the observation type captured in variable
# with the value indicated in the value column
dt_grades_wide <- data.table::dcast(data = dt_grades_long,
                                    formula = id ~ variable,
                                    value.var = c("value"))

dt_grades_wide  # they are both the same 
dt_grades       

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

# [BONUS] unintended changes in a second object through pointer to same address

# a data.table assignment does NOT create a deep copy 
dt_grades[, col_c := 999]
dt_grades2 <- dt_grades

# column appears in both
dt_grades
dt_grades2

# instead, the location in memory is the same (pointer to the same address)
tracemem(dt_grades)
tracemem(dt_grades2)

# this means that modifying one object modifies the second one as well
dt_grades2[, col_c := NULL]

dt_grades2
dt_grades

# only a deep copy can resolve that
dt_grades3 <- copy(dt_grades)
tracemem(dt_grades)
tracemem(dt_grades3) 

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #



