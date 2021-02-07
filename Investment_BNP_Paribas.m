clear all; close all;
%----------------------------------------------------------------------------------
% Data upload of FTSE100 and S&P500
load 'data.txt';
FTSE100_daily = data(:,2);
S_P500_daily = data(:,3);
% comparing the estimates of mu's and sigma's with MLE estimates 
%----------------------------------------------------------------------------------
% calculating daily returns from dayly prices (252 trade days)

for i =1:length(FTSE100_daily)-1
FTSE100_day(i,1) = (FTSE100_daily(i+1)-FTSE100_daily(i))/FTSE100_daily(i);
S_P500_day(i,1) = (S_P500_daily(i+1)-S_P500_daily(i))/S_P500_daily(i);
end

% Mean returns on yearly basis as a vector of [E(R_FTSE100) E(R_S&P500)]
% using 252 trading days 1x2
MeanReturns = [mean(S_P500_day)*252 mean(FTSE100_day)*252];
% Standard Deviations of returns on yearly basis as a vector 1x2
StdevReturns = [std(S_P500_day)*sqrt(252) std(FTSE100_day)*sqrt(252)];
% Correlation between two indices
Cor = corrcoef(FTSE100_daily,S_P500_daily);
c =Cor(1,2);

% Part E
%----------------------------------------------------------------------------------
% the starting values of indices
S0 = [100 100];
% we specify interest rate
r = 0.02;
% the number of periods(6 periods in total)
T = 6;
% specifying the Variance-Covariance matrix
sigma = [1 c; c 1];
sigma_2 = [0.2129 0.2622]
R = chol(sigma)
% specifying number of simulations
M = 10^4;
N = 6;
dt = T/N;

% We create a vector 1 by M to store the corresponding payoffs 
for all M scenarios 
Payoffvector = repmat(0,1,M);




% for each scenario(random draw) we create periodS matrix of 7x2 (since S0 is 1x2)
% to store all S1,0,S1,1...S1,6 on frist column and second asset on second column 
% creating matrix 7x2 for 7 periods (including 0,...,6) for values of S for
% t=0,..,6 for asset 1 and 2

for i = 1:M
    periodS = repmat(S0,7,1); 
    S = S0;
    for k = 1:N
    dW = sqrt(dt)*(repmat([0 0],1,1)+randn(1,2)*R); %Brownian Motion
    dS = r*S*dt + sigma_2*transpose(S)*dW; %SDE 
    S = S + dS; %updating SDE
    periodS(k+1,:) = S; %storing computed S for period k for both assets on kth row of 7x2 matrix
    end 
    % first calumn  of S's for scenario i we denote by S1 
    % second column of 7x2 matrix we denote with S2
    S1 = periodS(:,1);
    S2 = periodS(:,2);
    % here we use payoff function to decide payoff for the contract 
    Payoffvector(i) = PayoffFunction(S1,S2); 
    %storing payoff of ith scenario in payoff vector column i
end

% comuting the average of the payoff vector for the estimation
mean(Payoffvector)

%Calculating P0
P0 = exp(-r*6)*mean(Payoffvector)

%Part E
%----------------------------------------------------------------------------------
InvstMoney = 1000; %initial invistment money
% return on Money-Market Account by 100%investment
MMA_1 = exp(r*T)*InvstMoney-InvstMoney;
% computing the amount of possible certificates with no arbitrage price
Number_Of_Certificates = InvstMoney/P0; 
% the rest of the money can be put on bank account
TheRest = InvstMoney - Number_Of_Certificates*P0;
% return over the rest of money putted on bank account
MMA_2 = exp(r*T)*TheRest;
% specifying the MLE estimates of mu1 and mu2 part (c)
mu = [0.0233 0.0327]

Payoffvector2 = repmat(0,1,M);
% counting the number of cases when we have higher payoff with contract
% than with money-market account
CountHigherPayoff = 0;
for i = 1:M
    periodS_1 = repmat(100,7,1);
    periodS_2 = repmat(100,7,1);
    S1 = S0(:,1);
    S2 = S0(:,2);
    for k = 1:N
    dW1 = sqrt(dt)*randn(1,1); %Brownian Motion1
    dW2 = sqrt(dt)*randn(1,1)*sqrt(1-c); %Brownian Motion2
    dS1 = mu(:,1)*S1*dt + sigma_2(:,1)*S1*dW1; %SDE1
    dS2 = mu(:,2)*S2*dt + sigma_2(:,2)*S2*c*dW1+sigma_2(:,2)*S2*sqrt(1-c^2)*dW2;%SDE2
    S1 = S1+dS1; %updating SDE1
    S2 = S2+dS2; %updating SDE2
    periodS_1(k+1) = S1;
    periodS_2(k+1) = S2;
    end 
    periodSS = [periodS_1 periodS_2];
    S_1 = periodSS(:,1);
    S_2 = periodSS(:,2);
    % Payoff calculation for each scenario
    Payoffvector2(i) =     PayoffFunction(S_1,S_2) + MMA_2;
    % Comparison with MMA
    if (Payoffvector2(i) > MMA_1)
        CountHigherPayoff = CountHigherPayoff + 1 ; %in case larger payoff ++1
    end
end
% Payoff vector 1xM with all payoffs for each scenario
% Estimating the new payoff under measure P
mean(Payoffvector2);
% Probability of CountHigherPayoff with dividing it to number of all
% possible cases (M)
Prob_Higher = CountHigherPayoff/M;

%{PayoffFunction}
%----------------------------------------------------------------------------------
function Payoff = PayoffFunction(X,Y)
for i = 1:length(X) - 1
    Returns_X(i) = X(i+1)/X(1);
    Returns_Y(i) = Y(i+1)/Y(1);
end
Lock_in = 0;
for i = 1:length(X) - 1
    if min(Returns_X(i),Returns_Y(i))>=1.1
        Lock_in = 1;
    end
end
z = 0;

for i = 1:length(X)-1
    if min(Returns_X(i),Returns_Y(i))>=0.5
        z = z + 1
    end
end

if Lock_in ==1
    Returns = 50.70;
else
    Returns = 8.45*z;
end   
    if min(Returns_X(end), Returns_Y(end))>= 0.5
        IsPrice = 100;
    else
        IsPrice = 100*min(Returns_X(end),Returns_Y(end));
    end
    Payoff = Returns + IsPrice;