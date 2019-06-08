library(haven)
library(dplyr)

# Import data from SAS
sm201_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/232sm201/adpnfh.sas7bdat")
sm201_adpnfh_csf <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/232sm201/adpnfhcsf.sas7bdat")
sm202_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/232sm202/adpnfh.sas7bdat")
sm202_adpnfh_csf <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/232sm202/adnfhcsf.sas7bdat")

# cs1_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/cs1/adpnfh.sas7bdat")
# cs2_cs12_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/cs2-cs12/adpnfh.sas7bdat")
# cs10_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/cs10/adpnfh.sas7bdat")

cs3b_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/cs3b/adpnfh.sas7bdat")
cs3b_adpnfh_csf <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/cs3b/adnfhcsf.sas7bdat")
cs3b_adnfl <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/cs3b/adnfl.sas7bdat")
cs4_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/cs4/adpnfh.sas7bdat")

# non_sma_adpnfh <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/non-sma/adpnfh.sas7bdat")
# non_sma_adnfl <- read_sas("/camhpc/project/SMA_Biomarker_Biometrics/data/non-sma/adnfl.sas7bdat")
