# Reading the data.
files <- list.files(path=fh,pattern='.csv')
FTSE100 <- read.csv2(files[1],sep=',',skip=0,header=TRUE,na='.',dec=".")%>%
  mutate(date=as.Date(date),value=as.numeric(value),week=as.Date(cut(date,breaks="week"))) %>%
  subset(date> "2006-05-01" & date < "2011-05-04") %>%
  group_by(date) %>%
  summarize(value,week) %>%
  mutate(return_ratios_daily=value/lag(value,1), log_return_ratios_daily=log(return_ratios_daily))

SP500 <- read.csv2(files[2],skip=0,header=TRUE,sep=",",dec=".",na=".")%>%
  mutate(date=as.Date(Date),value=as.numeric(Close),week=as.Date(cut(date,breaks="week"))) %>%
  subset(date> "2006-05-01" & date < "2011-05-04") %>%
  group_by(date) %>%
  summarize(value,week) %>%
  mutate(return_ratios_daily=value/lag(value,1), log_return_ratios_daily=log(return_ratios_daily))

joinedDataFrameDaily <- merge(SP500,FTSE100, by="date",suffixes=c('SP500','FTSE100')) %>%
  group_by(date) %>%
  summarize(valueSP500, return_ratios_dailySP500, 
            log_return_ratios_dailySP500, valueFTSE100,
            return_ratios_dailyFTSE100, 
            log_return_ratios_dailyFTSE100,weekSP500)

joinedDataFrameWeekly <- joinedDataFrameDaily[duplicated(joinedDataFrameDaily$weekSP500),]%>%
  mutate(return_ratios_weeklySP500=valueSP500/lag(valueSP500,1),
         log_return_ratios_weeklySP500=log(return_ratios_weeklySP500),
         return_ratios_weeklyFTSE100=valueFTSE100/
         lag(valueFTSE100,1),
         log_return_ratios_weeklyFTSE100=
         log(return_ratios_weeklyFTSE100))%>%
  group_by(weekSP500) %>%
  summarize(valueSP500,return_ratios_weeklySP500,
  log_return_ratios_weeklySP500, valueFTSE100,
  return_ratios_weeklyFTSE100, log_return_ratios_weeklyFTSE100)

#We know that the logarithms of the return ratios are bivariate normally distributed. Let us use the MLE estimator for the parameters for this
#distribution. We do this for both weekly and daily data.

#For weekly data.
X=as.matrix(joinedDataFrameWeekly[,c("log_return_ratios_weeklySP500","log_return_ratios_weeklyFTSE100")])[-1,]
n=nrow(X);
Xi_minus_Xmean=sweep(X,2,colMeans(X));
Sigma_dt_weekly=t(Xi_minus_Xmean)%*%Xi_minus_Xmean/n
Sigma_from_weeklyData=Sigma_dt_weekly/(1/52)
v_from_weeklyData=colMeans(X)/(1/52)

#For daily data

X=as.matrix(joinedDataFrameDaily[,c("log_return_ratios_dailySP500","log_return_ratios_dailyFTSE100")])[-1,]
n=nrow(X);
Xi_minus_Xmean=sweep(X,2,colMeans(X));
Sigma_dt_daily=t(Xi_minus_Xmean)%*%Xi_minus_Xmean/n
Sigma_from_dailyData=Sigma_dt_daily/(1/252)     
#There are about 252 
trading dates per year. This is an assumption. Working weekly is easier.
v_from_dailyData=colMeans(X)/(1/252)
#Using the fact that we can obtain MLE estimators for the parameters of the geometric Brownian motion by transforming the MLE estimators
#calculated above, we can calculate MLE estimates for the mu's of both assets, as well as the sigmas. Let us continue working with our
#weekly estimates, so let us define Sigma as Sigma_from_weeklyData

Sigma=Sigma_from_weeklyData
vhat=v_from_weeklyData
sigma_1_MLE=sqrt(Sigma[1,1])
sigma_2_MLE=sqrt(Sigma[2,2])
rho_12=Sigma[2,1]/(sigma_1_MLE*sigma_2_MLE)
mu_1_MLE=vhat[1]+1/2*sigma_1_MLE^2
mu_2_MLE=vhat[2]+1/2*sigma_2_MLE^2
