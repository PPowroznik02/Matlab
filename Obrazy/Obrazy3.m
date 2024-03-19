%% Wykrywanie krawedzi za pomoca transformaty fouriera
close all; clear; clc;

a=imread('cameraman.tif');
[Nz, Nx]=size(a);

a=double(a)/255;

% fx=linspace(-Nx/2, Nx/2, Nx); %otrzymujemy kolo
% fz=linspace(-Nz/2, Nz/2, Nz);

fx=linspace(-0.5, 0.5, Nx); % podajemy znoramlizowana czestotliwosc
fz=linspace(-0.5, 0.5, Nz);    %otrzymujemy eplise

%do obrazow kwadratowych nie ma znaczenia czy kolo czy elipsa

[FX, FZ]=meshgrid(fx, fz);

f=sqrt(FX.^2 + FZ.^2); %baza stosowana do tworzenia maski filtracyjnej

% subplot(121), imagesc(FX);
% subplot(122), imagesc(f)


XT=fftshift(fft2(a)); %transformata 2 wymiarowa fft2
WA=abs(XT);

%WA=rot90(abs(XT)); %roacja by lepiej zauwazyc ktora krawedz to ktora

%LP=f<=10; %czestotliwosc odciecia (im wieksza tym ringi bardziej slabna), maksymalna czestotliwosc to 1/2 szerokosci obrazu
%LP=f>=20; %gornoprzepustowy, dostajemy krawedziowke, transformaty foruriera do wykrywania krawedzi sie raczej nie stosuje
LP=1./(1+(f/10).*4);  % filtr buterwotha        

an=real(ifft2(ifftshift(LP.*XT)));

subplot(211), imshow(an); %ringowanie wokol krawedzi, rozmazany obraz
subplot(212), imshow(a);

%imagesc(fx, fz, log(WA +0.01)); axis image % do wyswietlania uzyc log by obraz nie sumowal sie na srodku, 
                                            %dodac mala wartosc by unikanac
                                            %log od 0, linie na wykresie WA odpowiadaja 
                                            %krawedzia na obrazie kameraman
                                            
%% Analiza anizotropowa
%Wyswietlenie 3 WA dla kazdego kanalu osobno, f<-q,q>
%Usuniecie regularnego siatkowania na obrazie stosujac filter i fft
close all; clear; clc;


a=imread('Data/F_dzieciol.png'); %obraz kolorowy, prostokatny
%imshow(a);
[Nz, Nx, col]=size(a); %podac tez col by nam nie dopisalo wartosci
a=double(a)/255;

fx=linspace(-0.5, 0.5, Nx);    
fz=linspace(-0.5, 0.5, Nz);     

[FX, FZ] = meshgrid(fx,fz); %potrzebne do filtra

BS=~((abs(FX) >0.17 & abs(FX)<0.25) & (abs(FZ)>0.14 & abs(FZ)<0.25)); %stworzenie filtra, odfiltrowywnie w czarnych pixelach (0)

an=a;
for k=1:3
    XT=fftshift(fft2(a(:,:,k)));
    WA=abs(XT);
    
    subplot(2,2,k+1);
    imagesc(fx, fz, log(WA+0.01));
    
    an(:,:,k)=real(ifft2(ifftshift(BS.*XT)));   %zlozenie odfiltrowanych skladowych rgb z powrotem w obraz
end


subplot(221), imagesc(BS);  %wyswietlenie filtra
subplot(221), imshow(an);     %wyswietlenie przefiltowanego obrazu

%subplot(222),imshow(a);    %do porownania z oryginalnym zdjeciem

