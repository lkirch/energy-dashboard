get_num_trees <- function(co2_metric_tons) {
  tree_ratio <- 0.039 # EPA: metric tons CO2 per uban tree planted
  num_trees <- ceiling(co2_metric_tons/tree_ratio)
  num_trees
}