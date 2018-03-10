data Prior;
   input _TYPE_ $ alcohol1 hist_hyp mother_wt prev_pretrm;
datalines;
Mean 1.0986 0 0 0
Var 0.00116 1e6 1e6 1e6 
;
run;

proc genmod data=sasuser.birth desc;
    class alcohol(desc);
    model low = alcohol hist_hyp mother_wt prev_pretrm
                / dist=binomial link=logit;
	lsmeans alcohol / diff oddsratio plots=all cl;
    bayes seed=27513 coeffprior=normal(input=Prior) sampling=arms  
          outpost=bayes_prob1 plots(smooth)=all diag=all nmc=25000;
    title 'Bayesian Analysis of Low Birth Weight Model';
run;

data plot;
   length plottype $ 14;
   set bayes_prob bayes_prob1(in=inform rename=(alcohol1=alcohol));
   if inform = 1 then plottype = "Informative";
   else plottype="Noninformative";
run;

proc sgpanel data=plot;
   panelby plottype;
   histogram alcohol;
   title "Posterior Density Distribution by Informative and Noninformative Priors";
run;

