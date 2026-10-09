# compute fertility tables for Southern Cone countries (ARG, BRA, CHL, URY) using HFD methodology

library(tidyverse)
library(colorspace)

# load hfdPeriodFertilityTable (Nash et al., 2011) ----------------------------------------------------------

sapply(list.files("R/hfdPeriodFertilityTable/hfdLexisManipulation/R", full.names = T), source)
sapply(list.files("R/hfdPeriodFertilityTable/hfdBasicIndicators/R", full.names = T), source)
sapply(list.files("R/hfdPeriodFertilityTable/hfdCohortFertilityTable/R", full.names = T), source)
sapply(list.files("R/hfdPeriodFertilityTable/hfdParity/R", full.names = T), source)
sapply(list.files("R/hfdPeriodFertilityTable/hfdPeriodFertilityTable/R", full.names = T), source)

# Uruguay ------------------------------------------
# 2011-2021: from Cabella, W., Pardo, I., Pedetti, G., & Fernández-Soto, M. (2024)
# 2022-2023 births by order: indirect estimate (GP) 

URYBirthsTR <- read.table("inputs/Uruguay/URYBirthsTR.txt",  header = TRUE, skip=0, na.strings = ".") %>% 
  arrange(Year, Age, Cohort) %>%
  # avoid implausible births at young ages
  mutate(B2 = ifelse(Age<17, 0, B2),
         B3 = ifelse(Age<18, 0, B3),
         B4 = ifelse(Age<19, 0, B4),
         B5p = ifelse(Age<20, 0, B5p),
         Total = B1 + B2 + B3 + B4 + B5p)
URYExposTR <- read.table("inputs/Uruguay/URYExposTR.txt", header = TRUE, skip=0, na.strings = ".") %>% 
  arrange(Year, Age, Cohort)
URYBirthsRR <- produceLexisShapes(URYBirthsTR, "RR", "births")
URYBirthsVV <- produceLexisShapes(URYBirthsTR, "VV", "births")
URYBirthsVH <- produceLexisShapes(URYBirthsTR, "VH", "births")
URYExposRR <- produceLexisShapes(URYExposTR, "RR", "expos")
URYExposVV <- produceLexisShapes(URYExposTR, "VV", "expos")
URYExposVH <- produceLexisShapes(URYExposTR, "VH", "expos")
URYasfrRR <- calculate.asfr(URYBirthsRR, URYExposRR, "RR")
URYmab <- calculate.mab(URYasfrRR, "RR")
URYasfrVV <- calculate.asfr(URYBirthsVV, URYExposVV, "VV")
URYtfr <- calculate.tfr(URYasfrRR, "RR") 
URYparity <- read.table("inputs/Uruguay/URYParity.txt",  header = TRUE,  sep = "\t",  na.strings = ".")
URYWeights <- parity.census.weights(URYparity)
URYWeights1J <- parity.1Jan.weights(URYWeights, URYasfrVV) 
URYgol <- calculateAgeParityDistribution.golden(URYBirthsTR, URYExposTR, URYWeights1J, goldenYear = 2011)
URYE <- calculate.E.pft(URYgol, URYExposRR)  
URYm <- calculate.m.pft (URYBirthsRR, URYE)
URYq <- calculate.q.pft (URYm)
URYpft <- calculate.pft(URYBirthsRR, URYExposRR, URYgol) 

# Argentina ----------------------------------------
# Births from MSAL, Population from WPP2024 and Parity from Census 2022

ARGExposTR <- read.table("inputs/Argentina/ARGExposTR.txt", header = TRUE, skip=0, na.strings = ".") %>% 
  filter(Year %in% 2010:2023) %>%
  mutate(Exposure = as.integer(Exposure)) %>% 
  arrange(Year, Age, Cohort)
ARGBirthsTR <- read.csv("inputs/Argentina/ARGBirthsTR.csv") %>% 
  mutate_all(as.integer) %>% replace(is.na(.), 0) %>% 
  rename(Cohort = Cohorte) %>% 
  mutate(Cohort = Cohort - 1) %>%  
  filter(Age %in% 12:55) %>% 
  mutate(B2 = ifelse(Age<17, 0, B2),
         B3 = ifelse(Age<18, 0, B3),
         B4 = ifelse(Age<19, 0, B4),
         B5p = ifelse(Age<20, 0, B5p),
         Total = B1 + B2 + B3 + B4 + B5p)
# guarantee same rows for births and exposures
ARGBirthsTR <- ARGExposTR %>% 
  distinct(Year, Age, Cohort) %>% 
  left_join(ARGBirthsTR, by = join_by(Year, Age, Cohort)) %>% 
  replace(is.na(.), 0)
