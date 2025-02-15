% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/My_net.R
\name{My_net}
\alias{My_net}
\title{My_net}
\usage{
My_net(
  string_ids,
  payload_id = NULL,
  required_score = NULL,
  inter = FALSE,
  add_link = TRUE,
  network_flavor = "evidence",
  add_summary = TRUE
)
}
\arguments{
\item{string_ids}{The STRING ids of the proteins you want to plot the network}

\item{payload_id}{An identifier of payload data on the STRING server (see method post_payload
for additional informations)}

\item{required_score}{A threshold on the score that overrides the default score_threshold, that we use
only for the picture}

\item{inter}{A logical to tell if you want to return an interactive image with plotly}

\item{add_link}{Whether you want to generate and add a short link to the
relative page in STRING. As default this option is active but we suggest to deactivate it in case
one is generating many images (e.g. in a loop). Deactivating
this option avoids to generate and store a lot of short-urls on our server.}

\item{network_flavor}{Specify the flavor of the network
("evidence", "confidence" or "actions". default "evidence").}

\item{add_summary}{Parameter to specify whether you want to add a summary text to the picture.
This summary includes a p-value and the number of proteins/interactions.}
}
\value{
The network
}
\description{
Function to get the network from specific proteins. This function is totally based on the function plot_network from
the STRINGdb package, but it now return the plot (using ggdraw) or return an interactive image (using plotly).
}
\seealso{
\code{\link{STRINGdb}}
}
