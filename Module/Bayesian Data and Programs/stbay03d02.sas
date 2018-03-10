proc mcmc data=sasuser.magnesium diag=all dic propcov=quanew nbi=5000 stats=all
     ntu=5000 nmc=650000 plot(smooth)=all thin=15 seed=27513 mchistory=brief
     monitor=(diff rel_risk log_or mu1 mu0 s0 s1) outpost=meta;
   array p0[9];
   array p1[9];
   parms mu0 0.5 mu1 0.5 tau0 1 tau1 1;
   parms p1: 0.5 p0: 0.5;
   prior mu: ~ beta(1,1);
   prior tau: ~ gamma(2,iscale=1);
   prior p1: ~ beta(a1,b1);
   prior p0: ~ beta(a0,b0);
   beginnodata;
       a1=mu1*tau1;
	   b1=(1-mu1)*tau1;
	   a0=mu0*tau0;
       b0=(1-mu0)*tau0;
	   s0=sqrt(mu0*(1-mu0)/(1+tau0));
       s1=sqrt(mu1*(1-mu1)/(1+tau1));
       diff=mu1-mu0;
       rel_risk=mu1/mu0;
	   log_or=log((mu1*(1-mu0))/(mu0*(1-mu1)));
   endnodata;
   model rt ~ binomial(nt,p1[trial]);
   model rc ~ binomial(nc,p0[trial]);
   title "Bayesian Analysis of Meta-Analysis of Magnesium Clinical Trial Data";
run;

data mean_treatment (keep=mu1) mean_control (keep=mu0);
   set meta;
run;

data boxplot;
   set mean_treatment (in=treat) mean_control (in=control);
   if treat then do;
      mean = mu1;
	  group='treatment';
   end;
   if control then do;
      mean = mu0;
	  group='control';
   end;
run;

proc sgplot data=boxplot;
   vbox mean / category=group;
   title "Distribution of Population Means by Treatment Group";
run;
