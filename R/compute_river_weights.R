#' Compute weights for river segments within runoff area features.
#' 
#' Computes weights for each individual river segments falling in the 
#' areal units of the runoff \emph{HSgrid}. Weight is computed from a 
#' numerical property of segments by \emph{x/sum(x)} where x are the 
#' river segments contained in a areal unit of runoff (\emph{HSgrid}). 
#' This function is called by \code{\link{compute_HSweights}}.
#' 
#' \emph{seg_weights} should be one of the following: "equal", "length", 
#'   "strahler", or a numeric vector which specifies the weight for each 
#'   river segment. 
#'   \itemize{
#'     \item \emph{equal} option assigns equal weights to all river segments 
#'       within a runoff unit.
#'     \item \emph{length} option weights river segments within a runoff unit 
#'       based on the length of the segment.
#'     \item \emph{strahler} option weights river segments based on the 
#'       Strahler number computed for the supplied river network.
#'     \item A numeric vector with length equal to the number of features 
#'       in \emph{river}. 
#' }
#' 
#' @param grid A \code{HSgrid} object or an \code{sf POLYGON} object used for
#'   areal interpolation.
#' @param seg_weights A character vector specifying type of weights, or a 
#'   numerical vector. See Details. Defaults to "length".
#' @param split Whether or not to use \code{\link{split_river_with_grid}} 
#'   before computing weights. Default is TRUE (assuming the river has not
#'   already been split)
#' @inheritParams compute_HSweights
#'
#'
#' @return Returns an 'sf' linestring object with attributes:
#'   \itemize{
#'     \item \emph{ID}. Unique ID of the feature.
#'     \item \emph{riverID}. ID of the river each segment is associated to.
#'     \item \emph{gridID}. ID of the runoff unit the river segment is contained in.
#'     \item \emph{weights}. Weights computed for each river segment.
#' }
#'   
#' @export
compute_river_weights <- function(river, 
                                  grid, 
                                  seg_weights = "length", 
                                  riverID = "riverID", 
                                  split=TRUE) {
    
    weights <- NULL
    ID <- NULL
    gridID <- NULL
    runoff_ts <- NULL

    if(!any(colnames(river) == riverID)) stop("riverID column '", 
                                           riverID, "' does not exist in river input")
    if(!riverID == "riverID") river <- dplyr::rename_(river, 
                                                      riverID = riverID)  
    
    if("runoff_ts" %in% colnames(grid)) grid <- dplyr::select(grid, -runoff_ts)

    #river <- dplyr::select_(river, riverID)
    if(seg_weights == "strahler") river <- river_hierarchy(river)
    if(split) river <- split_river_with_grid(river, 
                                             grid, 
                                             riverID = riverID)
    #get elements of rivers intersecting polygons
    riverIntsc <- suppressWarnings(suppressMessages(sf::st_contains(grid,river, 
                                                                    sparse=FALSE)))
    
    
    if (is.character(seg_weights)) {
        if(seg_weights == "length") {
            input <- sf::st_length(river) %>%
                unclass()
            
        } else if(seg_weights == "equal") {
            input <- seq(1,NROW(river))
            
        } else if(seg_weights == "strahler") {
            input <- river$STRAHLER
            
        } else {
            stop("Accepted values for weights are either 'length', 'equal', 
                 'strahler', or a vector of weights. Please check the input.")
        }
        
        
        weight <- apply(riverIntsc,1, compute_segment_weights, input)
        weight <- apply(weight,1, FUN=sum)
        weight <- unlist(weight)
        if (any(names(river) == "weights")) {
            message("Replacing existing 'weights' column")
            river <- dplyr::select(river, -weights)
        }
        
        
        
    } else if(is.vector(seg_weights)) {
        
        weight <- apply(riverIntsc,1, compute_segment_weights, seg_weights)
        weight <- apply(weight,1, FUN=sum)
        weight <- unlist(weight)
        
        if (any(names(river) == "weights")) {
            message("Replacing existing 'weights' column")
            river <- dplyr::select(river, -weights)
        }
        
        
    } else {
        stop("Accepted values for weights are either 'length', 'equal', 
             'strahler', or a vector of weights. Please check the input.")
    }
    
    river$weights  <- weight
    river <- river %>% 
        dplyr::select(ID, riverID, gridID, weights) %>%
        tibble::as_tibble(river) %>%
        sf::st_as_sf()
    return(river)
}
