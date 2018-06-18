
# hydrostreamer 0.2.0

## Minor improvements and fixes

*   Column order in objects output by all function have been changed so that
    columns are always in the same order, starting from ID's. See individual 
    function reference to find the order.

*   Names of the ID's have been made uniform: in the output, columns with river
    segment ID's are now always "riverID", and grids "gridID".

*   Documentation has been (mostly) rewritten, and an error in the vignette has been 
    corrected. Examples have been added to almost all functions.

*   Functions have been moved to their own .R files which include the function
    and methods, if any.

*   Added simple checks for input arguments for all functions.

*   Added`verbose` (TRUE/FALSE) option to all functions to control wherther to print progress
    indication. By default, functions do not.



## Breaking changes

*   `compute_weights()` now always outputs an object of class *HSweights*. As
    a result, line-based weighting now outputs the original river network, not
    one which has been split at runoff polygon borders.
    
## New functions

*   `switch_grid()` can be used to safely switch the runoff input in a *HSweights*
    object without needing to recompute weights every time. The replacement has
    to include all features in the grid being replaced, with identical ID's.
    
*   `upstream()` can be used to identify all river segments which are upstream
    from a certain segment.
    
    