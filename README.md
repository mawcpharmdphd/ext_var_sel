This repository includes commented SAS code to create simulations used in Variable Selection when Estimating Effects in External Target Populations. 
Both the code to generate and analyze the data are included.
The structure of the archive is simple. The main weight-based simulation code (simulating_variable_selection) and the companion code to conduct a g-formula style analysis (simulating_variable_selection_g_formula) are in the "Main" folder. 
All alternative scenarios are in separate folders corresponding to the changes that were made to the scenario.
The "Results" folder includes analytic code to combine results across the simulation replicates when examining a risk difference (results_RD) or risk ratio (results_RR).
Anyone interested in replicating the analyses will have to change the "LIBREF" codes accordingly.
