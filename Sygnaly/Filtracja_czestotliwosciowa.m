%% 1
close all; clear; clc;
% Stwórz sygnał o czasie trwania T = 10s i FS = 100Hz złożony z dwóch sygnałów
% harmonicznych o następujących parametrach: Amp1 = 5, f1 = 10Hz i Amp2 = 1,
% f2 = 30Hz. Korzystając z filtrów z rozdz.2 odfiltruj część wysokoczęstotliwościową.

Fs=100;
t=-5:1/Fs:5;

x1=5*sin(2*pi*t*10);
x2=1*sin(2*pi*t*30);
x=x1+x2;

XT=fftshift(fft(x));
f=linspace(-Fs/2, Fs/2, length(t));
WA=abs(XT);

% LP=1*(abs(f) <= 15);
% xn=ifft(ifftshift(XT.*LP));

% BT=1-1./(1+(f/20).^20);
% xn=ifft(ifftshift(XT.*BT));

BS=1./(1+ ((f*10)./(f.^2 - 900)).^6 )
xn=ifft(ifftshift(XT.*BS));

subplot(311), plot(t,x);
subplot(312), plot(f,WA,'b', f,BS.*Fs,'r');
subplot(313), plot(t, xn);
%% 2
close all; clear; clc;
% Stwórz sygnał prostokątny (T = 10s, FS = 100Hz, Amp = 1, środek=5, szero-kość=1). 
% Przefiltruj sygnał filtrami idealnymi dolno- i górnoprzepustowymi o zmiennej szerokości pasma przepuszczania.

Fs=100;
t=0:1/Fs:10;
x=1*(abs(t-5)<=0.5);

XT=fftshift(fft(x));
f=linspace(-Fs/2, Fs/2, length(t));
WA=abs(XT);

LP=1*(abs(f)<=10);
xn=ifft(ifftshift(XT.*LP));

% BT=1./(1+ (f/4).^8);
% xn=ifft(ifftshift(XT.*BT));

% BS=1./(1+  ((f*4)./(f.^2-25)).^4 );
% xn=ifft(ifftshift(XT.*BS));


subplot(311), plot(t,x);
subplot(312), plot(f,WA,'b', f,LP.*Fs,'r');
subplot(313), plot(t,xn);


%% 3
close all; clear; clc;
% Wczytaj sygnał trasa_01.txt o kroku próbkowania dt=0.25ms. Dokonaj filtracji
% dolnoprzepustowej celem poprawy jakości sygnału. Wynik porównaj z rezultatami filtracji w domenie przestrzeni.

a=load("Data/trasa_01.txt");
N=length(a);
Fs=1000/0.25;
t=(0:N-1)/Fs;
x=a';

LP=ones(1,11)/11;
x_new=conv(x,LP, 'same');

XT=fftshift(fft(x));
f=linspace(-Fs/2, Fs/2, length(t));
WA=abs(XT);

XT_new=fftshift(fft(x_new));
f=linspace(-Fs/2, Fs/2, length(t));
WA_new=abs(XT_new);



subplot(311), plot(t,x,'b', t,x_new,'r');
subplot(312), plot(f,WA,'b', f,WA_new,'r');