ARGBirthsRR <- produceLexisShapes(ARGBirthsTR, "RR", "births")
ARGBirthsVV <- produceLexisShapes(ARGBirthsTR, "VV", "births")
ARGBirthsVH <- produceLexisShapes(ARGBirthsTR, "VH", "births")
ARGExposRR <- produceLexisShapes(ARGExposTR, "RR", "expos")
ARGExposVV <- produceLexisShapes(ARGExposTR, "VV", "expos")
ARGExposVH <- produceLexisShapes(ARGExposTR, "VH", "expos")
ARGasfrRR <- calculate.asfr(ARGBirthsRR, ARGExposRR, "RR")
ARGmab <- calculate.mab(ARGasfrRR, "RR")
ARGasfrVV <- calculate.asfr(ARGBirthsVV, ARGExposVV, "VV")
ARGtfr <- calculate.tfr(ARGasfrRR, "RR") 
ARGparity <- read.table("inputs/Argentina/ARGparity2010.txt", header = TRUE, skip=0, na.strings = ".") %>% 
  mutate_all(as.integer) %>% replace(is.na(.), 0) %>% 
  mutate(LDB = 1, PopName = "ARG") %>% 
  filter(Age>0)
ARGWeights <- parity.census.weights(ARGparity)
ARGWeights1J <- parity.1Jan.weights(ARGWeights, ARGasfrVV) 
ARGgol <- calculateAgeParityDistribution.golden(bTR = ARGBirthsTR, eTR = ARGExposTR, wiyT = ARGWeights1J, goldenYear = 2010)
ARGE <- calculate.E.pft(ARGgol, ARGExposRR)  
ARGm <- calculate.m.pft (ARGBirthsRR, ARGE)
ARGq <- calculate.q.pft (ARGm)
ARGpft <- calculate.pft(ARGBirthsRR, ARGExposRR, ARGgol)

# Chile ------------------------------------------
# 2017-2024: Births from INE, Population from WPP2024 and Parity from INE Census 2024

CHLBirthsTR <- read.table("inputs/Chile/CHLBirthsTR.txt",  header = TRUE, skip=0, na.strings = ".") %>% 
  arrange(Year, Age, Cohort) |> 
  mutate(B2 = ifelse(Age<17, 0, B2),
         B3 = ifelse(Age<18, 0, B3),
         B4 = ifelse(Age<19, 0, B4),
         B5p = ifelse(Age<20, 0, B5p),
         Total = B1 + B2 + B3 + B4 + B5p)
CHLExposTR <- read.table("inputs/Chile/CHLExposTR.txt", header = TRUE, skip=0, na.strings = ".") %>% 
  arrange(Year, Age, Cohort) %>% 
  filter(Year %in% unique(CHLBirthsTR$Year))
# guarantee same rows for births and exposures
CHLBirthsTR  <- CHLExposTR %>% 
  distinct(Year, Age, Cohort) %>% 
  left_join(CHLBirthsTR) %>% 
  replace(is.na(.), 0)
CHLBirthsRR <- produceLexisShapes(CHLBirthsTR, "RR", "births")
CHLBirthsVV <- produceLexisShapes(CHLBirthsTR, "VV", "births")
CHLBirthsVH <- produceLexisShapes(CHLBirthsTR, "VH", "births")
CHLExposRR <- produceLexisShapes(CHLExposTR, "RR", "expos")
CHLExposVV <- produceLexisShapes(CHLExposTR, "VV", "expos")
CHLExposVH <- produceLexisShapes(CHLExposTR, "VH", "expos")
CHLasfrRR <- calculate.asfr(CHLBirthsRR, CHLExposRR, "RR")
CHLmab <- calculate.mab(CHLasfrRR, "RR")
CHLasfrVV <- calculate.asfr(CHLBirthsVV, CHLExposVV, "VV")
CHLtfr <- calculate.tfr(CHLasfrRR, "RR") 
CHLparity <- read.csv("inputs/Chile/CHIparity2017.txt", header = TRUE, na.strings = ".") %>% 
  mutate(LDB = 1, AgeInt = 1, Access = 99, Note1 = 99, Note2 = 99, Note3 = 99, RefCode = 99, CohInt = 1, Area = 1)
CHLWeights <- parity.census.weights(CHLparity)
CHLWeights1J <- parity.1Jan.weights(CHLWeights, CHLasfrVV) 
CHLgol <- calculateAgeParityDistribution.golden(CHLBirthsTR, CHLExposTR, CHLWeights1J, goldenYear = 2017)
CHLE <- calculate.E.pft(CHLgol, CHLExposRR)  
CHLm <- calculate.m.pft (CHLBirthsRR, CHLE)
CHLq <- calculate.q.pft (CHLm)
CHLpft <- calculate.pft(CHLBirthsRR, CHLExposRR, CHLgol) 

# 2010-2016: add HFD computations. From "https://www.humanfertility.org/File/GetDocument/Files/CHL/20250130/CHLpft.txt"
CHLpft_hfd <- read.table("inputs/Chile/CHLpft.txt", skip = 2, header = T)
CHLpft_hfd_2010a2016 <- CHLpft_hfd %>%
  mutate(x = case_when(x == "12-" ~ "12", x == "55+" ~ "55", T ~ x)) %>% 
  mutate(m2x = ifelse(x<17, 0, m2x),
         m3x = ifelse(x<18, 0, m3x),
         m4x = ifelse(x<19, 0, m4x),
         m5px = ifelse(x<20, 0, m5px)) |> 
  filter(Year %in% 2010:2016)
