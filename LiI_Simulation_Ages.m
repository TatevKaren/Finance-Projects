%Simulation Program
clearvars -except qf qm kpx kpy

%inputs
v=1/1.02;     %discount facor
yr=2018;      %current year
N=100;        %number of insureds
Rep=100000/N; %number of scenarios to be taken 1000 if N=100
group=6;

%load relevant remaining lifetime distribution
xpdf=(kpx-[kpx(2:length(kpx)),0])';
xcdf=(ones(1,length(kpx))-kpx)';
ypdf=(kpy-[kpy(2:length(kpy)),0])';
ycdf=(ones(1,length(kpy))-kpy)';
%NOTE: Txpdf(1+k)=P(Tx=k), this may lead to confusion, unhappily MatLab does not allow for nonpositive numbers as array indicators
%NOTE: Txcdf(1+k)=P(Tx<=k)

if group==1
    mx=1; x=23; 
    my=0; y=32;
elseif group==2
    mx=1; x=23; 
    my=0; y=34;
elseif group==3
    mx=1; x=25; 
    my=0; y=36;
elseif group==4
    mx=1; x=21; 
    my=1; y=33;
elseif group==5
    mx=0; x=24; 
    my=0; y=36;
elseif group==6
    mx=0; x=22; 
    my=1; y=37;
elseif group==7
    mx=0; x=24; 
    my=0; y=36;
elseif group==8
    mx=1; x=25; 
    my=0; y=30;
elseif group==9
    mx=1; x=23; 
    my=0; y=28;
end

%simulate ages
stream=RandStream('mt19937ar','Seed',x*y+mx+my); %determines random number generator
ux=rand(stream,N,Rep); %draws from uniform distribution used to simulate the ages of (x)
uy=rand(stream,N,Rep); %draws from uniform distribution used to simulate the ages of (y)
tx=zeros(N,Rep);
ty=zeros(N,Rep);
for n=1:N;
   tx(n,:)=sum(xcdf*ones(1,Rep)<ones(size(xcdf,1),1)*ux(n,:)); %this determines the ages for (x) as discussed in Lecture 5
   ty(n,:)=sum(ycdf*ones(1,Rep)<ones(size(ycdf,1),1)*uy(n,:)); %this determines the ages for (y) as discussed in Lecture 5
end;

%determine number people at risk at time t
%determine discounted premium payments at time t
%determine discounted pension payments at time t
%estimates
