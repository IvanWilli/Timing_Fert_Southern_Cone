################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 867 $
## $Date: 2010-12-07 11:06:26 +0100 (Di, 07. Dez 2010) $
## $Author: nash $
## $Id: preprocessLexisTriangles.R 867 2010-12-07 10:06:26Z nash $
##
################################################################################

preprocessLexisTriangles <-
function(TRdata, shape, dataType, ...) {
## Preprocess a dataset of Lexis triangles ready for producing aggregated shape data
## The preprocessing performed is:
## - for VH, upper triangles in the first year and lower triangles in the last
##   year of data are discarded
## - for VV birth data, upper triangles in the oldest age have 1 added to their cohort
##   so that they will be merged with the lower triangle in the resulting parallelograms
##
## @inputs
## - TRdata is the Lexis triangle dataset
## - shape is one of
##      - "TR" for triangles (calendar year, age, birth cohort)
##      - "RR" for rectangles (calendar year, age in completed years)
##      - "VV" for vertical parallelograms (year of birth, age in completed years)
##      - "VH" for horizontal parallelograms (year of birth, age reached during year)
## - dataType is the type of data (typically "births" or "expos")
## - ... are named arguments which may be passed through to read.table
## @returns
## - the suitably processed triangle dataset

  if (!is.data.frame(TRdata)) TRdata <- .readInputData(TRdata, ...)
  
  # if data is from a HFD output file then the age series is topped and tailed
  # with open-ended RR: drop them so we only have triangle data left
  if (shape %in% c("VV", "VH")) {
    TRdata <- TRdata[!(is.na(TRdata$Cohort) | grepl("[+-]", TRdata$Age)), ]
    if (!is.numeric(TRdata$Age)) TRdata$Age <- as.numeric(as.character(TRdata$Age))
  }
  
  if (shape == "VH") {
    # for VH we discard upper triangles in the first year of data and lower
    # triangles in the last year of data

    # discard is a binary mask
    discard <- FALSE
    # upper triangles are those where Year - Age == Cohort + 1
    discard <- TRdata$Year == min(TRdata$Year) & TRdata$Year - TRdata$Age == TRdata$Cohort + 1
    # lower triangles are those where Year - Age == Cohort
    discard <- discard | TRdata$Year == max(TRdata$Year) & TRdata$Year - TRdata$Age == TRdata$Cohort
    # obviously only keep the rows which are not to be discarded!
    TRdata <- TRdata[!discard, ]
  } else if (shape == "VV" && dataType == "births") {
    # for VV the upper triangles for the max age (those for ARDY max + 1) need to be aggregated
    # to the vertical parallelogram "below" them (i.e. for ARDY max)
    # we can achieve this straightforwardly by temporarily adding 1 to the Cohort
    # value in these triangles so that it matches that in the lower triangle

    # upper triangles are those where Year - Age == Cohort + 1
    targetTR <- TRdata$Age == max(TRdata$Age) & TRdata$Year - TRdata$Age == TRdata$Cohort + 1
    TRdata[targetTR, "Cohort"] <- TRdata[targetTR, "Cohort"] + 1
  }
  
  return(TRdata)
}

