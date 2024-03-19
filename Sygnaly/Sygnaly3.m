%% trasa sejsmiczna
close all; clear; clc;
a=load('Data/sejs_2.txt');
Fs=400;
[Np, NRP]=size(a); %Np-n probek, NRP-number of recived points
t=(0:Np-1)/Fs;
figure;
hold on;
for k=1:NRP
        plot(t, a(:,k)+k-1);
end;
hold on;

for k=1:(NRP-1)
    xc=xcorr(a(:,k), a(:,k+1)); 
    %max_cor(k)=max(cor);
    
    nr=find(xc == max(xc(:)), 1, 'first'); %znalezienie maksimum
    FB(k)=nr; %zapisanie max do wektora, przesuniecie pomiedzy probkami
end

%(FB/Fs) - czas
v=25./(FB/Fs); %predkosci w okolicy 20 - predkosc refraktora w okolicy 20 

%% Szereg Fouriera 1, rozwiniecie sygnalu w SF
close all; clear; clc;
Fs=100;
t=-4:1/Fs:4;
x=3*(abs(t)<=2);
%plot(t,x);

XT=1.5*ones(size(t)); %wektor o dlugosi czasu

for n=1:200 
    an=6*sin(n*pi/2)/(n*pi);
    XT=XT+an*cos(n*pi*t/4);
end

%dla n parzystych i nieparzystych ten sam wykres
plot(t,x,'.g', t, XT, 'r'); %Oscylacje w punktach nieciaglosci

%% Szereg Fouriera 2
close all; clear; clc;
Fs=100;
t=-3:1/Fs:3
x=1*(1-abs(t)/2).*(abs(t) < 2);

%plot(t,x);
XT=ones(size(t))/3;

for n=1:200
    an=3*(1-cos(2*n*pi/3))/(n^2*pi^2);
    XT=XT+an*cos(n*pi*t/3); % update
end

plot(t,x, '.g', t, XT, 'k');
    

%% Szereg Fouriera 3
close all; clear; clc;
Fs=100;
t=0:1/Fs:6;
%x=(t<=2)+1*(t>2 & t<=4)+2*(t>4 & t<=6);
x=1*(t>2 & t<=4) +2*(t>4); 
plot(t,x);
    
XT=ones(size(t));

for n=1:200
    bn=2*(cos(2*n*pi/3)-1)/(n*pi);
    XT=XT+bn*sin(n*pi*t/3); % update
end

plot(t,x, '.g', t, XT, 'k');
    