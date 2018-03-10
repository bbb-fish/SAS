data Prior;
   input _TYPE_ $ dose clinic1 prison;
datalines;
Mean -0.034160 0 0
Var .0003217 1e6 1e6 
;
run;

proc phreg data=sasuser.methadone;
   class clinic (param=ref ref='2');
   model time*status(0)=clinic dose prison / ties=exact;
   bayes seed=27513 coeffprior=normal(input=Prior) diag=all 
   plots(smooth)=all sampling=rwm thin=10 nmc=200000 statistics=all;
   hazardratio "HR1" clinic;
   hazardratio "HR2" dose / units=10;
   hazardratio "HR3" prison;
   title "Bayesian Analysis with Informative Prior for Methadone Data";
run;






   
   
