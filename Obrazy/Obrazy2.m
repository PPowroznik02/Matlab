%% rotacja, przeksztalcenie afiniczne, projekcja
close all; clear; clc;
a=imread('cameraman.tif');

subplot(121), imshow(a);

b=imrotate(a, 30, 'crop', 'bilinear'); %rotacja
%rozmiar: crop/loose 

%T=[2 0.33 0; 0 1 0; 0 0 1]; %macierz przeksztalcenia afinicznego
%T=[2 1 0.00001; 0 1 0; 0 0 1]; %macierz projekcji
mac=affine2d([2 0.33 0; 0 1 0; 0 0 1]);    % afiniczne
%mac=projective2d([2 1 0.00001; 0 1 0; 0 0 1]);    %projekcja
b=imwarp(a, mac);

subplot(122), imshow(b);

%% transformacja geometryczna
a=imread('cameraman.tif');

subplot(121), imshow(a);

b=imrotate(a, 30, 'crop', 'bilinear'); %rotacja

subplot(122), imshow(b);

%cpselect(a,b);

% otrzymujemy wartosci do przeksztlcenia afinicznego  T.T do wyswietlenia, 3 wiersz to wrtosci losowe niewplywjace na wynik
T=fitgeotrans(movingPoints, fixedPoints, 'affine');   
T.T

%% odszumianie obrazu 1
close all; clear; clc;

a=imread('cameraman.tif');

N=7;
%maska=ones(N)/(N*N);
maska=fspecial('gaussian', [N,N], N/8); 
b=imfilter(a, maska, 'symmetric');
%b=imfilter(a, maska, 'symmetric');

subplot(121), imshow(a);
subplot(122), imshow(b);

%% Odszumianie obrazu 2
close all; clear; clc;

a=imread('cameraman.tif');

N=7;

b=medfilt2(a, [N,N], 'symmetric');
c=wiener2(a, [N,N]);

subplot(121), imshow(a);
subplot(122), imshow(c);

%% znajdywanie krawedzi za pomoca maski Prewitta i Sobela
close all; clear; clc;

a=imread('cameraman.tif');

a=double(a)/255;    %konwersja na double, bo w imfilter pojawiaja sie ujemne wartosci

maska=[-1 0 1; -1 0 1; -1 0 1]; %maska Prewitta
maska=[-1 0 1; -2 0 2; -1 0 1]; %maska Sobela
b1=abs(imfilter(a, maska));     %abs by otrzymac wszystkie kraedzie
b2=abs(imfilter(a, maska'));    %abs by otrzymac wszystkie kraedzie

b=sqrt(b1.^2 + b2.^2);  %wszystkie krawedzie na jednym obrazie

subplot(221), imshow(a);
subplot(222), imshow(b);
subplot(223), imshow(b1);
subplot(224), imshow(b2);

%% wyzanaczenie naroznikow na obrazie
% obraz: 200x200, czarne tlo, na srodku bialy kwadrat o boku 100
close all; clear; clc;

N=200;

a=zeros(N);
a(51:150, 51:150) = 1;

maska=[1 0 -1];
b=abs(imfilter(imfilter(a, maska), maska'));
b=uint8(a + b.*a);
leg=[0 0 0; 1 1 1; 1 0 0];

subplot(121), imshow(a);
subplot(122), imshow(b, leg);

%% Wyszukiwanie krawedzi za pomoca Lapjasjanow
close all; clear; clc;
a=imread('cameraman.tif');

maska1=[-1 -1 -1; -1 8 -1; -1 -1 -1];    %krawedzie
maska2=[-1 -1 -1; -1 9 -1; -1 -1 -1];   %filter wyostrzajcy, suma obrazu i jego krawedzi
maska3=[0 -1 0; -1 4 -1; 0 -1 0];
maska4=[0 -1 0; -1 5 -1; 0 -1 0];

b1=abs(imfilter(a, maska1));
b2=abs(imfilter(a, maska2));
b3=abs(imfilter(a, maska3));
b4=abs(imfilter(a, maska4));

subplot(221), imshow(b1);
subplot(222), imshow(b2);
subplot(223), imshow(b1);
subplot(224), imshow(b2);

%% filtry krawedziowe nieliniowe
close all; clear, clc;

a=imread('cameraman.tif');


%b=edge(a, 'canny');            %edge dodatkowo wycienia i kategoryzuje
                                %canny najsilniejsza filtracja krawedziowa
%b=rangefilt(a, ones(9));       %filtracja min i max (gradient morfologiczny)
b=stdfilt(a, ones(9));         %podstawa wo filtra wieniera
%b=entropyfilt(a, ones(9));      %filtr entropi, entropie liczy sie w duzych maskach, bo entropia bazuje na prawdopodobienstwie
                                %entopia jest podstawowym filtrem do zdjec radarowych

%imshow(b);
imagesc(b); axis image %do stdfilt i entropyfilt

%% dekonwolucja, usuniecie rozmycia
close all; clear; clc;
%do zywyklych zdjec raczej nie przydatne, ale do zdjec obiektow kosmicznych juz tak

a=imread('cameraman.tif');
b=fspecial('motion', 11, 30); %motion symulacja poruszenia kamera podczas robienia zdjecia

porusz=imfilter(a,b,'symmetric');
%porusz=imfilter(a,b);

subplot(121), imshow(porusz);

%c=deconvblind(porusz, b); %powoduje replikacje glownych krawedzi, pozwala odzyskac glowne krawedzie
%c=deconvlucy(porusz, b);
%c=deconvreg(porusz, b);
c=deconvwnr(porusz, b);

subplot(122), imshow(c);

