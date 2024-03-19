%% 1 Policz Transformatę Fouriera (analitycznie (a,b) oraz w MatLABie (a-d) dla
% wyswietl sygnal, WA, WF
% FS = 100Hz) dla następujących sygnałów:

%% a) Sygnał prostokątny (amplituda 1, szerokość 2, środek 0) dla t ∈< −π, π >
close all; clear; clc; 

Fs=100;
t=-pi:1/Fs:pi;
x=1*(abs(t)<=1);

XT=fftshift(fft(x));
f=linspace(-Fs/2, Fs/2, length(t));

WA=abs(XT);
WF=angle(XT);

subplot(311), plot(t,x); title("Sygnal");
subplot(312), plot(f,WA); title("WA");
subplot(313), plot(f,unwrap(WF)); title("WF");

%% b) Sygnał trójkątny (amplituda 1, szerokość 2, środek 0) dla t ∈< −5, 5 >
close all; clear; clc;

Fs=100;
t=-5:1/Fs:5;
x=(1-2*abs(t-0)/2).* (abs(t)<=1); 

XT=fftshift(fft(x));
f=linspace(-Fs/2, Fs/2, length(x));

WA=abs(XT);
WF=angle(XT);

subplot(311), plot(t,x);
subplot(312), plot(f,WA);
subplot(313), plot(f,unwrap(WF));

%% c) Sygnał harmoniczny (amplituda 1, okres 1) dla t ∈< −4π, 4π > 
close all; clear; clc;

Fs=100;
t=-4*pi:1/Fs:4*pi;
x=sin(2*pi*t);

XT=fftshift(fft(x));
f=linspace(-Fs/2, Fs/2, length(t));

WA=abs(XT);
WF=angle(XT);

subplot(311), plot(t,x);
subplot(312), plot(f,WA);
subplot(313), plot(f,unwrap(WF));

%% d) Sygnał Gaussowski (średnia 0, odchylenie 1) dla t ∈< −5, 5 >
close all; clear; clc;

Fs=100;
t=-5:1/Fs:5;
x=exp(-(t-0).^2/(2*1*1));

XT=fftshift(fft(x));
f=linspace(-Fs/2, Fs/2, length(t));

WA=abs(XT);
WF=angle(XT);

subplot(311), plot(t,x);
subplot(312), plot(f,WA);
subplot(313), plot(f,unwrap(WF));

%% 2 Policz dyskretną Transformatę Fouriera dla wektorów (dla uproszczenia przyjmij, 
% że pierwszy element ma indeks zero, tj. x[0]=1)
close all; clear clc;

x1 = [1 0 -2 1];
x2 = [1+i, 2-i, 3, i];
x3 = [1 2 3 4];
x4 = [1+i, 1-i, 2+i, 2-i];

fprintf("x1: "); fft(x1) 
fprintf("x2: "); fft(x2)
fprintf("x3: "); fft(x3)
fprintf("x4: "); fft(x4)