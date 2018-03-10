data crossover;
   set sasuser.crossover;
   if drug = 'a' then drugalpha = 1;
   if drug = 'c' then drugalpha = 2;
   if drug = 'p' then drugalpha = 3;
   visitbeta = visit - 1;
   if sequence = 'A' then seqdelta = 1;
   if sequence = 'B' then seqdelta = 2;
   if sequence = 'C' then seqdelta = 3;
   if sequence = 'D' then seqdelta = 4;
   if sequence = 'E' then seqdelta = 5;
   if sequence = 'F' then seqdelta = 6;
run;

proc mcmc data=crossover seed=27513 diag=all dic mchistory=brief 
     propcov=congra nbi=5000 ntu=5000 nmc=500000 thin=15 stats=all
     plots(smooth)=all monitor=(alpha beta delta s2t s2g);
   array alpha[3];
   array beta[3];
   array delta[6];
   parms alpha: 0;
   parms beta1 beta2 0;
   parms delta1 delta2 delta3 delta4 delta5 0;
   parms s2t 1;
   parms s2g 1;
   prior alpha: ~ normal(0, var = 100);
   prior beta1 beta2 ~ normal(0, var = 100);
   prior delta1 delta2 delta3 delta4 delta5 ~ normal(0, var = 100);
   prior s2: ~ igamma(2.001, scale = 1.001);
   a0 = 0.5;
   beta[3]=0;
   delta[6]=0;
   random gamma ~ normal(0,var=s2g) subject=patient 
          monitor=(gamma) namesuffix=position;
   mu = alpha[drugalpha] + beta[visitbeta] + delta[seqdelta] + gamma;
   llike=logpdf("normal",changehr,mu,s2t);
   if (group = "pilot") then llike = a0 * llike;
   model general(llike);
   title "Bayesian Analysis of Crossover Design Data";
run;

