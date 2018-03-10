proc means data=sasuser.miss_birth nmiss;
   var low mother_wt alcohol prev_pretrm hist_hyp;
   title 'Variables with Missing Values';
run;

data miss_birth;
   set sasuser.miss_birth;
   if mother_wt = . then m_weight=1;
      else m_weight=0;
   if alcohol = . then m_alcohol = 1;
      else m_alcohol = 0;
run;

proc freq data=miss_birth;
   tables m_weight*m_alcohol;
   title 'Variables with Missing Values';
run;

ods select histogram;
proc univariate data=sasuser.miss_birth;
   var mother_wt;
   histogram mother_wt / lognormal;
run;

ods select histogram;
proc univariate data=sasuser.miss_birth;
   var alcohol;
   histogram alcohol / midpoints=0 1;
run;

proc mcmc data=sasuser.miss_birth outpost=missbirthout diag=all   
     propcov=quanew nbi=10000 ntu=5000 nmc=300000 thin=10 
     mchistory=brief plots(smooth)=all seed=27513 statistics=all;
   parms (gamma0 gamma1 gamma2) 0;
   parms (alpha0 alpha1 alpha2 alpha3) 0;
   parms (beta0 beta1 beta2 beta3 beta4) 0;
   parms sigma2 1;
   prior gamma: alpha: beta: ~ normal(0, var=100);
   prior sigma2 ~igamma(shape=2.001, scale=1.001);
   p1 = logistic(gamma0 + gamma1*hist_hyp + gamma2*prev_pretrm);
   model alcohol ~ binary(p1) monitor=(1 2 10);
   mu = alpha0 + alpha1*alcohol + alpha2*hist_hyp + alpha3*prev_pretrm;
   model mother_wt ~ lognormal(mu,var=sigma2) monitor=(random (3));
   p = logistic(beta0 + beta1*alcohol + beta2*hist_hyp + 
                beta3*mother_wt + beta4*prev_pretrm);
   model low ~ binary(p);
   title "Bayesian Analysis of Low Birth Weight Data";
run;

data mweight (keep= mother_wt_miss);
   set missbirthout;
   array weights{*} mother_wt_:;
   do i=1 to dim(weights);
      mother_wt_miss=weights(i);
      output;
   end;
run;

ods select histogram;
proc univariate data=mweight;
   var mother_wt_miss;
   histogram mother_wt_miss / lognormal;
run;

data malcohol (keep= alcohol_miss);
   set missbirthout;
   array alcohols{*} alcohol_:;
   do i=1 to dim(alcohols);
      alcohol_miss=alcohols(i);
      output;
   end;
run;

ods select histogram;
proc univariate data=malcohol;
   var alcohol_miss;
   histogram alcohol_miss / midpoints= 0 1;
run;

