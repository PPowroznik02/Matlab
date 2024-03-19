%Widmo amplitudowe
%Trojkatny (Amp=2, tw=0, szer=4)
Fs=100;
t=-4:1/Fs:4;
x=2*(1-abs(t)/2) .*(abs(t)<2); %dzielenie przez polowe szerokosci
XT=fftshift(fft(x));    %przesuniecie energi do 0
f=linspace(-Fs/2, Fs/2, length(t));
WA=abs(XT); %dla sygnalu trojkatnego sinc^2, bo sygnal trojkatny jest zlozeniem 2 sygnalow prostokatnych

subplot(211), plot(t,x);
subplot(212), plot(f,WA);

%%
%Widmo amplitudowe
%Gauss (sr=0, odch=0.5, A=1.5)
%Harm. (okres=0.25, Amp=1.8)
close all; clear; clc;
Fs=100;
t=-4:1/Fs:4;
x1=1.5*exp( -(t.^2)/(2*0.5^2));
x2=1.8.* sin(2*pi*t/0.25);
x=x1+x2;

XT=fftshift(fft(x));    
f=linspace(-Fs/2, Fs/2, length(t));
WA=abs(XT); 

%WA dla harm. 2 delty diraca
%X1+x2 transf sum to suma transformat

subplot(311), plot(t,x);
subplot(312), plot(t,WA);

%%
%Dyskretna transformata Fouriera
close all; clear; clc;
x=[1 0 -2 1];
fft(x)

%%
% Filtracja czestotliwosciowa
% Fs=100; t=<-4,4>
% x1 gauss, amp=1.8, sr=0, odch=0.5, t=<-4,4>
% x2 harm, amp=1.8, okres=0.25;
% sygnal jest suma sygnalow x1 + x2
% odfiltrowac w czestotliwosci sygnal gaussa a nastepnie sygnal harmoniczny
% powrocic do czasu, wyswitlic przefiltrowane wykresy i WA

close all; clear; clc;

Fs=100;
t=-4:1/Fs:4;
x1=1.5*exp( -(t.^2)/(2*0.5^2));
x2=1.8.* sin(2*pi*t/0.25);
x=x1+x2;

XT=fftshift(fft(x));    
f=linspace(-Fs/2, Fs/2, length(t));

%Usuniecie sygnalu harmonicznego
LP=1.0*(abs(f)<=2); %filtr dolnoprzepustowy
XT_new=XT.*LP;
x_new=ifft(ifftshift(XT_new));

%Usuniecie sygnalu gassa
LP2=1.0*(abs(f)>=2); %filtr gornoprzepustowy
XT_new2=XT.*LP;
x_new2=ifft(ifftshift(XT_new));


WA=abs(XT); 
subplot(211), plot(t,x, 'r', t, x_new, 'g');
subplot(212), plot(f,WA,'r', f,LP*Fs, 'g');

%%
close all; clear; clc;
%t=<0,10>s, Fs=200Hz
%x: suma x1,x2,x3
%x1: prostokatny, szer=2, sr=4, amp=1
%x2: harm, A=0.5, f=13Hz
%x3: harm. A-rosnaca od 1 do 3, f=17Hz
%policzyc i wyswietnic WA

Fs=200;
t=0:1/Fs:10;

%x1= 1*(t>=2 & t<=6);
x1=1*(abs(t-4)<1);
x2=0.5*sin(2*pi*t*13);
x3=(1+t/5).*sin(2*pi*t*17);

x=x1+x2+x3;

XT=fftshift(fft(x));
WA=abs(XT);
f=linspace(-Fs/2, Fs/2, length(t));

%odfiltrowanie 13Hz sygnalu
%BS=1-1.0*(abs(f)>11.5 & abs(f)<14)); %BS-bountstop
%xn=ifft(ifftshift(XT.*BS));

%odfiltrowanie sygnalow czestotliwosciowych
%LP=1.0*(abs(f)<8); %filtr LP
%xn=ifft(ifftshift(XT.*LP));

%odfiltrowanie sygnalow czestotliwosciowych
%BT=1./(1+(f./8).^(2*3)); %filtr BT, butterworth 1/(1+(f/F0)^(2*N))
%xn=ifft(ifftshift(XT.*BT));

%odfiltrowanie sygnalow czestotliwosciowych
BS=1./(1+((3*f)./(f.^2-13^2)).^(2*4)); %filtr BS, butterworth 1/(1+((w*f)/(f^2-f0^2))^(2*N))
xn=ifft(ifftshift(XT.*BS));

subplot(211),plot(t,x, 'g', t, xn, 'r');
subplot(212), plot(f,WA, 'r', f,BS*Fs, 'g');

