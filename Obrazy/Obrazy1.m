%% Rozjasnianie i przyciemnianie obrazow
% konwersja na double i uint8
close all; clear; clc;
a=imread('cameraman.tif');
%b=a+50; % rozjasnienie
%b=b-100;
%b=b+50; % po wielokrotnym dodawaniu i odejmowaniu obraz nie wraca do stanu poczatkowego

b=double(a)/255; %przejscie na double (z unint8)
a=uint8(b*255); %przejscie na uint8 (z doubli)

subplot(122), imshow(b);
subplot(121), imshow(a);

%% Porownanie obrazu w roznych pasmach
% tworzenie obrazu indeksowanego
close all; clear; clc;
a=imread('peppers.png');
% w konsoli imtool(a), dla monochromatycznych przydatna zmiana palety

% zestawienie obrazow dla roznych pasm
% r=a(:,:,1);
% g=a(:,:,2);
% b=a(:,:,3);
% subplot(221), imshow(a);
% subplot(222), imshow(r);
% subplot(223), imshow(g);
% subplot(224), imshow(b);

% subplot(221), imshow(a);
% for k=1:3
%     subplot(2,2,k+1); imshow(a(:,:,k));
% end

% obraz indeksowany
[map, leg]=rgb2ind(a,350);
b=ind2rgb(map, leg);
subplot(121), imshow(a);
subplot(122), imshow(b);

%% zminiejszanie i zwiekszanie rozdzielczosci obrazow
% zastosowanie interpolacji (3 zaimplementowane metody)
close all; clear; clc;


a=checkerboard(4,4,4);
%a=imread('peppers.png');
subplot(221), imshow(a);

skala=0.7;
%jesli obraz ideksowany to TYLKO metoda najblizszego sasiada
%jesli obraz ciagly to biliniowa, bikubiczna (najblizszego sasiada daje ostre przejscia)
a1=imresize(a, skala, 'nearest');  
a2=imresize(a, skala, 'bilinear');
a3=imresize(a, skala, 'bicubic');

subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

%% Korekcja gamma obrazu
close all; clear; clc;
% wykonac gamme dla [0.1, 0.2, 0.5, 1, 2, 4]
% wyniki wyswietlic w fig (2wx3k)

a=imread('cameraman.tif');
a=double(a)/255;    %konwersja na double, bo intow nie mozana podnosic do potegi <1
gam=[0.1 0.2 0.5 1 2 4];

for k=1:6
    subplot(2,3,k);
    b=a.^gam(k);
    imshow(b);
    title(['\gamma = ', num2str(gam(k))]);
end

%% Normalizacja obrazu (rozciagniecie histogramu)
close all; clear; clc;


a=imread('pout.tif');
subplot(221), imshow(a);

b=imadjust(a);
subplot(222), imshow(b);
subplot(223), imhist(a);
subplot(224), imhist(b);

%% Wyrowanie histogramu
close all; clear; clc;


a=imread('pout.tif');
a=rgb2gray(imread('saturn.png'));
subplot(221), imshow(a);

b=histeq(a,128);
subplot(222), imshow(b);
subplot(223), imhist(a);
subplot(224), imhist(b);