################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 829 $
## $Date: 2010-11-08 09:02:56 +0100 (Mo, 08. Nov 2010) $
## $Author: nash $
## $Id: onlyObservationsFromAgeOrLess.R 829 2010-11-08 08:02:56Z nash $
##
################################################################################

onlyObservationsFromAgeOrLess <-
function(age, cohortDataset, dataColumn) {
## Trim a cohort dataset such that only cohorts observed from age or less
## are retained
##
## @inputs
## - age is the age from which cohorts must have been observed
## - cohortDataset is the dataset to trim
## - dataColumn is the field to look for NAs in
##
## @returns
## - the cohortDataset trimmed so that only cohorts with observations in the
##   dataColumn from age or lower are included

  ageCol <- if ("Age" %in% names(cohortDataset)) "Age" else if ("ARDY" %in% names(cohortDataset)) "ARDY"
  stopifnot(!is.null(ageCol))

  if (!is.numeric(cohortDataset[[ageCol]])) {
    cohortDataset[[ageCol]] <- as.numeric(sub("[+-]", "", as.character(cohortDataset[[ageCol]])))
  }
  
  # only cohorts for which we have non-NA data at age or less should be retained
  validCohorts <- unique(cohortDataset[cohortDataset[[ageCol]] <= age &
                         !is.na(cohortDataset[[dataColumn]]), "Cohort"])
  cohortDataset <- cohortDataset[cohortDataset$Cohort %in% validCohorts, ]
  
  # we may also need to trim the factor levels in the Cohort column
  if (is.factor(cohortDataset$Cohort)) {
    levels(cohortDataset$Cohort) <- ifelse(levels(cohortDataset$Cohort) %in% validCohorts,
                                    levels(cohortDataset$Cohort), NA)
  }

  return(cohortDataset)
}

