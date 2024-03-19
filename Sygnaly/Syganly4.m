%% Szereg Fouriera 4
Fs = 100;
t = -3:1/Fs:3;
x = -2 .* (abs(t) < 1) + (t - sign(t)).^2 .* (abs(t)<=3 & abs(t) >= 1);

plot(t,x);

XT = (2/9)*ones(size(t));

for n = 1:200
    w = n*pi; %stala
    an = 36*sin(w/3)/(w^3) + 24*cos(w)/(w*w) - 4*sin(w/3)/w;
    XT = XT + an*cos(w*t/3);
end

plot(t,x,'.g', t, XT, 'r');

%% Szereg Fouriera 5
close all; clear; clc;
Fs = 100;
t = -3:1/Fs:3;
x = -1.5 .* (t<0) + (3-t) .* (t>0);

plot(t,x);

XT = zeros(size(t));

for n=1:200
    w=n*pi;
    an=3*(1-cos(w))/(w*w);
    bn=(9-3*cos(w))/(2*w);
    XT=XT+an*cos(w*t/3)+bn*sin(w*t/3);
end

plot(t,x,'.g', t, XT, 'r')

%% Transformata Fouriera (para transformata)
close all; clear; clc;
Fs = 100;
t = -5:1/Fs:5;
x = 3 * (abs(t) <= 2); 
%rodzaj 

subplot(311), plot(t,x);


XT = fftshift(fft(x)); 

%f = linspace(0, Fs, length(t)); %linspace tworzy wektor rownosprobkowany
f = linspace(-Fs/2, Fs/2, length(t));
WA = abs(XT)/Fs;    %dzielenie przez Fs do porownania z WA_t
WF = angle(XT);

WA_t = abs(12*sinc(2*2*f));   %widmo amplitudowe dla wyliczonej transformaty, dodatkowe mnozenie przez 2 bo matlab popsul sinca

subplot(312), plot(f,WA,'r', f, WA_t, 'g'); % zawsze f (czestotliwosc)

subplot(313), plot(f, unwrap(WF));
%unwrap, kazdy kolejny okres jest powiekszony o poprzeni

