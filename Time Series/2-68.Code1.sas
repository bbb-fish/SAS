/* STSM02e04.sas */
proc print data=mydata.roseseries(obs=12);
     where date >= '01JAN2013'd;
     id date;
     var sales1 sales2 sales3 sales4 Ramp;
run;     
   
proc sgplot data=mydata.roseseries;
    where date >= '01JAN2013'd;
    series x=date y=sales1 / markers;
    series x=date y=sales2 / markers; 
    series x=date y=sales3 / markers; 
    series x=date y=sales4 / markers; 
    series x=date y=ramp / markers;
run; 
