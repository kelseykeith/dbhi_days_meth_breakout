

library(tidyverse)
library(ChAMP)



args = commandArgs(trailingOnly = T)

# Import data
myImport <- champ.import()

# Check data
#myImport$pd %>% head()

# Filter data
myImport_filtered <- champ.filter(myImport$beta,
                                # imputes the value of NAs in the beta table; why Teschendorf tables have no NAs
                                # Default is TRUE, but I don't think imputing is a good idea
                                autoimpute = TRUE,
                                # filter out probes where their p-value is greater than the threshold and 
                                # replace them with NA
                                filterDetP = TRUE,
                                # Remove probes with greater than the given proportion of failed signals. Think
                                # that 0 here means that any probe that failed in any of the samples will be 
                                # removed
                                ProbeCutoff = 1,
                                # Samples with more than the threshold (10% here) will be removed
                                SampleCutoff = 0.8,
                                # The detection p-value threshhold; if p-values for probes are above this 
                                # threshold the signal is considered poor quality / not real
                                detPcut = 0.05,
                                # Set probes with less than 3 beads to NA; if too many of the samples have NA at
                                # that probe the probe will be filtered from the output
                                filterBeads = TRUE,
                                # Ratio threshhold that a probe should be removed for failed in beadcount check
                                beadCutoff = 0.05,
                                # Removes non CG probes
                                filterNoCG = TRUE,
                                # Probes where the probed CG falls near a SNP that has been found to affect the
                                # reported beta value will be removed
                                filterSNPs = TRUE,
                                # Remove probes where the probe aligns to multiple locations
                                filterMultiHit = TRUE,
                                # All samples should be female, so shouldn't need to filer XY, default is TRUE 
                                filterXY = TRUE,
                                # Any value below 0 will be replaced as the minimum positive value and any value
                                # above 1 will be replaced as the maximum value below 1
                                fixOutlier = TRUE,
                                arraytype = '450K')

# Normalize data
myNorm <- champ.norm(myImport_filtered$beta, arraytype = '450K')
# check results with SVD
champ.SVD(beta = myNorm, 
          pd = myImport_filtered$pd)

# Save normalized data
myNorm %>% 
  as.data.frame() %>% 
  rownames_to_column('probe') %>% 
  write_tsv(args[1])

