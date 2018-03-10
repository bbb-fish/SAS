data toy;
   set sasuser.toy;
   if adhesive = 'a' then adhesivebeta = 1;
   if adhesive = 'b' then adhesivebeta = 2;
   if adhesive = 'c' then adhesivebeta = 3;
run;

proc mcmc data=toy seed=27513 diag=all dic outpost=mixed 
     propcov=quanew thin=25 nbi=5000 ntu=5000 nmc=500000 
     plots(smooth)=all mchistory=brief stats=all
     monitor=(a_vs_b a_vs_c b_vs_c beta1 beta2 beta3 s2t s2g);
   array beta[3];
   parms beta: 0;
   parms s2t 1;
   parms s2g 1;
   prior beta: ~ normal(0, var = 1e5);
   prior s2: ~ igamma(2.001, scale = 1.001);
   beginnodata;
       a_vs_b = beta[1] - beta[2];
	   a_vs_c = beta[1] - beta[3];
	   b_vs_c = beta[2] - beta[3];
   endnodata;
   random gamma ~ normal(0,var=s2g) subject=toy 
          monitor=(gamma) namesuffix=position;
   mu = beta[adhesivebeta] + gamma;
   model pressure ~ normal(mu, var = s2t);
   title "Bayesian Analysis of the Toy Data Set";
run;

data meana (keep=beta1) meanb (keep=beta2) meanc (keep=beta3);
   set mixed;
run;

data boxplot;
   set meana (in=a) meanb (in=b) meanc (in=c);
   if a then do;
      pressure = beta1;
	  adhesive='a';
   end;
   if b then do;
      pressure = beta2;
	  adhesive='b';
   end;
   if c then do;
      pressure = beta3;
	  adhesive='c';
   end;
run;

proc sgplot data=boxplot;
   vbox pressure / category=adhesive;
   title "Distribution of Population Means by Adhesive";
run;

