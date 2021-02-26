# Finance Projects
# 1: Investment Project BNP Paribas

**PAPER:** Case_Study_Investment_Project_BNP_Paribas.pdf

**SNAPSHOTS:** InvestmentProjectBNPParibas_figure1.png, InvestmentProjectBNPParibas_figure2.png

**CODE:** Investment_BNP_Paribas.m, BNP_Paribas_CS.R

In this paper, we investigate whether it's worth it to make an investment in ”Atlantic Lock-In Synthetic Zero”, product can be bought for the price of £100. Whether this amount will be returned and whether it will accrue a return depends on the performance of two indices, namely the FTSE100 and the SP500. We will consider the pay-off in-depth in

Model formulation in terms of Stochastic Differential Equations (SDE)'s assuming the model of geometric Brownian Motion
<p align="left">
<img src="Model_intermsof_SDE.png?raw=true"
  alt=""
  width="430" height="100">
</p>
<p align="left">
<img src="Model_intermsof_SDE2.png?raw=true"
  alt=""
  width="350" height="100">
</p>

## Snapshots for data visualization
<p align="left">
<img src="InvestmentProjectBNPParibas_figure1.png?raw=true"
  alt=""
  width="400" height="150">
</p>
<img src="InvestmentProjectBNPParibas_figure2.png?raw=true"
  alt=""
  width="400" height="150">
</p>


# 2: Black-Scholes SDE Price Evaluation
File name: Quantitative_Finance_BlackScholes_SDE_Case_Study.pdf


The SDE investor follows: 
<p align="left">
<img src="SDE_Wealth_of_investor_follows.png?raw=true"
  alt=""
  width="350" height="100">
</p>
Black-Scholes world with following setting:
<p align="left">
<img src="Assumed_BlackScholes_setting.png?raw=true"
  alt=""
  width="300" height="100">
</p>
Mean and the variance of the Brownian Motion:
<p align="left">
<img src="Mean_Variance_BrownianMotion.png?raw=true"
  alt=""
  width="350" height="100">
</p>

Following topics are included in this analysis:
 - Black-Scholes 
 - Stochastic Differential Dquation (SDE)
 - Geometric Brownian Motion
 - Itˆo’s lemma
 - Monet Carlo Simulation
 - Euler's Scheme, One-sided Bump-and-Reprice method
 - Closed-form derrivatives, sensitivity
 - Constant Relative Risk Aversion 


# 3: Expected Premium Analysis for a Pension Fund
**Code:** LI_ExpectedNetPremiumPensionFund.m , LI_ExpectedNetPremiumPensionFund2.m, LI_ExpectedSurvivalRates.m, LI_Simulation_Ages.m

**Data:** qxt.mat

**Paper:** LI_ExpectedNetPremium_PensionFund.pdf

Population grows older this results in problems for pension funds. This use-case shows how one can randomly generate the ages of the pension fund customers and calculate the expected pension costs for the pension fund and the expected premium they need to charge to the customers in order to run no losses.
<p align="left">
<img src="LossFunction_of_PensionFund.png?raw=true"
  alt=""
  width="400" height="100">
</p>


