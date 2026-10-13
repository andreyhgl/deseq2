[![Build and Release Docker Container](https://github.com/andreyhgl/deseq2/actions/workflows/build-release.yml/badge.svg)](https://github.com/andreyhgl/deseq2/actions/workflows/build-release.yml)

A **rocker/r-ver:4.4.0** container with [DESeq2](https://bioconductor.org/packages/DESeq2/) R-package (and some dependencies). Used for differential gene expression analysis of RNA-seq.

> [!NOTE] 
> The Bioconductor release is tied to the R version. When bumping
> `rocker/r-ver` in the `Dockerfile`, update `bioc_version` to match
> (see [Bioconductor releases](https://bioconductor.org/about/release-announcements/)). The build fails if any package is not
> installed.

<details>
  <summary>Included softwares</summary>

  + R 4.4.0 (Bioconductor 3.19)
  + DESeq2
  + apeglm
  + tximport
  + gtools
  + scales
  + git
  + less
  + procps (needed for Nextflow)
</details>

## Pull the container

```sh
# docker
docker pull ghcr.io/andreyhgl/deseq2:main

# apptainer / singularity
apptainer pull docker://ghcr.io/andreyhgl/deseq2:main
singularity pull docker://ghcr.io/andreyhgl/deseq2:main
```

## Run interactively

```sh
# docker
docker run -it --rm -v $(pwd):/data ghcr.io/andreyhgl/deseq2:main

# apptainer / singularity
apptainer shell docker://ghcr.io/andreyhgl/deseq2:main
singularity shell docker://ghcr.io/andreyhgl/deseq2:main
```

## Include inside a nextflow process

```groovy
process PROCESS_NAME {

  . . .

  container "${workflow.containerEngine == 'singularity' ?
    'docker://ghcr.io/andreyhgl/deseq2:main' :
    'ghcr.io/andreyhgl/deseq2:main'}"

  . . .
}
```

The container definition uses an [elvis operator](https://www.nextflow.io/docs/latest/reference/syntax.html#unary-expressions) = `<statement> ? <TRUE> : <FALSE>`

## Build locally

```sh
git clone https://github.com/andreyhgl/deseq2.git
cd deseq2
docker build -t deseq2 .
```

---

### Dockerfile details

`Dockerfile` runs the content inside `install.R`, which holds all R-packages. Edit this file in order to add more packages: **CRAN** packages goes into `pkgs_cran` and **Bioconductor** packages into `pkgs_bioc`.

```dockerfile
# Dockerfile

. . .

COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R

. . .
```

```r
# install.R

. . .

bioc_version <- "3.19"

pkgs_cran <- c("BiocManager", "gtools", "scales")

install.packages(pkgs_cran, repos = getOption("repos"), Ncpus = n_cpus)

pkgs_bioc <- c("DESeq2", "apeglm", "tximport")

BiocManager::install(
  pkgs_bioc,
  version = bioc_version,
  ask = FALSE,
  update = FALSE,
  Ncpus = n_cpus
)

. . .
```