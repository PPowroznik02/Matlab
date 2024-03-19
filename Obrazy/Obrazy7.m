%% znalezienie kol
close all; clear; clc;

[map, leg] = imread('Data/w_shape.png'); % wczytanie mapy i legendy

a = ind2rgb(map,leg); %przekonwertowanie na obraz rgb

subplot(121), imshow(a);

bin = (map~=11); %latwiej binaryzowac na indeksach

%subplot(122), imshow(bin);

kola = false(size(bin)); %stworzenie pustej tablicy o rozmiarze obrazu

[aseg, N] = bwlabel(bin);


for k=1:N
    tmp = (aseg==k);
   
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));
    
    bwk = 4*pi*pole/(obw^2);
    
    if abs(bwk-1)<0.04
        kola = kola | tmp;
    end
   
end

subplot(122), imshow(kola);

%% znbalezienie kwadratow
close all; clear; clc;
[map, leg] = imread('Data/w_shape.png'); % wczytanie mapy i legendy

a = ind2rgb(map,leg); %przekonwertowanie na obraz rgb

subplot(121), imshow(a);

bin = (map~=11); %latwiej binaryzowac na indeksach

%subplot(122), imshow(bin);

kwadraty = false(size(bin)); %stworzenie pustej tablicy o rozmiarze obrazu

[aseg, N] = bwlabel(bin);


for k=1:N
    tmp = (aseg==k);
   
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));
    
    bwk = 4*pi*pole/(obw^2);
    
    if abs(bwk-(pi/4)) < 0.03
        kwadraty = kwadraty | tmp;
    end
   
end

subplot(122), imshow(kwadraty);
%% Znalezienie elips
close all; clear; clc;
[map, leg] = imread('Data/w_shape.png'); % wczytanie mapy i legendy

a = ind2rgb(map,leg); %przekonwertowanie na obraz rgb

subplot(121), imshow(a);

bin = (map~=11); %latwiej binaryzowac na indeksach

%subplot(122), imshow(bin);

elipsy = false(size(bin)); 
kola = false(size(bin));

[aseg, N] = bwlabel(bin);

pp = regionprops(aseg, 'all'); % zwraza wszystkie wlasciwosci obiektow

for k=1:N
    tmp = (aseg==k);
   
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));
    
    bwk = 4*pi*pole/(obw^2);
    
    if abs(bwk-1)<0.04
        kola = kola | tmp;
    end

    pole_el = pi*pp(k).MajorAxisLength * pp(k).MinorAxisLength/4;
    if abs(pole/pole_el-1) <0.02
        elipsy = elipsy | tmp;
    end
    
end
elipsy = elipsy & (~kola); %odjecie kol

subplot(122), imshow(elipsy);

%% Znalezienie gwiazdek
close all; clear; clc;
[map, leg] = imread('Data/w_shape.png'); % wczytanie mapy i legendy

a = ind2rgb(map,leg); %przekonwertowanie na obraz rgb

subplot(121), imshow(a);

bin = (map~=11); %latwiej binaryzowac na indeksach

%subplot(122), imshow(bin);

gwiazdki = false(size(bin)); 
elipsy = false(size(bin)); 
kola = false(size(bin));
trojkaty = false(size(bin));
trojkaty2 = false(size(bin));

[aseg, N] = bwlabel(bin);

pp = regionprops(aseg, 'all'); % zwraza wszystkie wlasciwosci obiektow
BWK = zeros(size(bin));
for k=1:N
    tmp = (aseg==k);
   
    pole = sum(tmp(:));
    obw = bwarea(bwperim(tmp));
    
    bwk = 4*pi*pole/(obw^2);
    BWK= BWK + bwk*tmp;
    
    if abs(bwk-1)<0.04
        kola = kola | tmp;
    end

    pole_el = pi*pp(k).MajorAxisLength * pp(k).MinorAxisLength/4;
    if abs(pole/pole_el-1) <0.02
        elipsy = elipsy | tmp;
    end
    
    if bwk >0.24 & bwk<0.27 & pp(k).EulerNumber > 0
        gwiazdki = gwiazdki |tmp;
    end
    
    pole_troj = 0.5*pp(k).BoundingBox(3)*pp(k).BoundingBox(4);
    
    if bwk > 0.49 & bwk < 0.64 & abs(pole/pole_troj - 1) < 0.02
        trojkaty = trojkaty | tmp;
    end
     %drugi sposob na trojkaty
    if abs(pole/pole_troj - 1) < 0.02 & pp(k).EulerNumber>0 & pp(k).Solidity>0.8
            trojkaty2 = trojkaty2 | tmp;
    end
    
    
end
elipsy = elipsy & (~kola); %odjecie kol
trojkaty = trojkaty & (~elipsy);

subplot(122), imshow(trojkaty2);

%figure;
%imagesc(BWK), axis image %gwizdki wartosci 0.44 - 0.47

%% znalezienie lini na obiekcie
close all; clear; clc;

a = imread("Data/ebsd_12.png");
a = double(a)/255;
[Nz, Nx] = size(a);

XT = fftshift(fft2(a));

WA=abs(XT);

fx = linspace(-0.5, 0.5, Nx);

[FX, FZ] = meshgrid(fx,fx);

f = sqrt(FX.^2 + FZ.^2);

BS = 1./(1+(0.01*f./(f.^2-0.066^2)).^4);
an=real(ifft2(ifftshift(BS.*XT)));

%imshow(an);
an = imadjust(an);
bin = (an > 0.9) | (an <0.5);
bin = imclearborder(bin);

bin = imclose(bin, ones(3));
bin = bwareaopen(bin, 50);

bin = imopen(bin, ones(2));
bin = imclose(bin, ones(3));


bin = bwmorph(bin, 'thin', inf);
bin = bwmorph(bin, 'spur', 4);
imshow(bin);

[H,T,R] = hough(bin);

pik = houghpeaks(H, 10, 'threshold', 0.25*max(H(:)));

lin = houghlines(bin, T, R, pik);

Nlin = size(pik,1);

imshow(a); hold on;

for k = 1:Nlin
    line([lin(k).point1(1), lin(k).point2(1)], ...
        [lin(k).point1(2), lin(k).point2(2)], 'color', 'r');
end


%ab = imoverlay(a, bin, 'r');
%subplot(121), imshow(ab);
%subplot(122), imshow(bin);

%hoff, hoffpicks, hofflines

%imagesc(fx,fx, log(WA + 0.001)); axis equal