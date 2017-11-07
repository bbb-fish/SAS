/* STSM02d05.sas */
/* Part a: ARMA(1,0) Forecasting the holdout sample */
proc arima data=mydata.SOLARPV 
           plots(only)=forecast(forecast forecastonly);
    identify var=kW_Gen;
    estimate p=(1) method=ML;
    forecast lead=6 back=6 id=EDT;
    outlier;
quit;

/* STSM02d05.sas */
/* Part b: ARMAX(1,0) Forecasting the holdout sample */
proc arima data=mydata.SOLARPV 
           plots(only)=forecast(forecast forecastonly);
    identify var=kW_Gen crosscorr=(Cloud_Cover);
    estimate p=(1) input=(Cloud_Cover) method=ML;
    forecast lead=6 back=6 id=EDT;
    outlier;
quit;

/* STSM02d05.sas */
/* Part c: Calculating MAPE for each of the above models */
proc arima data=mydata.SOLARPV 
           plots(only)=forecast(forecast forecastonly)
           out=AR1_forecast;
    identify var=kW_Gen;
    estimate p=(1) method=ML;
    forecast lead=6 back=6 id=EDT;
    outlier;
quit;

proc arima data=mydata.SOLARPV 
           plots(only)=forecast(forecast forecastonly)
           out=ARMAX1_forecast;
    identify var=kW_Gen crosscorr=(Cloud_Cover);
    estimate p=(1) input=(Cloud_Cover) method=ML;
    forecast lead=6 back=6 id=EDT;
    outlier;
quit;

%include "H:\MYDATA\Analytics\DataSTSM41\Data\MAPEMacros.sas";

options mprint;
/* Using the MAPE macro */
%mape(ar1_forecast,EDT,kW_Gen,6);
%mape(armax1_forecast,EDT,kW_Gen,6);

/* Using the MAPE_D macro */
%mape_d(indsn=ar1_forecast,series=kW_Gen,holdback=6);
%mape_d(indsn=armax1_forecast,series=kW_Gen,holdback=6);

/* STSM02d05.sas */
/* Part d: Forecasting the next period */
proc arima data=mydata.SOLARPV_F 
           plots(only)=(series(corr crosscorr) 
                        residual(corr normal) 
                        forecast(forecast forecastonly) ) 
           out=WORK.forecast_out;
    identify var=kW_Gen crosscorr=(Cloud_Cover);
    estimate p=(1) input=(Cloud_Cover) method=ML;
    forecast lead=1 back=0 alpha=0.05 id=EDT interval=week printall;
    outlier;
quit;



