#' Compute weights for river catchment areas within the runoff area 
#' features. 
#' 
#' Computes weights for each individual river segment specific catchments 
#' falling in the areal units of the runoff \emph{HSgrid}. Function first 
#' takes a union between \emph{basins} and \emph{HSgrid} (creating new 
#' catchment units which fall inside only one runoff unit), and calculating 
#' the area for each individual catchment unit. The weight is assigned by 
#' dividing the area of sub-catchment with the area of runoff unit.
#' This function is called by \code{\link{compute_HSweights}}.
#'
#' @param basins An 'sf' polygon feature specifying the river segment 
#'   specific catchments.
#' @param riverID Column in \code{basins} containing unique IDs.
#' @param gridID Column in  \code{HSgrid} with unique IDs.
#' @inheritParams compute_HSweights
#'
#' @return Returns an 'sf' polygon feature (a union of basins, and HSgrid) 
#'   with added attributes (columns):
#'   \itemize{
#'     \item \emph{ID}. Unique ID of the feature.
#'     \item \emph{riverID}. ID of the river segment each sub-catchment is 
#'       associated to.
#'     \item \emph{gridID}. ID of the runoff unit the sub-catchment 
#'       is contained in.
#'     \item \emph{weights}. Weights computed for each sub-catchment.
#'     \item \emph{b_area_m2}. Area of the sub-catchment (basin) in 
#'       \eqn{m^2}.
#'     \item \emph{g_area_m2}. Area of the runoff unit sub-catchment is 
#'       contained in. In \eqn{m^2}.
#' }
#' 
#' @export
compute_area_weights <- function(basins, 
                                 HSgrid, 
                                 riverID = "riverID", 
                                 gridID = "gridID") {
    
    area_m2 <- NULL
    weights <- NULL
    ID <- NULL
    b_area_m2 <- NULL
    g_area_m2 <- NULL
    
    if(!any(names(basins) == riverID)) stop("riverID column '", 
                                            riverID, "' does not exist in basins input")
    if(!riverID == "riverID") basins <- dplyr::rename_(basins, 
                                                       riverID = riverID)  
    
    HSgrid <- HSgrid %>% dplyr::select(gridID, g_area_m2 = area_m2)
    
    basins <- suppressWarnings(
        suppressMessages(
            sf::st_intersection(basins,HSgrid)
        )
    )

    area <- sf::st_area(basins)
    
    # compute weight. unclass to get rid of the m^2 unit that gets 
    # carried over from area
    weight <- unclass(area)/unclass(basins$g_area_m2) %>%
        unclass()
    
    if (any(names(basins) == "weights")) {
        message("Replacing existing 'weights' column")
        basins <- dplyr::select(basins, -weights)
    }
    basins$weights <- weight
    
    #reorder and add columns 
    if (!any(names(basins) == "ID")) basins$ID <- 1:nrow(basins)
    basins$weights <- weight
    basins$b_area_m2 <- area
    basins <- basins %>% dplyr::select(ID, riverID, gridID, weights,
                                       b_area_m2, g_area_m2, 
                                       dplyr::everything())
    
    return(basins)
}
