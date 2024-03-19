%Wyznaczanie odleglosci
close all; clear; clc;

a=zeros(200);
a(08, 124)=1;
a(56, 17)=1;
a1 = bwdist(a, 'euclidean');
a2 = bwdist(a, 'quasi-euclidean');
a3 = bwdist(a, 'cityblock');

a4 = bwdist(a, 'chessboard');

subplot(221), imagesc(a1); axis equal; colorbar('vertical');
subplot(222), imagesc(a2); axis equal; colorbar('vertical');
subplot(223), imagesc(a3); axis equal; colorbar('vertical');
subplot(224), imagesc(a4); axis equal; colorbar('vertical');

% linia rownej odleglosci odpowiada granicy dzialu wodnego

%% Wyznaczanie obszrow
% Chce miaszkac w lesie
% odleglosc od drogi glownej > 20px
% odleglosc od drogi pobocznej < 10px
% woda > 15px
close all; clear; clc;

a = imread('Data/new_map.bmp');
subplot(121), imshow(a);
las = a(:,:,1)==185 & a(:,:,2)==215 & a(:,:,3)==170;
%subplot(122), imshow(las);

dg = a(:,:,1)==255 & a(:,:,2)==245 & a(:,:,3)==120;
dg = imclose(dg, ones(1,3)); %usuniecie dziury
%subplot(122), imshow(dg);

dp = a(:,:,1)==255 & a(:,:,2)==255 & a(:,:,3)==255;
dp = medfilt2(dp, [3,3], 'symmetric'); %filtracja by polaczyc nieciagle fragmenty drogi i usunac elementy do niej nienalezace
%subplot(122), imshow(dp);

%takie samo progowanie zastosowac w projekcie
woda = a(:,:,1)>60 & a(:,:,2)>155 & a(:,:,3)>200;
woda = woda & a(:,:,1)<164 & a(:,:,2)<215;
%subplot(122), imshow(woda);

wynik = las & bwdist(dg)>20 & bwdist(dp)<10 & bwdist(woda)>15;
wynik = imoverlay(a, wynik, 'r'); %naklada na obraz kolorowy obraz binarny w danym kolorze
subplot(122), imshow(wynik);

%% wattershed (dzialwodny)
% 2 metody: liczenie watersheda na zewnatrz i wewnatrz(konieczne rozdzielenie obiektow)
close all; clear; clc;
%metoda automatyczna
a = zeros(200,300);
a(100, [100, 200])=1;
a = bwdist(a)<55;
imshow(a);

d=-bwdist(~a);
L=watershed(d);

a = a&(L>0);

%imagesc(L);
imshow(a);

%% wattershed (dzialwodny)
close all; clear; clc;
%metoda przez erozje, nie autowatyczna, unkniecie szatkowania obrazu jak
%moze to byc w automatycznej
a = zeros(200,300);


a(100, [100, 200])=1;
a = bwdist(a)<55;
subplot(121), imshow(a);

d = imerode(a, strel('disk', 30));
d = bwdist(d);
L=watershed(d);

a = a&(L>0);

%imagesc(L);
subplot(122), imshow(a);

%% Znalezienie monet na obrazie
close all; clear; clc;
% 1. Akwizycja
% 2. Przetwarzanie wstepne
% 3. Segmentacja (np. binaryzacja)
% 4. Analiza (pole, obwod, wsp. ksztaltu)
% 5. Wizualizacja 
% all. Na kazdym etapie konieczna weryfikacja!

% zadanie
% policz liczbe monet
% znajdz 5 najwiekszych monet (wykorzystac etykietowanie)

a = imread('coins.png');
%a=double(a)/255;

bin = a(:,:,1)>95;
bin = imfill(bin, 'holes');

%etykietowanie
[aseg, N] = bwlabel(bin);
N %ilosc monet
imagesc(aseg);

pole = zeros(N,1);
for k = 1:N
    moneta = (aseg==k);
    pole(k,1) = sum(moneta(:));
    
end

pole2 = sort(pole);
th = pole2(N-5);

wynik = zeros(size(a), 'uint8');
for k=1:N
    if pole(k)>th
        wynik = wynik + uint8(aseg==k) .*a;
    end
end

imshow(wynik);

%% Histogramy pol i obwodow ziaren
close all; clear; clc;

a = imread('rice.png');

b = imtophat(a, strel('disk', 11)); %wyrowanie tla, wymaga duzych elementow strujturalnych (bothat(), ciemne ziarna na jssnym tle)
b = imadjust(b);
%subplot(121), imshow(b);

bin = b(:,:,1)>90;
bin = bwmorph(bin, 'clean');
bin = bwareaopen(bin, 10);

%sprawdzenie ile tracimy z obrazu
kj = uint8(bin).*a;
jk = uint8(~bin).*a;
%subplot(121), imshow(kj);
%subplot(122), imshow(jk);


%watershed rozdzielenie ziaren
d = imerode(bin, strel('disk', 3));
d = bwdist(d);
bin = bin & (watershed(d)>0);
bin = imclearborder(bin);

%subplot(122), imshow(bin);

%etykietowanie
[aseg, N] = bwlabel(bin);
N

pola = zeros(N,1);
obwody = zeros(N,1);
for k = 1:N
    tmp = (aseg==k);
    pola(k,1) = sum(tmp(:));
    obwody(k,1) = bwarea(bwperim(tmp));
end

% na hist nie ma wartosci odstajacych
% nie ma elm o plowe wiekszych, patrzyc na odch, sr, max, min
subplot(121), histogram(pola);
subplot(122), histogram(obwody);
