% Tworzenie podstawowych sygnalow w matlabie

%% sygnal prostokatny

t0 = 0;     %poczatek sygnalu 
ta = 3;     %poczatek amplitudy
tb = 6;     %koniec amplitudy
tk = 10;    %koniec sygnalu
Amp = 2;    %max amplituda sygnalu

Fs = 1000;  %liczba probek
dt = 1/Fs;  %krok probkowania

t = t0 : dt : tk;   %sprobkowanie dziedziny sygnalu

pros = Amp * (t>=ta & t<=tb);   %wartosci sygnalu dla kazdej probki

plot(t,pros);
ylim([-0.5, 2.5]); 

mean(pros)          %srednia sygnalu
sum(pros.^2)/Fs    %energia sygnalu


%% sygnal trojkatny
close all; clear; clc;

t0 = -5;
ta = -3;
tb = 3;
tk = 5;
tw = 0;
Amp = 2;

Fs = 1000;
dt = 1/Fs;

t = t0 : dt : tk;

%x = Amp * (1 - abs(t) / tb) .* (t >= ta & t <= tb);
x = Amp * (1 - abs((t-tw)) / ((tb - ta)/2)) .* (abs(t-tw) <= ((tb - ta)/2))

plot(t,x);
ylim([-0.5, 2.5]);  %ograniczenie osi y

mean(x)
sum(x.^2)/Fs


%% sygnal harmoniczny
close all; clear; clc;
t0 = 0;     %poczatek sygnalu
tk = 10;    %koniec sygnalu
T = 0.5;    %okres
Amp = 5     %amplituda

Fs=100;     %ilosc probek
dt = 1/Fs;  %krok probkowania

t = t0 : dt : tk;

%x = (Amp-t/Amp) .* sin(2*pi*t/T);
x = sinc(2*t);


plot(t,x);
ylim([-6, 6]); 

mean(x)
sum(x.^2)/Fs


%% sygnal Gaussa
close all; clear; clc;
Fs = 10000;
sr = 3; 
odch = 1/3; 
Amp = 2;

t = 0 : 1/Fs : 10;
x = Amp*exp((-(t-sr).^2)/(2*odch^2))
plot(t,x);

mean(x)
sum(x.^2)/Fs

%% funkcja znaki
close all; clear; clc;
Fs=100;
t = -5 : 1/Fs : 5;
%H=t>=0;
%plot(t,H);
plot(t,sign(t));
ylim([-1.5, 1.5]);


%% sygnal grzebieniowy
close all; clear; clc;
Fs=100;
t = -5 : 1/Fs : 5;
H=t>=0;
%sza = mod(Fs*t,0.1)==0;
sza = mod(t,1)==0;
%sza = sza .* sin(2*pi*t);
plot(t,sza);
ylim([-1.5, 1.5]);


%% splot konwulucja
conv([1 0 2 4], [-1 0 1], 'same')