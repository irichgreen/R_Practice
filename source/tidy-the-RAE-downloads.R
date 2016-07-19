 #  Copyright 2015 David Firth (University of Warwick).
 #  Permission to use, copy, modify and distribute this software and
 #  its documentation, for any purpose and without fee, is hereby granted,
 #  provided that:
 #  1) this copyright notice appears in all copies and
 #  2) the source is acknowledged through a citation to the paper
 #     Varin C., Cattelan M. and Firth D. (2015). Statistical modelling of citation
 #     exchange between statistics journals. Journal of the Royal Statistical Society
 #     Series A, to appear.
 #  The Author makes no representation about the suitability of this software
 #  for any purpose.  It is provided "as is", without express or implied warranty.

## TIDYING OF THE DATA FROM DOWNLOADED FILES
## "RA2.csv" AND "Institution.csv"
##------------------------------------------

## We remove various columns that will not 
## be used here, and insert 999 for the missing
## "Institution" code on entries for the joint RAE 
## submission made by Edinburgh and Heriot-Watt:

RA2 <- RA2[, c("Institution", "OutputType", "Publisher")]
RA2$Institution[is.na(RA2$Institution)] <- "999"

## Now select only the `Journal Article' RAE output type:

RA2.ja <- RA2[RA2$OutputType == "D", c("Institution", "Publisher") ]

## To the list of RAE institution codes,
## add our own 999 code for "Edinburgh+HW"
## and delete two superfluous institutions 
## that have non-numeric codes:

institutions[160, ] <- c("999", "Edinburgh+HW", NA)
institutions <- institutions [-(36:37), ]
## Next line just strips leading zeros on institution codes
institutions$Institution <- as.character(as.numeric(
    institutions$Institution))
row.names(institutions) <- institutions$Institution

## Use institution /names/ instead of numbers in RA2.ja,
## and remove redundant levels:
RA2.ja$Institution <- institutions[as.character(RA2.ja$Institution),
                                   "InstitutionName"]
RA2.ja$Institution <- factor(as.character(RA2.ja$Institution))

 
