clc;
clear;
%% Load file
load('qxt.mat');
close all;
%% Preliminaries
A = transpose(reshape(q_xt, [111,163]));
B = A(101:157,61:91);

%% (a)(i)   Force of mortality
p_xt = ones(57,31) - B;
mu_xt = -1 * log(p_xt);
mu_xt = transpose(mu_xt);

%% (a)(ii)   Alpha, beta and kappa
sum = zeros(31,1);
for i = 1:57
    sum  = sum + log(mu_xt(:,i));
end
alpha = sum/57;

%plot alpha
figure;
plot(Age(61:91), alpha);


Axt_SVD = log(mu_xt)-repmat(alpha,1,57);
[U, S, V] = svd(Axt_SVD);

som = 0;
for i = 1:31
    som = som + S(1,1)*U(i,1);
end
c = 1/som;

beta = c* S(1,1)*U(:,1);

%plot beta
figure;
plot(Age(61:91),beta);


kappa = transpose(V(:,1)/c);

%plot kappa
figure;
plot(1950:1:2006, kappa);


%% (c)   Estimation of sigma^2
sum2 = 0;
for i=1:31
    for j = 1:57
        sum2 = sum2 + (log(mu_xt(i,j))- alpha(i) - beta(i)*kappa(j))^2;
        
    end
    
    
end
sigma_sq = sum2/(57*31);


%% (d)   LC model
log_muxt_tilde = repmat(alpha,1,57) + beta*kappa;

%Variance of LC model for every age group x (with log(mu_tx_tilde))
variance1 = zeros(31,1);
sum3 = zeros(31,1);
for i = 1:31
    for j = 1:57
        sum3(i) = sum3(i) + (log_muxt_tilde(i,j) - alpha(i))^2;
    end
    variance1(i) = sum3(i);
end


%Total variance1
total_variance1 = 0;
for i = 1:31
    total_variance1 = total_variance1 + variance1(i);
end


%Variance of LC model (with log(mu_tx))
log_muxt = log(mu_xt);
variance2 = zeros(31,1);
sum4 = zeros(31,1);
for i = 1:31
    for j = 1:57
        sum4(i) = sum4(i) + (log_muxt(i,j) - alpha(i))^2;
    end
    variance2(i) = sum4(i);
end


%Total variance2
total_variance2 = 0;
for i = 1:31
    total_variance2 = total_variance2 + variance2(i);
end

%Percentage of Variance explained by the model
percentage_explained = total_variance1/total_variance2;


%% (e)   C_hat and sigmak_hat_sq

%C_hat
C_hat = (kappa(57) - kappa(1))/56;

%sigmak_hat_sq
sum5 = 0;
for i = 2:57
    sum5 = sum5 + (kappa(i) - kappa(i-1) - C_hat)^2;
end
sigmak_hat_sq = sum5/56;


%% (f)   95% prediction interval of mu(80,2086)
k = 80;
sigmak_hat = sqrt(sigmak_hat_sq);
pred_int_left_bound = mu_xt((k+1)-60,57)*exp(k*beta((k+1)-60)*C_hat-1.96*beta((k+1)-60)*sigmak_hat*sqrt(k));
pred_int_right_bound = mu_xt((k+1)-60,57)*exp(k*beta((k+1)-60)*C_hat+1.96*beta((k+1)-60)*sigmak_hat*sqrt(k));

fprintf('\n The 95 percent prediction interval for mu(80,2086) is (%d, %d)',pred_int_left_bound, pred_int_right_bound);



%% (g)   Prediction interval of p(80,2086)
pred_int_left_bound2 = exp(-pred_int_right_bound);
pred_int_right_bound2 = exp(-pred_int_left_bound);
fprintf('\n The 95 percent prediction interval for p(80,2086) is (%d, %d)\n\n',pred_int_left_bound2, pred_int_right_bound2);


%% (h)   Probability of a person aged 60 in 2040 that becomes strictly older than 75

% Note: P(T(60,2040)>15) = P(T(0,1980)>75)/P(T(0,1980)>= 60)
%                        = (p0(1980)*p1(1981)*...*p75(2055))/(p0(1980)*...*p60(2040))
%                        = p61(2041)*...*p75(2055)


% Forecasted survival probabilities and last probability is the required
% one
kappa_forecast1 = zeros(1,15);
prob1 = 1;
for l = 1:15
    kappa_forecast1(1,l) = (l+34)*C_hat +kappa(57);
    prob1 = prob1*exp(-1*exp(alpha(l+1) + beta(l+1)*kappa_forecast1(1,l)));
end



%% (i)  Probability of a person aged 60 in 2040 to pass away aged 80

%P[Tx=k] = P[Tx >= k] - P[Tx >= k+1]
%        = prob2a - prob2b
% Forecasted survival probabilities
kappa_forecast2 = zeros(1,20);
prob2a = 1;
for l = 1:20
    kappa_forecast2(1,l) = (l+34)*C_hat +kappa(57);
    prob2a = prob2a*exp(-1*exp(alpha(l+1) + beta(l+1)*kappa_forecast2(1,l)));
end

prob2b = 1;
for l = 1:21
    kappa_forecast2(1,l) = (l+34)*C_hat +kappa(57);
    prob2b = prob2b*exp(-1*exp(alpha(l+1) + beta(l+1)*kappa_forecast2(1,l)));
end

%required probability
prob2 = prob2a - prob2b;

