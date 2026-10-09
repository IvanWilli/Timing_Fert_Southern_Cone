################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 842 $
## $Date: 2010-11-09 16:49:10 +0100 (Di, 09. Nov 2010) $
## $Author: nash $
## $Id: parity.unk.redist.allToZero.R 842 2010-11-09 15:49:10Z nash $
##
################################################################################

parity.unk.redist.allToZero <-
function(parity, ...) {
## Redistributes females with unknown parity in populations by parity
## to parity 0. Females with unknown age are unaffected.
##
## @inputs
## - parity is a data frame containing the parity data for a single year
## - ... is ignored (exists for compatibility)
## @returns
## - a data frame with the females with unknown parity redistributed
##   to parity 0 and Note3 set to -1 for rows which have been affected

  if (nrow(parity[parity$Parity == "UNK", ]) == 0) return(subset(parity, !(Parity %in% c("UNK", "TOT", "CHL") | Age %in% c("UNK", "TOT") | Cohort %in% c("UNK", "TOT"))))
  unks <- parity[parity$Parity == "UNK", ]
  for (unkRow in rownames(unks)) {
    unk <- unks[unkRow, ]
    if (((!is.na(unk$Age)) && unk$Age == "UNK") || ((!is.na(unk$Cohort)) && unk$Cohort == "UNK")) next()
    parsFilter <-
      parity$Parity == 0 & 
        if (is.na(unk$Age)) {
          (!is.na(parity$Cohort)) & (parity$Cohort == unk$Cohort)
        } else if (is.na(unk$Cohort)) {
          (!is.na(parity$Age)) & (parity$Age == unk$Age)
        } else {
          (!is.na(parity$Cohort)) & (parity$Cohort == unk$Cohort) & (!is.na(parity$Age)) & (parity$Age == unk$Age)
        }
    parity[parsFilter, c("Population", "RefCode")] <- c(parity[parsFilter, "Population"] + unk$Population, -1)
    parity[unkRow, "RefCode"] <- NA
  }
  parity[(parity$Age %in% c("UNK", "TOT")) | (parity$Parity %in% c("UNK", "TOT", "CHL")) | (parity$Cohort %in% c("UNK", "TOT")), "RefCode"] <- NA

  return(parity[!is.na(parity$RefCode), ])
}

