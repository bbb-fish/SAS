proc genmod data=sasuser.birth desc;
    model low = alcohol hist_hyp mother_wt prev_pretrm
                / dist=binomial link=logit;
	bayes seed=27513;
    title 'Bayesian Analysis of Low Birth Weight Model';
run;

ods select none;
proc genmod data=sasuser.birth desc;
    model low = alcohol hist_hyp mother_wt prev_pretrm
                / dist=binomial link=logit;
	bayes seed=27513 plots=none outpost=bayes_prob;
    title 'Bayesian Analysis of Low Birth Weight Model';
run;

ods select all;

proc print data=bayes_prob(obs=10);
   title "Line Listing of Generated Posterior Samples";
run;

data bayes_prob;
   set bayes_prob;
   alc=(alcohol gt 0);
   hist=(hist_hyp gt 0);
   wt=(mother_wt gt 0);
   pretrm=(prev_pretrm gt 0);
run;

proc means data=bayes_prob mean maxdec=8;
   var alc hist wt pretrm;
   title "Proportion of Parameter Estimates Greater than Zero"; 
run;

