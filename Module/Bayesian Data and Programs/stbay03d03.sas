data magnesiumalt;
	set sasuser.magnesium;
	logy = log((rt*(nc-rc))/(rc*(nt-rt)));
	sigma2 = 1/rt + 1/(nt-rt) + 1/rc + 1/(nc-rc);
run;

proc mcmc data=magnesiumalt diag=all dic nbi=10000 stats=all
     ntu=5000 nmc=200000 plot(smooth)=all seed=27513 mchistory=brief
     monitor=(mu tau2 OR Pooled) outpost=metapooled;
	 array OR[9];
	 parms mu 0.5 tau2 1;
	 prior mu ~ normal(0, sd=10);
	 prior tau2 ~ igamma(2.001,s=1.001);
	 random theta ~ normal(mu, var=tau2) subject=trial;
	 OR[trial] = exp(theta);
	 Pooled = exp(mu);
	 model logy ~ normal(theta, var=sigma2);
     title "Bayesian Analysis of Meta-Analysis of Magnesium Clinical Trial Data";
	 title2 "Using Random Effects and Normal Approximation to the Likelihood";
run;
 
%CATER(data=metapooled, var=OR: Pooled);



