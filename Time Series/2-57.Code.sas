/*
 *
 * Task code generated by SAS Studio 3.5 
 *
 * Generated on '11/4/17, 4:01 PM' 
 * Generated by 'frobera' 
 * Generated on server 'SSB-LAB-08.AD.OKSTATE.EDU' 
 * Generated on SAS platform 'X64_10PRO WIN' 
 * Generated on SAS version '9.04.01M4P11092016' 
 * Generated on browser 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393' 
 * Generated on web client 'http://localhost:63316/main?locale=en_US&zone=GMT-05%253A00&sutoken=%257BB01F0258-E94A-4AA3-BA52-602CC97A984F%257D' 
 *
 */

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=MYDATA.SOLARPV out=Work.preProcessedData;
	by EDT;
run;

proc timeseries data=Work.preProcessedData seasonality=52 crossplots=(series 
		ccf);
	id EDT interval=week;
	var kW_Gen / accumulate=none transform=none dif=0 sdif=0;
	crossvar Cloud_Cover / accumulate=none transform=none dif=0 sdif=0;
	ods exclude CCFNORMPlot;
run;

proc delete data=Work.preProcessedData;
run;