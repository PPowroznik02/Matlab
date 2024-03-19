%% znalezienie litery e
close all; clear; clc;
a=imread('text.png');

w=a(31:46, 85:100);     %zmienna w jest wzorcem do wyszukiwania

subplot(121), imshow(a);
subplot(122), imshow(w);

xc=real(ifft2(fft2(a) .* fft2(rot90(w,2), 256,256) ));  %podwojna rotacja (180st)+ rozszerzenie do wymiarow obrazka
th=0.9999*max(xc(:));   %ustawienie jakiegosc progu, szukamy wartosci max
wynik=xc>th;
%wynik=imdilate(wynik, ones(5)); %powieksza rozmiar

subplot(122), imagesc(wynik);


%%  znalezienie litery r
close all; clear; clc;
a=imread('text.png');


w=a(11:23, 62:71);     %zmienna w jest wzorcem do wyszukiwania 


subplot(121), imshow(a);
subplot(122), imshow(w);

xc1=real(ifft2(fft2(a) .* fft2(rot90(w,2), 256,256) ));  %podwojna rotacja (180st)+ rozszerzenie do wymiarow obrazka
xc2=real(ifft2(fft2(1-a) .* fft2(rot90(1-w,2), 256,256) )); %zrobienie negacji obrazu, by znajdywac tylko cale obiekty

xc=xc1+xc2;     %dodanie negacji

th=0.9999*max(xc(:));   %wprowadzenie bleadu numerycznego, ustawienie jakiegosc progu, szukamy wartosci max
wynik=xc>th;
wynik=imdilate(wynik, ones(5)); %

subplot(122), imagesc(wynik);

%rozpoznawanie tekstu robi sie przez szkieletyzacje (operzaje na grafach)

%fourier zastosowania: filtracja i korelacja

%% dct2 (discrete fourier transform)
close all; clear; clc;
% stworzyc 3 filtry LP dla r: 10, 25, 100
% przefiltrowac obraz
a=imread('cameraman.tif');
A=dct2(a);
[Nz, Nx]=size(a);


fx=0:Nx-1;
fz=0:Nz-1;   

[FX, FZ]=meshgrid(fx, fz);
f=sqrt(FX.^2 + FZ.^2);

% imagesc(f)

subplot(221), imshow(a);
th=[10 25 100];
for k=1:3
    LP=1.0*(f<th(k));
    an=uint8(idct2(LP.*A));
    subplot(2,2,k+1), imshow(an);   %te same efekty co dla FFT2
end


%% Kompresja JPEG'92
% zmiana prestrzenie barw RGB->YCbCr (lepsza kompresja) [UINT8]
% przesuniecie sredniej do zera (nie liczyc sr tylko na sztywno odjac -128)
% [DOUBLE]
% downsamplig (my tego nie robimy, problem z interpolacja)
% podzielenie siatki wszystkich kanalow na bloki 8x8
% w tych blokach zrobic dct2
% podzielic przez tablice /Qc, /Qy (przez nie sterueje sie kompresja)
% zaokraglenie (najwieksz stratnosc)
% zigzak (szczytywanie) (nie robimy)
% zapis (nie robimy)
 
% zrobic kompresje nastepnie dekompresje
Qy=[16 11 10 16 24 40 51 61
12 12 14 19 26 58 60 55
14 13 16 24 40 57 69 56
14 17 22 29 51 87 80 62
18 22 37 56 68 109 103 77
24 35 55 64 81 104 113 92
49 64 78 87 103 121 120 101
72 92 95 98 112 100 103 99];

Qc=[17 18 24 47 99 99 99 99
18 21 26 66 99 99 99 99
24 26 56 99 99 99 99 99
47 69 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99];

%mnozenie Qc 0:1
%mnozenie Qy

Qy=888*Qy;    %zmniejszenie ilosci kolorow
Qc=1*Qc;  %wyzerowanie Qc daje monochrom


a=imread('peppers.png');
[Nz, Nx, k]=size(a);


b=rgb2ycbcr(a);

b=double(b)-128;


for kz=1:8:Nz
    for kx=1:8:Nx
        for k=1:3
            tt=b(kz:kz + 7, kx:kx + 7, k);
            tt=dct2(tt);
            
            
            if k==1
                tt=tt./Qy;
            else
                tt=tt./Qc;
            end
            
            tt=round(tt);
            
            %dekompresja
            
            if k==1
                tt=tt.*Qy;
            else
                tt=tt.*Qc;
            end
            tt=idct2(tt);
            b(kz:kz+7, kx:kx+7, k)=tt;
            
        end
    end
end

b=uint8(b+128);
b=ycbcr2rgb(b);

subplot(121), imshow(a);
subplot(122), imshow(b);
         
%% Transformata Hoffa
% szukanie linie prostych na obrazie, warunek obraz krawedziowy
% metoda iloczynu logicznego
close all; clear; clc;

a=imread('blobs.png');
subplot(121), imshow(a);
[H,T,R] = hough(a);


piki = houghpeaks(H, 10); %wyciagniecie maksimow tabela(ro, theta)

L=houghlines(a,T,R,piki, 'FillGap', 3);   %znalezienie wspolczynnikow dla kazdej z lini

%subplot(122), imagesc(T,R,H);


max_L=0;
n=0;

imshow(a); hold on;
for k=1:10
    line([L(k).point1(1), L(k).point2(1)], ...
        [L(k).point1(2), L(k).point2(2)], 'color', 'r');
    
    %znalezienie maksimum
    dlug=sqrt((L(k).point1(1)-L(k).point2(1))^2 +...
        (L(k).point1(2) - L(k).point2(2))^2);
    if dlug> max_L
        max_L=dlug;
        n=k;
    end
end

n

line([L(n).point1(1), L(n).point2(1)], ...
        [L(n).point1(2), L(n).point2(2)], 'color', 'g');

hold on;