%% 1
close all; clear; clc;
Fs=200;
t=-1:1/Fs:1;

x=1*(abs(t)<=0.5);

XT=0.5*ones(size(t));

for n=1:200
    an=2*sin(n*pi/2)/(n*pi);
    XT=XT + an*cos(n*pi*t);
end


plot(t,x,'.r', t,XT,'g');

%% 2
close all; clear; clc;
Fs=200;
t=-2:1/Fs:2;

x=1*(1-2*abs(t)/2).*(abs(t)<=1);

XT=0.25*ones(size(t));

for n=1:200
    an=4*(1-cos(n*pi/2))/(n*n*pi*pi);
    XT=XT+an*cos(n*pi*t/2);
end

plot(t,x,'.r', t,XT,'g');

%% 3
close all; clear; clc;
Fs=200;

t=-pi:1/Fs:pi;

x=0*(t<0) + t.*(t>=0);

XT=(pi/4)*ones(size(t));

for n=1:200
    an=((-1)^n-1)/(n*n*pi);
    bn=((-1)^(n+1))/n;
    XT=XT+an*cos(n*t) + bn*sin(n*t);
end

plot(t,x,'.r', t,XT,'g');

%% 4
close all; clear; clc;
Fs=200;

t=-pi:1/Fs:pi;

x=t.^2;

XT=(pi*pi/3)*ones(size(t));

for n=1:200
    an=(4*(-1)^n)/(n*n);
    XT=XT + an*cos(n*t);
end

plot(t,x,'.r', t,XT,'g');

%% 5
close all; clear; clc;
Fs=100;
t=0:1/Fs:6;

x=2*t.*(t<=1) + 2.*(t>1 & t<=3);

XT=(5/6)*ones(size(t));

for n=1:200
    an=6*(cos(n*pi/3)-1)/(n*n*pi*pi);
    bn=6*sin(n*pi/3)/(n*n*pi*pi) - 2*cos(n*pi)/(n*pi);
    XT=XT + an*cos(n*pi*t/3) + bn*sin(n*pi*t/3);
end




plot(t,x,'.b', t,XT,'r');



%% 6
close all; clear; clc;

Fs=100;
t=-2:1/Fs:4;

x1= 0*(-2*t < 0) + 0.5*(-2*t == 0) + 1*(-2*t>0);
x2=(1-2*abs(t)/2 ).*(t>=-1 & t<=1);
x=x1.*x2;

XT=(1/12)*ones(size(t));


for n=1:200
    an=3*(1-cos(n*pi/3))/(n*n*pi*pi);
    bn=-1/(n*pi) - 3*sin(-n*pi/3)/(n*n*pi*pi);
    XT=XT + an*cos(n*pi*t/3) + bn*sin(n*pi*t/3);
end


plot(t,x,'.b', t,XT,'r');