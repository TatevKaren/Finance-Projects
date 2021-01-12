% qm and qf are the entire datasets as provided on blackboard for
% respectively male and female. 
clearvars -except qf qm 

x=22;
qx=zeros(121-x,1);
q=0;
i=x+1;
j=3;
t=1;

while q<1
    q=qf(i,j);
    qx(t)=q;
    i=i+1;
    j=j+1;
    t=t+1;
end 

px=1-qx;

%y is male and has age 37

y=37;
qy=zeros(121-y,1);
q=0;
i=y+1;
j=3;
t=1;

while q<1
    q=qm(i,j);
    qy(t)=q;
    i=i+1;
    j=j+1;
    t=t+1;
end

py=1-qy;


%calculate ETx which is the expected remaining lifetime of x
ipx=cumprod(px);
ETx=sum(ipx);

% calculate ETy which is the expected remaining lifetime of y
ipy=cumprod(py);
ETy=sum(ipy);


%calculate the retirement age age of x
ipx65=cumprod(px(66-x:length(px)));
ETx65=sum(ipx65);

if ETx65+65-18.26>65
    retX=ceil(ETx65+65-18.26);
else 
    retX=65;
end 

%calculate the retirement age of y
ipy65=cumprod(py(66-y:length(py)));
ETy65=sum(ipy65);

if ETy65+65-18.26>65
    retY=ceil(ETy65+65-18.26);
else 
    retY=65;
end 

r=0.02;
v=1/(1+r);
vk=[1, cumprod(ones(1,122)*v)];
%This question is made later on


%First all matrices are created with on the (i,j) element Tx=i-1 and Ty=j-1
Q=zeros(1,10);
kpx=[1, ipx']; 
kpy=[1, ipy'];
PI=zeros(122-x, 122-y);

for Tx=0:121-x
    for Ty=0:121-y
        premium=0;
        
        for i=0:121
        if Tx>=i && i<retX-x
            premium=premium+vk(i+1);
        end
        if Ty>=i && i<retY-y
            premium=premium+vk(i+1);
        end
        
        if Tx>=i && Ty>=i && i<retX-x && i<retY-y
            premium=premium-0.5*vk(i+1);            
        end
        end
        PI(Tx+1, Ty+1)=premium;
    end
end

probs=zeros(122-x,122-y);

for Tx=0:121-x
   for Ty=0:121-y
       if Tx+2<=length(kpx)&& Ty+2<=length(kpy)
        probs(Tx+1,Ty+1)=(kpx(Tx+1)-kpx(Tx+2))*(kpy(Ty+1)-kpy(Ty+2));
       else 
            probs(Tx+1,Ty+1)=kpx(Tx+1)*kpy(Ty+1);
       end
   end
end

Y=zeros(122-x, 121-y);

for Tx=0:121-x
    for Ty=0:121-y
        
        payments=0;
        
        for i=0:121
        if Tx>=i && Ty<i && i>=retX-x
            payments=payments+vk(i+1);
        end
        if Ty>=i && Tx<i && i>=retY-y
            payments=payments+vk(i+1);
        end
            
        end
        Y(Tx+1,Ty+1)=payments;
    end
end

EY=sum(sum(Y.*probs));


P_xGetsPayed=0;
for Tx=0:121-x
    for Ty=0:121-y
   if Tx>Ty && Tx>=retX-x
       P_xGetsPayed=P_xGetsPayed+probs(Tx+1,Ty+1);
    end
    end 
end
Q(1)= P_xGetsPayed;

P_yGetsPayed=0;
for Tx=0:121-x
    for Ty=0:121-y
   if Ty>Tx && Ty>=retY-y
       P_yGetsPayed=P_yGetsPayed+probs(Tx+1,Ty+1);
    end
    end 
end
Q(2)= P_yGetsPayed;

EPI=sum(sum(probs.*PI));
netPremium=50000*(EY/EPI);
Q(3)=netPremium;

L=50000*Y-netPremium*PI;
stdL=sqrt(sum(sum((L.^2).*probs)));
Q(4)=stdL;

alpha=0.00000005*6;
varPrinciplePremium=netPremium+(0.5*alpha*stdL^2)/EPI;
Q(5)=varPrinciplePremium;

L_varPremium=50000*Y-varPrinciplePremium*PI;
EL_varPremium=sum(sum(L_varPremium.*probs));
stdL_varPremium=sqrt(sum(sum((L_varPremium.^2).*probs))-EL_varPremium^2);
Q(6)=stdL_varPremium;

U=(1-exp(L*alpha))/alpha;
EU=sum(sum(U.*probs));
Q(7)=EU;

U_VarPremium=(1-exp(L_varPremium*alpha))/alpha;
EU_varPremium=sum(sum(U_VarPremium.*probs));
Q(8)=EU_varPremium;

P_netPremium_probOfDefault=0;
for Tx=0:121-x
    for Ty=0:121-y
    if L(Tx+1,Ty+1)>0
    P_netPremium_probOfDefault=P_netPremium_probOfDefault+probs(Tx+1,Ty+1);
    end
    end 
end
Q(9)=P_netPremium_probOfDefault;

P_varPremium_probOfDefault=0;
for Tx=0:121-x
    for Ty=0:121-y
    if L_varPremium(Tx+1,Ty+1)>0
    P_varPremium_probOfDefault=P_varPremium_probOfDefault+probs(Tx+1,Ty+1);
    end
    end 
end
Q(10)= P_varPremium_probOfDefault;
