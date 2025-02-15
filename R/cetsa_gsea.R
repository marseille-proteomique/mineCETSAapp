#' compare_wp
#'
#' Function to run enrichment analysis on your hits from the wiki-pathway database and return
#' a plot that compare the pathways found between your conditions.
#'
#' @param hits A data.frame containing the genes id, a score value and preferably a condition column but not necessary.
#' @param gene_column The name of the coulumn that contains the genes. Default is 'Genes'.
#' @param score_column The name of the coulumn that contains the score values. Default is 'SR'.
#' @param condition_column The name of the column that contains the conditions. Default is NULL.
#' @param condition The name of the condition you ant to keep. Default is NULL.
#' @param pos_enrichment Logical to tell if you want to only look at positive enrichment score.
#'                       If FALSE, show only negative.
#'
#' @return A list that contains the results and the plot.
#'
#' @details For now, only Homo Sapiens is supported.
#'
#' @export
#'
#' @seealso \code{\link{clusterProfiler}}

cetsa_gsea <- function(hits, gene_column = "Genes", score_column = "SR",
                       condition_column = NULL, condition = NULL,
                       pos_enrichment = TRUE){
  ### load database
  wp <- get_wikipath() # wiki pathway
  ensembl <- biomaRt::useMart("ensembl", dataset = "hsapiens_gene_ensembl") # genes_id / gene symbols

  if(!is.null(condition_column) & !is.null(condition)){
    hits <- hits[which(hits[[condition_column]] == condition),]
  }
  if(any(is.na(hits[[score_column]]))){
    hits <- hits[which(!is.na(hits[[score_column]])),]
  }

  # get genes id from gene symbol
  hits_gene_id <- biomaRt::getBM(attributes = c("hgnc_symbol", "entrezgene_id"),
                                 filters = "hgnc_symbol",
                                 values = unique(sort(hits[[gene_column]])),
                                 bmHeader = TRUE,
                                 mart = ensembl)
  colnames(hits_gene_id) <- c(gene_column, "Genes_id")

  hits <- dplyr::left_join(hits, hits_gene_id, by = gene_column)
  if(any(is.na(hits$Genes_id))){
    hits <- hits[which(!is.na(hits$Genes_id)),]
  }
  hits$score <- hits[[score_column]]
  hits <- hits[, c("Genes_id", "score")]
  if(any(duplicated(hits$Genes_id))){
    hits <- hits[-which(duplicated(hits$Genes_id)),]
  }
  hits <- hits[order(hits$score, decreasing = TRUE),]
  hits <- as.data.frame(hits)
  rownames(hits) <- hits$Genes_id
  hits$Genes_id <- NULL

  hits <- unlist(as.list(as.data.frame(t(hits))))

  gsea_res <- clusterProfiler::GSEA(hits,
                                   TERM2GENE=wp[,c("wpid", "gene")],
                                   TERM2NAME=wp[,c("wpid", "name")],
                                   scoreType = "pos")

  gsea_res@result$geneSymbol <- unlist(lapply(strsplit(gsea_res@result$core_enrichment, "/"),
                                              function(x){x <- as.numeric(x)
                                              g <- hits_gene_id$Genes[which(!is.na(match(hits_gene_id$Genes_id, x)))]
                                              g <- paste(g, collapse = "/");
                                              g
                                              }
                                              )
                                       )

  if(pos_enrichment){
    if(length(which(gsea_res@result$enrichmentScore > 0))){
      graph <- enrichplot::gseaplot2(gsea_res,
                         geneSetID = which(gsea_res@result$enrichmentScore > 0))
    }
    else{
      message("All enrichment score are negative, showing those instead.")
      graph <- enrichplot::gseaplot2(gsea_res,
                         geneSetID = which(gsea_res@result$enrichmentScore < 0))
    }
  }
  else{
    if(length(which(gsea_res@result$enrichmentScore < 0))){
      graph <- enrichplot::gseaplot2(gsea_res,
                         geneSetID = which(gsea_res@result$enrichmentScore < 0))
    }
    else{
      message("All enrichment score are positive, showing those instead.")
      graph <- enrichplot::gseaplot2(gsea_res,
                         geneSetID = which(gsea_res@result$enrichmentScore > 0))
    }
  }

  return(list("res" = gsea_res@result, "graph" = graph))
}




# function to always get most recent wiki pathway database (update every 10 of month)
get_wikipath <- function(wp = TRUE){
  date <- stringr::str_split(Sys.Date(), "-")[[1]]
  date <- as.numeric(date)
  if(date[3] < 10){
    date[2] <- date[2] - 1
  }
  date[3] <- 10
  if(date[2] == 0){
    date[2] <- 12
    date[1] <- date[1] - 1
  }
  else if(date[2] < 10){
    date[2] <- paste0("0", date[2])
  }
  date <- paste0(date, collapse = "")

  url_wiki <- paste0("https://wikipathways-data.wmcloud.org/current/gmt/wikipathways-",
                     date, "-gmt-Homo_sapiens.gmt")
  url_wiki <- url(url_wiki)

  if(wp){
    wikipath <- clusterProfiler::read.gmt.wp(url_wiki)
  }
  else{
    wikipath <- clusterProfiler::read.gmt(url_wiki)
  }
  close(url_wiki)
  return(wikipath)
}
