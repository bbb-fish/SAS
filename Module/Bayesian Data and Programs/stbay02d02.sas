ods select none;
proc mcmc data=sasuser.birth plots=none seed=27513  
     propcov=quanew nbi=5000 ntu=5000 nmc=400000 thin=10 stats=all;
   parms (beta0 beta1 beta2 beta3 beta4) 0;
   prior beta1 ~ normal(1.0986,var=0.00116);
   prior beta0 beta2 beta3 beta4 ~ normal(0, var=100);
   p = logistic(beta0 + beta1*alcohol + beta2*hist_hyp + 
                beta3*mother_wt + beta4*prev_pretrm);
   model low ~ binary(p);
   preddist outpred=pred stats=summary;
   ods output predsummaries=prediction_summaries;
run;
ods select all;

proc print data=prediction_summaries(obs=10);
    title "Posterior Summaries of Predicted Values of the Response Variable";
run;

proc print data=pred(obs=10);
   var low_1-low_10;
   title "Random Samples from the Posterior Predictive Distribution";
run;

data pred;
   set pred;
   iter_mean = mean(of low:);
run;

proc means data=sasuser.birth noprint;
   var low;
   output out=stat mean=sample_mean;
run;
 
data _null_;
   set stat;
   call symput('sample_mean',sample_mean);
run;

data _null_;
   set pred end=eof nobs=nobs;
   ctmean + (iter_mean>&sample_mean);
   if eof then do;
      pmean=ctmean/nobs; 
      call symput('pmean',pmean);
   end;
run;

proc sgplot data=pred;
   histogram iter_mean / nbins=20;
   refline &sample_mean / axis=x lineattrs=(color=blue thickness=3);
   xaxis values=(.1 to .5 by .1) label="Predicted Means";
   inset "posterior predictive p-value = &pmean";
   title1 "Histogram of Predicted Probabilities";
   title2 "Reference Line Represents Actual Probability";
run;

data new_birth;
  input mother_wt alcohol prev_pretrm hist_hyp;
datalines;
 125  1  1  0  
 130  0  0  0  
 187  1  0  0  
 175  0  1  1  
 185  0  0  0
;

ods select none;
proc mcmc data=sasuser.birth plots=none seed=27513  
     propcov=quanew nbi=5000 ntu=5000 nmc=400000 thin=10;
   parms (beta0 beta1 beta2 beta3 beta4) 0;
   prior beta1 ~ normal(1.0986,var=0.00116);
   prior beta0 beta2 beta3 beta4 ~ normal(0, var=100);
   p = logistic(beta0 + beta1*alcohol + beta2*hist_hyp + 
                beta3*mother_wt + beta4*prev_pretrm);
   model low ~ binary(p);
   preddist outpred=scored covariates=new_birth stats(percent=50)=summary;
   ods output predsummaries=scored_summaries;
run;
ods select all;

proc print data=scored_summaries;
   title "Posterior Summaries of Scored Observations";
run;



