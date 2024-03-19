% filtracja i korelacja sygnalow

%% stowrzenie sygnalu danego funkcja
% sygnal 3i*sign(2t) + 4*t dla t>=0
% t = <-3,5>, Fs=20
close all; clear; clc;
Fs = 20;
t0 = -3;
tk = 5;
dt = 1/Fs;

t = t0 : dt : tk;

x = 3i*sign(2*t) + 4*t.*(t>=0);

plot(t,real(x), 'g', t, imag(x), 'b');

mean(x)
sum(x.^2)/Fs

%% sygnal prostokatny dany funkcja
% t =<0,10>, fs =100
% x = prostokatny, szer = 4s, amp=2, srodek=5s
close all; clear; clc;
Fs = 100;

t =  0 : 1/Fs : 10;

x = 2 * (abs (t-5)<=2);

N=31;   %rozmiar filtra
x2=ones(1,N)/N; %filter

%xx=conv(x,x,'same'); %zlozenie 2 prostokatnych sygnalow zawsze f.trojkatna
xx=conv(x,x2,'same'); %rozmycie, srednia

plot(t,x,t,xx);
ylim([-0.5, 2.5]);

%% filtracja dolnoprzepustowa
close all; clear; clc;
Fs = 100;

t =  0 : 1/Fs : 10;

x = 2 * (abs (t-5)<=2);

xs = x + 0.1*randn(size(t)); %szum

N=5;
x2=ones(1,N)/N; %filter

xx=conv(x,x2,'same');

plot(t,xs,'r',t,xx,'g');
ylim([-0.5, 2.5]);

%% filtracja gornoprzepustowa
close all; clear; clc;
Fs = 100;

t =  0 : 1/Fs : 10;

x = 2 * (abs (t-5)<=2);

%x2 = [1 0 -1]/2; %filter 1 pochodna, predkosc zmian
x2 = [1 -2 1]; %filter 2 pochodna, przyspieszenie

xx=conv(x,x2,'same');

subplot(211), plot(t,x,'r');
subplot(212), plot(t,x, 'r', t, xx, 'g');
ylim([-0.5, 2.5]);

%% modelowanie fizyczne
close all; clear; clc;
% t = <0,10>s, Fs = 100;
%x1(t) - sza o okresie 2s amp=1;
% wierzcholkach dla nieparzystych czasow
% x2 - funkcja gaussa, amp =1, sr =5, odch=1
% x1, x2 splot x*x2

Fs = 100;
amp = 1;
odch = 0.1;

t = 0 : 1/Fs : 10;

x1 = (mod(t+1,2) == 0);
%x = (1/(odch*(2*pi)^1/2)) * exp(-(t-5)^2/));
x2 = exp(-(t-5) .* (t-5)/(2*odch*odch));

xx = conv(x1,x2, 'same');

plot(t,x1, 'r', t, x2, 'g', t, xx, 'b');


%% korelacja
close all; clear; clc;
x = [-3+1i, 1+4i, 1-2i, -3+3i];
y = [2+2i, 0, -2+2i];
conv(x,y);
xcorr(x,y)

%% korelacja 2
close all; clear; clc;
% t=<0,10>, fs=100;
% x1= trojkatny, tw =3, szer =4, amp=1
% x2 = trojkatny, tw =6, szer =2, amp=1

Fs=100;

t= 0: 1/Fs : 10;

x1 = 1*(1-abs(t-3)/2) .*(abs(t-3)<=2);
x2 = 1*(1-abs(t-6)/1) .*(abs(t-6)<=1);

subplot(211), plot(t,x1, 'r', t, x2, 'g');

xx = conv(x1,x2,'same');
xx2 = xcorr(x2,x1);

tc = -10 : 1/Fs : 10; %korelacja zwraca podwojny wektor, koniecznosc zmiany na tc

subplot(212), plot(t,xx,'r', tc,xx2,'g');

%2 wykres miara przesuniecia sygnalow wzgledem siebie
%o ile trzeba presunac wykres by byly w tej samej fazie

%% Znalezienie trojkata
close all; clear; clc;
 a= load('Data/2022_corr_01.txt');
 Fs = 100;
 N=length(a);
 t = (0:N-1)/Fs;
 x=a';
 plot(t,x);


 %t2 = 0:1/Fs:4;
 %pros = 0.9*ones(size(t2));

 t2 = 0:1/Fs:4;
 troj = 1.2*(1-abs(t2-2)/2);

 subplot(211);
 plot(t,x,'b',t2, troj, '.r');



 %xc=xcorr(x,pros);
 xc= xcorr(x,troj) + 0.5*xcorr(1.2-x, 1.2-troj);
 tc = (-N+1:N-1)/Fs; %wektor czasu korelacji
 %tc = -49:1/Fs:49;

 subplot(212),  plot(tc,xc,'b');

 nr = find(xc == max(xc(:)), 3, 'first')
 %nr = find(xc > 0.9999 * max(xc(:)), 3, 'first')
 tc(nr);

%czasy 2 trojkatow

