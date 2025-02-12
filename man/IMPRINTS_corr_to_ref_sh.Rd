% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IMPRINTS_corr_to_ref_sh.R
\name{IMPRINTS_corr_to_ref_sh}
\alias{IMPRINTS_corr_to_ref_sh}
\title{IMPRINTS_corr_to_ref_sh}
\usage{
IMPRINTS_corr_to_ref_sh(
  data = NULL,
  set = NULL,
  treatment = NULL,
  reference = NULL,
  use_score = c("euclidean", "pearson"),
  score_threshold = 0.9,
  include_neg = FALSE,
  max_na = 0
)
}
\arguments{
\item{data}{Dataset after calculating the relative protein abundance differences and deriving the average of the profile,
ie IMPRINTS_average_sh, make sure the columns with readings are named in the format like "(Set_)37C_Treatment"}

\item{set}{A single character to indicate the sample name, if any}

\item{treatment}{A single character to indicate the sample name}

\item{reference}{A numeric vector with the profile readings}

\item{use_score}{A single character element that define the method score. Method available : 'euclidean' or 'pearson'}

\item{score_threshold}{A numeric value to indicate the threshold, default set to 0.9}

\item{include_neg}{Whether to include the negatively correlated proteins, default set to FALSE}

\item{max_na}{An integer indicating the maximun number of missing value for one protein, default is 0.}
}
\value{
A dataframe with the correlation from the profile and the proteins which passed the threshold
}
\description{
Function to generate 2D bar plot and pdf file with multipanel bar plots for 2D-CETSA data of
proteins which have similar profile from a selected protein.
It is totally based on the function ms_2D_barplotting from the mineCETSA package.
}
