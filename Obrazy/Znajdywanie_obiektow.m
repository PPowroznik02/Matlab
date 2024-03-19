%% Znalezienie monet
close all; clear; clc;
monety = imread("coins.png");
imshow(monety);
bin = monety > 90;

bin = medfilt2(bin,[3,3]);

[aseg, N] = bwlabel(bin);

pole = zeros(N,1);
for k = 1 : N
   tt = (aseg ==k);
   pole(k,1) = sum(tt(:));
end
sort(pole)

prog = 2500;
wynik = 0*monety;
for k = 1: N
   tt = (aseg==k);
   if pole(k) > prog
       wynik = wynik + uint8(tt).*monety;
   end
end

subplot(122),imshow(wynik);
subplot(121),imshow(monety);

%% znalezienie roznych obiektow na zdjeciu
close all; clear; clc;
[map, leg] = imread("Data/w_shape.png");

a = map ~= 11;

subplot(121), imshow(a);

[aseg, N] = bwlabel(a);

pp = regionprops(aseg, 'all');
kola = zeros(size(a));
gwiazdki = zeros(size(a));
prostokaty = zeros(size(a));
strzaleczka = zeros(size(a));
trojkaty = zeros(size(a));
elipsy = zeros(size(a));

BWK = zeros(size(a));

for k=1:N
    tmp = aseg == k;
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));

    bwk = 4*pi*pole/(obw^2);
    
    BWK = BWK + bwk.*tmp;

    if abs(bwk - 1) < 0.04
        kola = kola | tmp;
    end


    polePros = pp(k).BoundingBox(3) * pp(k).BoundingBox(4);
    if abs(pole - polePros) < 0.04 & abs(bwk - pi/4) > 0.04
        prostokaty = prostokaty | tmp;
    end

    if bwk > 0.23 & bwk < 0.27 & pp(k).EulerNumber == 1
        gwiazdki = gwiazdki | tmp;
    end
        

    if bwk > 0.40 & bwk < 0.43
        strzaleczka = strzaleczka | tmp;
    end

    boundingPole = pp(k).BoundingBox(3) * pp(k).BoundingBox(4);
    if bwk > 0.48 & bwk < 0.64 & abs(pole - boundingPole) > 0.04
        trojkaty = trojkaty | tmp;
    end

    poleEli = pi*pp(k).MinorAxisLength * pp(k).MajorAxisLength/4; 
    if abs(pole/poleEli - 1) < 0.04 & bwk <0.9
        elipsy = elipsy | tmp;
    end
end

trojkaty = trojkaty .* ~elipsy;

subplot(122), imshow(trojkaty);

%imagesc(BWK);

%% Znajdywanie monet
close all; clear clc;
%znalezienie groszowek
a= imread('Data/monety.png');

bin = a(:,:,1) < 110;
bin = bwfill(bin, 'holes');
bin = bwareaopen(bin, 200);

tmp = imerode(bin, strel('disk', 20));
tmp = bwdist(tmp);
tmp = watershed(tmp);

bin = bin.*(tmp > 0);
bin = bwareaopen(bin, 200);
subplot(121), imshow(a);


[aseg, N] = bwlabel(bin);
pp = regionprops(bin, 'all');


BWK = zeros(size(bin));
pola = zeros(size(bin));
gr1 = zeros(size(bin));
gr2 = zeros(size(bin));
gr5 = zeros(size(bin));
gr = zeros(size(bin));


for k=1:N
    tmp = aseg == k;
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));

    bwk = 4*pi*pole/(obw^2);

    BWK = BWK + bwk.*tmp;
    pola = pola + pole.*tmp;

    if abs(bwk - 1) < 0.07 & pole < 3000 & pole > 2400
        gr5 = gr5 |tmp;
    end

    
    if abs(bwk - 1) < 0.07 & pole < 2400 & pole > 1700
        gr2 = gr2 |tmp;
    end

     if abs(bwk - 1) < 0.09 & pole < 1700 & pole > 500
        gr1 = gr1 |tmp;
    end

end

wynik = imoverlay(a, bwperim(gr1), 'r');
wynik = imoverlay(wynik, bwperim(gr2), 'g');
wynik = imoverlay(wynik, bwperim(gr5), 'b');

subplot(122), imshow(wynik);


%% znalezienie 6 najwiekszych monet
close all; clear; clc;
a = imread('coins.png');

bin = a(:,:,1) > 80;
bin = bwareaopen(bin, 100);

subplot(121), imshow(bin);

[aseg, N] = bwlabel(bin);

pp = regionprops(aseg, 'all');

pola = zeros(N,1);
wynik = 0.*a;

for k=1:N
    tmp = aseg == k;
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));
    
    pola(k,1) = pole;
end

sortPola = sort(pola)
sortPola(N-6,1)

for k=1:N
    tmp = aseg ==k;
    pole = sum(tmp(:));

    if pole > sortPola(N-6,1)
        wynik = wynik + uint8(tmp) .*a;

    end
end

subplot(122), imshow(wynik);



%% Znajdywanie roznych obiektow
close all; clear; clc;
a = imread('Data/figury.png');
a = rgb2gray(a);
a = imadjust(a);

subplot(121), imshow(a);

bin1 = a(:,:,1) > 215;
bin1 = bwareaopen(bin1, 1000);
bin2 = a(:,:,1) < 77;
bin2 = bwareaopen(bin2, 100);
bin3 = a(:,:,1) == 105;
bin3 = imopen(bin3, ones(5));
bin4 = a(:,:,1) == 179;
bin4 = imopen(bin4, ones(5));
bin5 = a(:,:,1) == 150;
bin5 = imopen(bin5, ones(5));
bin6 = a(:,:,1) == 136;
bin6 = imopen(bin6, ones(5));

bin = bin1 | bin2 | bin3 | bin4 | bin5 | bin6;

subplot(122), imshow(bin);


[aseg, N] = bwlabel(bin);
pp = regionprops(bin, "all");

BWK = zeros(size(a));
POLA = zeros(size(a));
PdoO = zeros(size(a));
gwiazdki = zeros(size(a));
literki = zeros(size(a));
spirala = zeros(size(a));
prostokaty = zeros(size(a));
trojkaty = zeros(size(a));
elipsy = zeros(size(a));

for k=1:N
    tmp = aseg == k;
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));

    bwk = 4*pi*pole/(obw^2);

   POLA = POLA + pole.*tmp;
   BWK = BWK + bwk.* tmp;
   PdoO = PdoO + (pole/obw) .*tmp;

   if bwk > 0.26 & bwk < 0.39 & pp(k).EulerNumber == 1
       gwiazdki = gwiazdki | tmp;
   end

   if bwk > 0.2 & bwk < 0.28 & pp(k).EulerNumber == 0 & pole < 3000
       literki = literki | tmp;
   end

   if pole/obw < 10 & pp(k).EulerNumber == 1
       spirala = spirala | tmp;
   end

    if bwk > 0.55 & bwk < 0.8 
        prostokaty = prostokaty | tmp;
    end

    poleTroj = pp(k).BoundingBox(3) * pp(k).BoundingBox(4)/2;
    if abs(poleTroj/pole - 1) < 0.04
        trojkaty = trojkaty | tmp;
    end
    pole2 = pp(k).BoundingBox(3) * obw/6;

    
end


wynik = imoverlay(a, trojkaty, 'r');

subplot(122), imshow(wynik);

%imagesc(PdoO);
