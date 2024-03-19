%% Filtracja uśredniająca na sygnale 2022_corr_01.txt
% w oknach o rozmiarze: 3, 5, 9 próbek oraz 1%, 2%, i 5% szerokości sygnału 
close all; clear; clc;

a= load('Data/2022_corr_01.txt');
N=size(a);
Fs=100;
t=(0:N-1)/Fs;
x=a';

p=0.01;
%Nf=9;
Nf=(length(t)-1)*p + (mod(((length(t)-1)*p), 2)==0)

LP=ones(1,Nf)/Nf;

xx=conv(x,LP, 'same');

plot(t,x,'r', t,xx,'g');

%% Usrdniajaca maska Gaussa o zadanej dlugosci i odchyleniu. 
%Zbadanie wpływu obu tych parametrow na jakosc sygnalu.
close all;clear; clc;


a=load('Data/2022_corr_01.txt');
N=size(a);
Fs=100;
t=(0:N-1)/Fs;
x=a';

sr=1; odch=0.02;
t2=0:1/Fs:2;
LP=exp((-(t2-sr).^2)./(2*odch^2))/6;



xx=conv(x,LP,'same');

plot(t,x,'g', t,xx,'r');

%% Sygnal harmoniczny f(t) (A1 = 5, f1 = 2Hz) dla czasu T ∈ 〈0, 10〉s, FS = 100Hz. 
% Dodanie do sygnalu
%(a) sygnal harmoniczny (A2 = 0.5, f2 = 60Hz)
%(b) szum gaussowski o sredniej μ= 0 i odchyleniu σ=0.25.
%(c) szum impulsowy (amp = 2, P rob. = 5%);
%Dokonanie odszumienia sygnalu f(t)
close all; clear; clc;

Fs=100;
t=0:1/Fs:10;

x=5*sin(2*pi*t*2);

a=0.5*sin(2*pi*t*60);
b=exp(-(t-0).^2/(2*0.25*0.25));

c=2*mod(t,0.05)==0;

x1 = x+a;
x2 = x+b;
x3 = x+c;

%filtry
N2=5; N4=5;
LP2=ones(1,N2)/N2;
LP4=ones(1,N4)/N4;

%filtracja
xx2=conv(x1,LP2, 'same');
xx3=medfilt1(x3);
xx4=conv(x3,LP4, 'same');


%odfiltrowane sygnaly
subplot(221), plot(t,x,'b');
subplot(222), plot(t,x1,'b', t,xx2,'r');
subplot(223), plot(t,x2,'b', t,xx3,'r');
subplot(224), plot(t,x3,'b', t,xx4,'r');


%% Sygnal harmoniczny (amp. = 1, f = 20 Hz) w czasie t ∈ 〈0, 10〉 i Fs = 80Hz. 
% Przefiltrowanie sygnalu jednorodna filtracja usredniajaca w oknie 2, 4 i 8 probek
close all; clear; clc;


Fs=80;
t=0:1/Fs:10;

x=1*sin(2*pi*t*20);

N=2;
LP=ones(1,N)/N;

xx=conv(x,LP, 'same');

plot(t,x,'g', t,xx,'r');