data roots;
   set sasuser.roots;
   photo_bap = photo*bap;
run;

proc mcmc data=roots diag=all dic propcov=quanew mchistory=brief stats=all
      nbi=5000 ntu=5000 nmc=500000 thin=10 plots(smooth)=all seed=27513;
   parms (beta0 beta1 beta2 beta3) 0;
   parms (gamma0 gamma1) 0;
   prior beta: ~ normal(0,var=1000);
   prior gamma: ~ normal(0,var=10);
   mu= exp(beta0 + beta1*photo + beta2*bap + beta3*photo_bap);
   p0= logistic(gamma0 + gamma1*photo);
   llike=log(p0*(roots eq 0) + (1-p0)*pdf("poisson",roots,mu));
   model dgeneral(llike);
   title "Bayesian Analysis of Roots Data Set";
run;

proc mcmc data=roots diag=all dic propcov=quanew mchistory=brief
      ntu=5000 nmc=250000 thin=10 plots(smooth)=all seed=27513 stats=all;
   parms (beta0 beta1 beta2 beta3) 0;
   prior beta: ~ normal(0,var=1000);
   mu= exp(beta0 + beta1*photo + beta2*bap + beta3*photo_bap);
   model roots~Poisson(mu);
   title "Bayesian Analysis of Roots Data Set";
run;
