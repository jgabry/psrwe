### Example of Section 4.1.
suppressMessages(library(psrwe, quietly = TRUE))
data(ex_dta)

### First parts of Data.
head(ex_dta)

### Obtain PSs.
dta_ps_single <- ps_rwe_est(ex_dta,
                     v_covs = paste("V", 1:7, sep = ""),
                     v_grp = "Group", cur_grp_level = "current",
                     ps_method = "logistic", nstrata = 5)

### Balance assessment of PS stratification.
plot(dta_ps_single, "balance")
plot(dta_ps_single, "ps")
plot(dta_ps_single, "diff")
plot(dta_ps_single, "diff", metric = "astd", avg_only = TRUE)

### Obtain discounting parameters.
ps_bor_single <- ps_rwe_borrow(dta_ps_single, total_borrow = 30)
ps_bor_single

### PSPP, single arm study, binary outcome.
options(mc.cores = 1)
.msg <- capture.output({ suppressWarnings({
rst_pp <- ps_rwe_powerp(ps_bor_single,
                        outcome_type = "binary",
                        v_outcome    = "Y_Bin",
                        seed         = 1234)
}) })
rst_pp

### Plot PSPP results.
plot(rst_pp)
plot(rst_pp, add_stratum = TRUE)

### 95% two-sided CI.
rst_pp <- ps_rwe_ci(rst_pp)
rst_pp

### Inference.
rst_pp <- ps_rwe_infer(rst_pp, mu = 0.4)
rst_pp

### Outcome analysis.
rst_pp_oa <- ps_rwe_outana(rst_pp)
rst_pp_oa

### PSCL, single arm study, binary outcome.
rst_cl <- ps_rwe_compl(ps_bor_single,
                       outcome_type = "binary",
                       v_outcome    = "Y_Bin")
rst_cl

### 95% two-sided CI.
rst_cl <- ps_rwe_ci(rst_cl)
rst_cl

### Inference.
rst_cl <- ps_rwe_infer(rst_cl, mu = 0.4)
rst_cl

