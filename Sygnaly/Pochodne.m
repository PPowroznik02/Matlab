%% pierwsza i druga pochodną dla sygnału 2022_corr_1.txt
close all; clear; clc;

a=load('2022_corr_01.txt');
N=length(a);
Fs=100;
t=(0:N-1)/Fs;
x=a';

HP1=[1 0 -1]; %1poch
HP2=[1 -2 1]; %2poch

xx1=conv(x,HP1,'same');
xx2=conv(x,HP2,'same');

subplot(211), plot(t,x,'b', t,xx1,'r');
subplot(212), plot(t,x,'b', t,xx2,'r');
