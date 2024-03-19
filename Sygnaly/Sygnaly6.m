%% filtracja z wykorzystaniem narzedzia fdl tool
% t=<0,15>s, Fs=200;
% x1 harm okres=0.04s amp=1
% x2 gauss sr=7, odch=1.5, amp=pi
% x3 harm f=15Hz, amp malejaca, amp=od 4 do 1
% sygnal jest suma sygnalow x1 x2 x3, policzyc WA
% korzystajac z filtra BS Butterwortha usunac 15Hz
% wyswietlic sygnal, WA i przeskalowac BS

Fs=200;
t=0:1/Fs:15;

x1=1*sin(2*pi*t/0.04);
x2=pi*exp(-(t-7).^2/(2*1.5^2));
x3=(4-t/5).*sin(t*2*pi*15);
x=x1+x2+x3;


plot(t,x3)

XT=fftshift(fft(x));
WA=abs(XT);

f=linspace(-Fs/2, Fs/2, length(t));

BS=1./(1+(6*f./(f.^2-15^2)).^8);
xnew=real(ifft(ifftshift(XT.*BS)));

%Hd_fir, Hd_iir wyeksportowane filtry z fda tool
%xf=filter(Hd_fir, x);   
%xi=filter(Hd_iir, x);
%df=length(Hd_fir.numerator)/(2*Fs); %presuniecie filtra Hd_fir

%przesuniecie filtra
df=0;
xf=filtfilt(Hd_fir.Numerator, 1,x);
xi= filtfilt(Hd_iir.sosMatrix, Hd_iir.scaleValues, x); 

subplot(211), plot(t,x,'r', t,xi, 'g', t-df, xf, 'b'); %przesuniecie o 0.5 wieklkosci filtra dla fira, bo polecenie filter bierze poczatkowe wartosci filtra, a nie srodkowe
subplot(212), plot(f,WA,'r', f, 2000*BS, 'g');

%% filtracja liniowa, odszumianie w domenie czasu
clear all; close; clc;
% t=<0,20>s, Fs=100
% x: suma skladowych:
% x1 - pprostokatna (sr=4, szer=6, amp=1);
% x2 -trojkatna (tw=11, szer=4, amp=1);
% x3 - delta diraca d(t-15) + d(t-17)
% stworzyc i wyswietlic

Fs=100;
t=0:1/Fs:20;

x1=1*(t>=1 & t<=7);
x2=1*(1-abs(t-11)/2) .*(t>=9 & t<=13);
%x2=1*(1-abs(t-11)/2) .*(abs(t-11)<2);
x3=1*(t==15) + 1*(t==17);


x=x1+x2+x3;
%x=20+x1+x2+x3; % sygnal na krancach nie schodzi sie do zera, nalezy
%recznie obnizyc amp. przy stosowaniu filtra avg i gauss, lub odciac krance
%x=sin(2*pi*t/2);

N=51;

% zaszumianie sygnalu
xs=x+0.05*randn(size(t));
%xs=imnoise(x, 'salt & pepper'); % szum impulsowy, tylko mediana



%stworzenie przestrzni metrycznej
%najpier ^2, potem sumowanie
%L2=@(x_or, x_od) (    sqrt   (  sum((x_or-x_od).^2) )  / length(x_od) );

L2=@(x_or, x_od) (  sqrt(  sum((x_or-x_od).^2))    /length(x_od));
wynik=zeros(51,4);

for n=1:51
    N=2*n+1;
    %conv-splot
    %nie robic za duzych filtrow, powoduje degeneracje sygnalu
    %filtracje liniowe:
    % 1. filtracja usredniajaca
    x_avg=conv(xs, ones(1,N)/N, 'same');
    % 2. srednia wazona, filtr gaussa
    maska=fspecial('gaussian', [1,N], N/4);
    x_g=conv(xs,maska,'same');

    %subplot(211), plot(t,xs,'r', t,x_avg, 'g', t,x_g,'b');
    %delta diraca element neutralny dla splotu

    %filtry usredinajace zaokraglaja wierzcholki


    %filtracje nieliniowe:
    % 1. medianowa
    x_med=medfilt1(xs,N);
    % 2. adaptacyjna wieniera
    x_wnr=wiener2(xs, [1,N]);
    
    %subplot(212), plot(t,xs,'r', t,x_med,'g', t,x_wnr,'b');
    
    
    wynik(n,1) = L2(x,x_avg);
    wynik(n,2) = L2(x,x_g);
    wynik(n,3) = L2(x,x_med);
    wynik(n,4) = L2(x,x_wnr);
end

prog=2*(1:51)+1;
plot(prog, wynik); %najlepszy filter o najwiekszym minimum
legend('avg', 'gauss', 'median', 'wnr');
%wniosek najlepszy filter wienier, w oknie ok.20 (dla tego sygnalu i szumu)


%plot(t,x);





