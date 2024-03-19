%% splot funkcji gaussowskiej (sr=0.0, std=0.2) 
% z funkcją Sza g(t) = X(t) (dla n ∈ N ) dla t ∈< −5, 10 >
% spróbkowanych z FS = 50Hz.
close all; clear; clc;


Fs=50;
t=-5:1/Fs:10;

x1=1*exp(-(t-0).^2/(2*0.2^2));
x2=mod(Fs*t,Fs)==0;

subplot(311), plot(t,x1);
subplot(312), plot(t,x2);

c=conv(x1,x2,'same');
xc=xcorr(x1,x2);

subplot(313), plot(t,c);

%% splot sygnału harmonicznego Amp = 1.0, okresie ω1 = 0.5s i czasie trwania T1 = 10s
%z sygnałem prostokątnym g(t) o czasie trwania T2 = 0.2s i amplitudzie A2 = 1/(T2 ·FS ). 
%FS = 100Hz. Stwórz wykresy sygnałów oraz ich splotu.
close all; clear; clc;

Fs=100;
t=0:1/Fs:10;

x1=1*sin(2*pi*t/0.5);
x2=(1/(0.2*Fs))*(abs(t-5)<=0.2);

subplot(311), plot(t,x1);
subplot(312), plot(t,x2);

c=conv(x1,x2,'same');

subplot(313), plot(t,c);