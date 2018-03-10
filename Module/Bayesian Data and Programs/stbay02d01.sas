/* Uses the default settings for iterations */

proc mcmc data=sasuser.birth diag=all dic  
       plots(smooth)=all seed=27513;
   parms (beta0 beta1 beta2 beta3 beta4) 0;
   prior beta: ~ normal(0, var=100);
   p = logistic(beta0 + beta1*alcohol + beta2*hist_hyp + 
                beta3*mother_wt + beta4*prev_pretrm);
   model low ~ binary(p);
   title "Bayesian Analysis of Low Birth Weight Data";
run;

/* Specifies nbi, ntu, nmc, and thin */

proc mcmc data=sasuser.birth outpost=birthout diag=all dic  
     propcov=quanew nbi=5000 ntu=5000 nmc=400000 thin=10
     mchistory=brief plots(smooth)=all seed=27513 statistics=all;
   parms (beta0 beta1 beta2 beta3 beta4) 0;
   prior beta: ~ normal(0, var=100);
   p = logistic(beta0 + beta1*alcohol + beta2*hist_hyp + 
                beta3*mother_wt + beta4*prev_pretrm);
   model low ~ binary(p);
   title "Bayesian Analysis of Low Birth Weight Data";
run;

data birthout;
   set birthout;
   alc=(beta1 gt 0);
   hist=(beta2 gt 0);
   wt=(beta3 gt 0);
   pretrm=(beta4 gt 0);
run;

proc means data=birthout mean maxdec=8;
   var alc hist wt pretrm;
   title "Proportion of Parameter Estimates Greater than Zero"; 
run;

proc mcmc data=sasuser.birth outpost=birthout1 diag=all dic  
     propcov=quanew nbi=5000 ntu=5000 nmc=400000 thin=10   
     mchistory=brief plots(smooth)=all seed=27513 stats=all;
   parms (beta0 beta1 beta2 beta3 beta4) 0;
   prior beta1 ~ normal(1.0986,var=0.00116);
   prior beta0 beta2 beta3 beta4 ~ normal(0, var=100);
   p = logistic(beta0 + beta1*alcohol + beta2*hist_hyp + 
                beta3*mother_wt + beta4*prev_pretrm);
   model low ~ binary(p);
   title "Bayesian Analysis of Low Birth Weight Data";
run;

data plot;
   length plottype $ 14;
   set birthout birthout1(in=inform);
   if inform = 1 then plottype = "Informative";
   else plottype="Noninformative";
run;

proc sgpanel data=plot;
   panelby plottype;
   histogram beta1;
   title "Posterior Density Distribution by Informative and Noninformative Priors";
run;

