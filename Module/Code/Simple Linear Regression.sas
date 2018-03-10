/* Ch 2 M Fitting Models */

/*
PROC MCMC options;
	PARMS parameters and starting values;
	BEGINCNST;
		Programming Statements;
	ENDCNST;
	BEGINNODATA;
		Programming Statements;
	ENDNODATA;
	PRIOR parameter ~ distribution;
	MODEL variable ~ distributions;
	RANDOM random effects specification;
	PREDDIST <'label'> OUTPRED=SAS-data-set <options>;
RUN;
*/

/* Always use a seed for reproducability */
proc mcmc data=slr seed=27513;
	/* PARMS statements */
	parms beta0 0 beta1 0;
	parms sigma2 1;
	/* PRIOR statemenets */
	prior beta0 beta1 ~ normal(mean=0,
		var=1e6);
	prior sigma2 ~ igamma(shape=2.001,
		scale=1.001);
	/* MODEL statemenets */
	mu=beta0 + beta1*X1;
	model Y ~ normal(mu, var=sigma2);
run;

/* BEGINCNST/ENDCNST 

begincnst;
	c1=log(0.05 / 0.95);
	c2=-c1;
endcnst;

*/

/* BEGINNODATA/ENDNODATA

parms s2;
beginnodata;
	s=sqrt(s2);
endnodata;
model y~normal(0, sd=s);

*/

/* Random Effects Models */

proc mcmc data=inputdata;
	/* PARMS */
	parms beta0-beta1 0;
	parms sigma1;
	parms s2 1;
	/* PRIOR */
	prior beta: ~ normal(0, var=100);
	prior sigma s2 ~ igamma(2.001,
		scale=1.001);
	/* RANDOM */
	random gamma ~ normal(0,var=sigma)
		subject=index;
	/* MODEL */
	mu=beta0 + beta1*x + gamma;
	model y ~ normal(mu, var=s2);
run;