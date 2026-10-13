#!/usr/bin/env Rscript

n_cpus <- parallel::detectCores()

# Bioconductor release matching the R version in the Dockerfile
# (R 4.4 -> Bioconductor 3.19). Change both together.
bioc_version <- "3.19"

#---- CRAN packages -----------------------------------------------------------

pkgs_cran <- c("BiocManager", "gtools", "scales")

install.packages(pkgs_cran, repos = getOption("repos"), Ncpus = n_cpus)

#---- Bioconductor packages ---------------------------------------------------

pkgs_bioc <- c("DESeq2", "apeglm", "tximport")

# update = FALSE keeps CRAN dependencies at the rocker snapshot versions
BiocManager::install(
  pkgs_bioc,
  version = bioc_version,
  ask = FALSE,
  update = FALSE,
  Ncpus = n_cpus
)

#---- Check -------------------------------------------------------------------

# install.packages() only warns on failure, so fail the build explicitly
missing <- setdiff(c(pkgs_cran, pkgs_bioc), rownames(installed.packages()))

if (length(missing) > 0) {
  stop("Failed to install: ", paste(missing, collapse = ", "))
}

cat(" > All packages installed successfully.\n")
