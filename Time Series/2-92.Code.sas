/*
 *
 * Task code generated by SAS Studio 3.5 
 *
 * Generated on '11/5/17, 4:49 PM' 
 * Generated by 'frobera' 
 * Generated on server 'SSB-LAB-12.AD.OKSTATE.EDU' 
 * Generated on SAS platform 'X64_10PRO WIN' 
 * Generated on SAS version '9.04.01M4P11092016' 
 * Generated on browser 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393' 
 * Generated on web client 'http://localhost:63566/main?locale=en_US&zone=GMT-06%253A00&sutoken=%257B4E93DA5D-4E1E-4397-9D66-C6517D7E9EF6%257D' 
 *
 */

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=MYDATA.SOLARPV out=Work.preProcessedData;
	by EDT;
run;

proc arima data=Work.preProcessedData plots
     (only)=(forecast(forecast forecastonly) ) out=WORK.forecast_out;
	identify var=kW_Gen crosscorr=(Cloud_Cover);
	estimate p=(1) input=(Cloud_Cover) method=ML;
	forecast lead=5 back=0 alpha=0.05 id=EDT interval=week printall;
	run;
quit;

proc delete data=Work.preProcessedData;
run;