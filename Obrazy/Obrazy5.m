%% Przeksztalcenia morfologiczne
%% Erozja i dylacja
close all; clear; clc;

SE1 = strel('disk', 5);
SE2 = strel('line', 10, 30); %dlugosc, nachylenie
SE3 = strel('arbitrary', [1 0 1; 1 0 1; 1 1 1; 1 0 1; 1 0 1]);
%a = imread("circles.png"); %czarno-bialy
a = imread('cameraman.tif');    %monochromatyczny

% erozja
% a1 = imerode(a, SE1);
% a2 = imerode(a, SE2);
% a3 = imerode(a, SE3);

% dylacja
a1 = imdilate(a, SE1);
a2 = imdilate(a, SE2);
a3 = imdilate(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3); 

%% Otwarcie
close all; clear; clc;

SE1 = strel('disk', 5);
%SE2 = strel('line', 10, 30);
SE2 = ones(9, 1); %usuniecie poziomych lini
SE3 = strel('arbitrary', [1 0 1; 1 0 1; 1 1 1; 1 0 1; 1 0 1]);

%a = imread("circles.png");
%a = imread('cameraman.tif');    
a = imread('blobs.png');

%otwarcie
a1 = imopen(a, SE1);
a2 = imopen(a, SE2);
a3 = imopen(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3); 


%% Zamkniecie
close all; clear; clc;

SE1 = strel('disk', 5);
SE2 = strel('line', 10, 30); 
SE3 = strel('arbitrary', [1 0 1; 1 0 1; 1 1 1; 1 0 1; 1 0 1]);

%a = imread("circles.png"); 
%a = imread('cameraman.tif');
a = imread('blobs.png');

%zamkniecie
a1 = imclose(a, SE1);
a2 = imclose(a, SE2);
a3 = imclose(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3); 

%% Gradient morfologiczny
close all; clear; clc;

SE1 = ones(3);
SE2 = strel('arbitrary', [0 1 0; 1 1 1; 0 1 0]);

%a = imread("circles.png"); 
a = imread('cameraman.tif');

%gradienty
a1 = imdilate(a, SE1)-a;                    %krawedz zewnetrzna
a2 = a-imerode(a, SE1);                     %krawedz wewnetrzna
a3 = imdilate(a, SE1)-imerode(a, SE1);      %sum krzwedzi zew i wew
a4 = edge(a,'canny');


subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a4); 

%% Rekonstrukcja morfologicyna (dylacja geodezyjna)
%Odleglosc geodezyjna - najkrutsza odl. laczaca 2 punkty, bedaca w czlosci
%w obiekcie
close all; clear; clc;
%Estymata odleglosci
%Start w=24, k=228
%Meta w=85, k=253

a = imread('Data/dziury.bmp');

marker = false(size(a));
marker(24, 228) = true;

SE=true(3);
%SE=[0 1 0; 1 1 1; 0 1 0];

iter=0;
while ~marker(85, 253)
    marker = imdilate(marker, SE)&a;
    iter=iter+1;
end

imshow(marker);
iter

%imreconstruct(marker, obraz)
%imclearborder(obraz)
%imfill(obraz, 'holes')

%% Hit or miss
% Zamikania figur wkleslych na wypukle
% Obraz 128x128, na nim litera L (20 szerokosc)
a = zeros(128,128);

a(25:104, 35:54)=1;
a(85:104, 55:94)=1;

SE1 = [1 1 1; 1 -1 0; 0 -1 0];
SE2 = [1 1 0; 1 -1 0; 1 0 -1];

b = false(size(a));

while ~isequal(a,b)
    b = a;
    for n=1:4
        a = a | bwhitmiss(a, SE1);
        a = bwmorph(a, 'clean');
        a = a | bwhitmiss(a, SE2);
        a = bwmorph(a, 'clean');
        SE1 = rot90(SE1);
        SE2 = rot90(SE2);
    end
end

imshow(a);

%% scieranie, szkieletyzacja, pogrubianie
close all; clear; clc;
a = imread('circles.png');
a1=bwmorph(a,'thin', Inf);
a2=bwmorph(a, 'thicken', Inf);
a3=bwmorph(a, 'skel', Inf);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);