names(CHLpft_hfd_2010a2016) <- names(CHLpft)
CHLpft <- rbind(CHLpft, CHLpft_hfd_2010a2016) %>% 
  mutate_all(as.numeric) %>% 
  replace(is.na(.), 0) %>% 
  mutate(x = ifelse(x == 0, 12, x)) %>% 
  arrange(Year, x)
# get tfr from HFD for taht period
CHLtfr_hfd_2010a2016 <- read.table("inputs/Chile/CHLtfrRRbo.txt", skip = 2, header = T) %>% 
  filter(Year %in% 2010:2016)
CHLtfr <- rbind(CHLtfr_hfd_2010a2016, CHLtfr)
# get no conditionated ASFR from HFD for that period
CHLasfr_hfd <- read.table("inputs/Chile/CHLasfrRRbo.txt", skip = 2, header = T)
CHLasfr_hfd_2010a2016 <- CHLasfr_hfd %>%
  mutate(Age = case_when(Age == "12-" ~ "12", Age == "55+" ~ "55", T ~ Age)) %>% 
  filter(Year %in% 2010:2016)
names(CHLasfr_hfd_2010a2016) <- names(CHLasfr_hfd)
CHLasfrRR <- rbind(CHLasfr_hfd, CHLasfr_hfd_2010a2016) %>% 
  rename(x = Age) %>% 
  mutate_all(as.numeric) %>% 
  replace(is.na(.), 0) %>% 
  mutate(x = ifelse(x == 0, 12, x)) %>% 
  arrange(Year, x)

# Brasil ------------------------------------------------------------------
# Births from INE, Population from WPP2024 and Parity from INE Census 2024

BRABirthsTR <- read.table("inputs/Brasil/BRABirthTR.txt",  header = TRUE, skip=0, na.strings = ".") %>%
  rename(Cohort = Cohorte) %>% 
  arrange(Year, Age, Cohort) %>%
  mutate_all(as.integer) %>% 
  replace(is.na(.), 0) %>%
  mutate(B2 = ifelse(Age<17, 0, B2),
         B3 = ifelse(Age<18, 0, B3),
         B4 = ifelse(Age<19, 0, B4),
         B5p = ifelse(Age<20, 0, B5p),
         Total = B1 + B2 + B3 + B4 + B5p)
BRAExposTR <- read.table("inputs/Brasil/BRAExposTR.txt", header = TRUE, skip=0, na.strings = ".") %>% 
  arrange(Year, Age, Cohort) %>% 
  filter(Year %in% unique(BRABirthsTR$Year))
# guarantee same rows for births and exposures
BRABirthsTR  <- BRAExposTR %>% 
  distinct(Year, Age, Cohort) %>% 
  left_join(BRABirthsTR) %>% 
  replace(is.na(.), 0)
BRABirthsRR <- produceLexisShapes(BRABirthsTR, "RR", "births")
BRABirthsVV <- produceLexisShapes(BRABirthsTR, "VV", "births")
BRABirthsVH <- produceLexisShapes(BRABirthsTR, "VH", "births")
BRAExposRR <- produceLexisShapes(BRAExposTR, "RR", "expos")
BRAExposVV <- produceLexisShapes(BRAExposTR, "VV", "expos")
BRAExposVH <- produceLexisShapes(BRAExposTR, "VH", "expos")
BRAasfrRR <- calculate.asfr(BRABirthsRR, BRAExposRR, "RR")
BRAmab <- calculate.mab(BRAasfrRR, "RR")
BRAasfrVV <- calculate.asfr(BRABirthsVV, BRAExposVV, "VV")
BRAtfr <- calculate.tfr(BRAasfrRR, "RR") 
BRAparity <- read.csv("inputs/Brasil/BRAparity2010.csv")
BRAWeights <- parity.census.weights(BRAparity)
BRAWeights1J <- parity.1Jan.weights(BRAWeights, BRAasfrVV) 
BRAgol <- calculateAgeParityDistribution.golden(BRABirthsTR, BRAExposTR, BRAWeights1J, goldenYear = 2010)
BRAE <- calculate.E.pft(BRAgol, BRAExposRR)  
BRAm <- calculate.m.pft (BRABirthsRR, BRAE)
BRAq <- calculate.q.pft (BRAm)
BRApft <- calculate.pft(BRABirthsRR, BRAExposRR, BRAgol) 

# save all results ----------------------------------------------------------

siglas <- c("ARG", "CHL", "BRA", "URY")
lista_por_pais <- setNames(
  lapply(siglas, function(s) {
    objs <- ls(envir = .GlobalEnv, pattern = paste0("^", s))
    mget(objs, envir = .GlobalEnv)}),
  siglas)
lista_por_pais |> save(file = "outputs/results.rda")



