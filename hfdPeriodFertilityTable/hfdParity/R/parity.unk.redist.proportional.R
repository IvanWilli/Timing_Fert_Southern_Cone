################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 842 $
## $Date: 2010-11-09 16:49:10 +0100 (Di, 09. Nov 2010) $
## $Author: nash $
## $Id: parity.unk.redist.proportional.R 842 2010-11-09 15:49:10Z nash $
##
################################################################################

parity.unk.redist.proportional <-
function(parity, ...) {
## Redistributes females with unknown parity in populations by parity
## proportionally across all parity levels. Females with unknown age are
## unaffected.
##
## @inputs
## - parity is a data frame containing the parity data for a single year
## - ... is ignored (exists for compatibility)
## @returns
## - a data frame with the females with unknown parity redistributed
##   proportionally across all parity levels, RefCode set to -1 for
##   rows which have been adjusted and all UNK and TOT age and UNK, TOT and CHL
##   rows removed

  if (nrow(parity[parity$Parity == "UNK", ]) == 0) return(subset(parity, !(Parity %in% c("UNK", "TOT", "CHL") | Age %in% c("UNK", "TOT") | Cohort %in% c("UNK", "TOT"))))
  unks <- parity[parity$Parity == "UNK", ]
  for (unkRow in rownames(unks)) {
    unk <- unks[unkRow, ]
    if (((!is.na(unk$Age)) && unk$Age == "UNK") || ((!is.na(unk$Cohort)) && unk$Cohort == "UNK")) next()
    parsFilter <-
      (!(parity$Parity %in% c("UNK", "TOT", "CHL"))) &
        if (is.na(unk$Age)) {
          (!is.na(parity$Cohort)) & (parity$Cohort == unk$Cohort)
        } else if (is.na(unk$Cohort)) {
          (!is.na(parity$Age)) & (parity$Age == unk$Age)
        } else {
          (!is.na(parity$Cohort)) & (parity$Cohort == unk$Cohort) & (!is.na(parity$Age)) & (parity$Age == unk$Age)
        }
    parity[parsFilter, "Population"] <- parity[parsFilter, "Population"] + (unk$Population * (parity[parsFilter, "Population"] / sum(parity[parsFilter, "Population"], na.rm = TRUE)))
    parity[parsFilter, "RefCode"] <- -1
    parity[unkRow, "RefCode"] <- NA
  }
  parity[(parity$Age %in% c("UNK", "TOT")) | (parity$Parity %in% c("UNK", "TOT", "CHL")) | (parity$Cohort %in% c("UNK", "TOT")), "RefCode"] <- NA
  
  return(parity[!is.na(parity$RefCode), ])
  
}

