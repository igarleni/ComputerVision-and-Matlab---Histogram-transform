% PRACTICA 3: TECNICAS PARA MEJORAR EL HISTOGRAMA Y MEJORAR EL CONTRASTE
%Efectos del histograma con trasnformaciones aritmeticas
I=imread('mujer.jpg');
figure,subplot(3,2,1),subimage(I),title('Original'),subplot(3,2,2),imhist(I);
%Operaciones suma y resta
Isuma=I+100;
subplot(3,2,3),subimage(Isuma),title('Suma'), subplot(3,2,4),imhist(Isuma);
Iresta=I-100;
subplot(3,2,5),subimage(Iresta),title('Resta'), subplot(3,2,6),imhist(Iresta);

%Operaciones multiplicacion y division
%Con la multiplicacion se ve un estiramiento (si el factor es mayor que
%uno) o aplastamiento si el factor es menor que uno o la division
Ipro=I*1.5;
Idiv=I/2;

figure,subplot(3,2,1),subimage(I),title('Original'),subplot(3,2,2),imhist(I);
subplot(3,2,3),subimage(Ipro),title('Producto'), subplot(3,2,4),imhist(Ipro);
subplot(3,2,5),subimage(Idiv),title('Division'), subplot(3,2,6),imhist(Idiv);


%Explicación de las funciones de transferencia:
%Ejex los niveles actuales de la imagen Ejey los niveles del resultado.
%plot que resultado cuando al ejex se le aplica una funcion determinada

%Ejemplo de funciones de transferencia

x=[0:255];
identidad=x;
figure,subplot(2,3,1),plot(x,identidad),title('Identidad');

negativo=255-x;
subplot(2,3,2),plot(x,negativo),title('Negativo');

B=40;
suma_cte=x+B;
subplot(2,3,3),plot(x,suma_cte),title('x+B');
k=1;
for A=1.5:0.5:3
    mask1=(x*A>=0 & x*A<256)
    prod(k,:)=x*A.*mask1;
    mask2=(x*A>=256)
    prod(k,:)=255*mask2+prod(k,:).*(1-mask2); %truncar a 255 cuando se sale
    
    mask1=(x/A>=0 & x/A<256)
    mask2=(x/A>=256);
    div(k,:)=(x/A.*mask1).*(1-mask2)+255*mask2;
    
    k=k+1;
end
subplot(2,3,4),plot(x,prod,'--rs','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',2),title('x^*A');
                   
 
 subplot(2,3,5),plot(x,div,'--rs','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',2),title('x/A');
                                     


 dif_cte=x-B;
 mask=(dif_cte<0);
 dif_cte=(mask)*0+(1-mask).*dif_cte;
 subplot(2,3,6),plot(x,dif_cte),title('x-B');
 

 
%Corrección gamma
I=imread('mujer.jpg');
palfa = 0.01;
c=1;
Id=im2double(I);
Ig1=c*(Id.^palfa)
a=255/(max(max(Ig1))-min(min(Ig1)));
b=255-a*max(max(Ig1));
Iu8=uint8(a*Ig1+b);
Itrun= im2uint8(Ig1);
%si mirais el histograma de imhist solamente vereis que tiene solamente 2
%bin y por lo tanto contabiliza 0 o 1
figure,subplot(2,2,1),imshow(Ig1,[]),subplot(2,2,2),imhist(Iu8),...
  subplot(2,2,3),imshow(Itrun),subplot(2,2,4),imhist(Itrun);

%transformacion logaritmica 
Ilog=(log(double(I)+1));
a=255/(max(max(Ilog))-min(min(Ilog)));
b=255-a*max(max(Ilog));
Iu8=uint8(a*Ilog+b);

figure,subplot(2,2,1),imshow(Ilog,[]),title('Log'),subplot(2,2,2),imhist(Iu8),...
subplot(2,2,3),imshow(I,[]),title('Original'),subplot(2,2,4),imhist(I),title('Histograma Original');


%transformacion exponencial
close all;
Iexp=exp(im2double(I));
a=255/(max(max(Iexp))-min(min(Iexp)));
b=255-a*max(max(Iexp));
Iu8=uint8(a*Iexp+b);

figure,subplot(2,2,1),imshow(Iexp,[]),title('Exp'),subplot(2,2,2),imhist(Iu8),...
subplot(2,2,3),imshow(I,[]),title('Original'),subplot(2,2,4),imhist(I),title('Histograma Original');


%Stretching (estiramiento): -->imadjust
%   *Los valores inferiores a un cierto umbral se anulan
%   *Los superiores a otro umbral se saturan al máximo
%   *Los valores intermedios se transforman con alguna función

%imadjust(I) mapea los valores de manera que satura %1
%  IMADJUST(I,[LOW_IN; HIGH_IN],[LOW_OUT; HIGH_OUT]) maps the values
%     in intensity image I to new values in J such that values between LOW_IN
%     and HIGH_IN map to values between LOW_OUT and HIGH_OUT. Values below
%     LOW_IN and above HIGH_IN are clipped; that is, values below LOW_IN map
%     to LOW_OUT, and those above HIGH_IN map to HIGH_OUT. You can use an
%     empty matrix ([]) for [LOW_IN; HIGH_IN] or for [LOW_OUT; HIGH_OUT] to
%     specify the default of [0 1]. If you omit the argument, [LOW_OUT;
%     HIGH_OUT] defaults to [0 1].
close all;
I=imread('mujer.jpg');
J=imadjust(I);
K = imadjust(I,[0.3 0.7],[]); %los valores entre 0.3-0.7 se mapea a 0-1
figure,subplot(2,3,1),imshow(I),,title('Original'),subplot(2,3,2),...
imshow(J),title('Ajuste'),subplot(2,3,3), imshow(K),title('Ajuste 0.3-0.7'),...
subplot(2,3,4),imhist(I),subplot(2,3,5),imhist(J),subplot(2,3,6),imhist(K);

Binaria=imadjust(I,[0 1],[1 0]); %B=imcomplement(I)
figure,imshow(Binaria)

%con imagenes de color
A=imread('patio_leones.ppm');
A2 = imadjust(A,[.2 .2 .2; 1 1 1],[]);
figure, subplot(2,4,1),imshow(A), subplot(2,4,2),imhist(A(:,:,1)),title('Rojo'), subplot(2,4,3),imhist(A(:,:,2)),title('Verde'),subplot(2,4,4),imhist(A(:,:,3)),title('Azul');
subplot(2,4,5),imshow(A2), subplot(2,4,6),imhist(A2(:,:,1)), subplot(2,4,7),imhist(A2(:,:,2)),subplot(2,4,8),imhist(A2(:,:,3));


%ECUALIZAR-->histeq
%q=histeq(b) se devuelve la imagen con el histograma equalizado
close all;
I=imread('mujer.jpg');
Ieq=histeq(I);
figure,subplot(2,2,1),imshow(I),subplot(2,2,2),imhist(I);
subplot(2,2,3),imshow(Ieq),subplot(2,2,4),imhist(Ieq);

%existen diferentes formas para llamar a la ecaualizacion del histograma 
%pero una interesantes es:
[Ieq2 T]=histeq(I);
Iotra=T(I);
figure,imshow(Iotra);
figure, imshow(Ieq2);
%error de la imagen
mse(Iotra-im2double(Ieq2))


%Ecualizacion de Imagenes a color 

%Histograma de las bandas
close all;
imgrgb=imread('patio_leones.ppm');
f=figure(1); set(f,'Name','Imagen original');
subplot(3,3,1);imshow(imgrgb),title('RGB');
subplot(3,3,4);imshow(imgrgb(:,:,1)),title('Rojo');
subplot(3,3,5);imshow(imgrgb(:,:,2)),title('Verde');
subplot(3,3,6);imshow(imgrgb(:,:,2)),title('Azul');
subplot(3,3,7);imhist(imgrgb(:,:,1)),title('Hist Rojo');
subplot(3,3,8);imhist(imgrgb(:,:,2)),title('Hist Verde');
subplot(3,3,9);imhist(imgrgb(:,:,2)),title('Hist Azul');


equ=cat(3,histeq(imgrgb(:,:,1)),histeq(imgrgb(:,:,2)),histeq(imgrgb(:,:,3)));
%histograma de equ
f=figure(2); set(f,'Name','Imagen Ecualizada');
subplot(3,3,1);imshow(equ),title('Ecualizada');
subplot(3,3,4);imshow(equ(:,:,1)),title('Rojo');
subplot(3,3,5);imshow(equ(:,:,2)),title('Verde');
subplot(3,3,6);imshow(equ(:,:,2)),title('Azul');
subplot(3,3,7);imhist(equ(:,:,1)),title('Hist Rojo');
subplot(3,3,8);imhist(equ(:,:,2)),title('Hist Verde');
subplot(3,3,9);imhist(equ(:,:,2)),title('Hist Azul');


%ahora en el dominio hsv
imghsv=rgb2hsv(imgrgb);
f=figure(4),set(f,'Name','Histogramas HSV');
subplot(1,3,1),imhist(imghsv(:,:,1));
subplot(1,3,2),imhist(imghsv(:,:,2));
subplot(1,3,3),imhist(imghsv(:,:,3));


equ2=hsv2rgb(cat(3,histeq(imghsv(:,:,1)),histeq(imghsv(:,:,2)),histeq(imghsv(:,:,3) )));
f=figure(5); set(f,'Name','Imagen Ecualizada HSV');
subplot(3,3,1);imshow(equ2),title('Ecualizada HSV');
subplot(3,3,4);imshow(equ2(:,:,1)),title('Rojo');
subplot(3,3,5);imshow(equ2(:,:,2)),title('Verde');
subplot(3,3,6);imshow(equ2(:,:,2)),title('Azul');
subplot(3,3,7);imhist(equ2(:,:,1)),title('Hist Rojo');
subplot(3,3,8);imhist(equ2(:,:,2)),title('Hist Verde');
subplot(3,3,9);imhist(equ2(:,:,3)),title('Hist Azul');


%Ecualizar solamente V

equ3=hsv2rgb(cat(3,(imghsv(:,:,1)),imghsv(:,:,2),histeq(imghsv(:,:,3) )));
f=figure(6); set(f,'Name','Imagen Ecualizada HSV solo V');
subplot(3,3,1);imshow(equ3),title('Ecualizada HSV solo V');
subplot(3,3,4);imshow(equ3(:,:,1)),title('Rojo');
subplot(3,3,5);imshow(equ3(:,:,2)),title('Verde');
subplot(3,3,6);imshow(equ3(:,:,2)),title('Azul');
subplot(3,3,7);imhist(equ3(:,:,1)),title('Hist Rojo');
subplot(3,3,8);imhist(equ3(:,:,2)),title('Hist Verde');
subplot(3,3,9);imhist(equ3(:,:,3)),title('Hist Azul');

%stretchlim(I,TOL) devuelve un par de valores de gris que pueden ser usados
%para imadjust para incrementar el contraste de la image. Si TOL no se da
%se supone que es [0,01 0.99] saturando un 2%
I=imread('mujer.jpg');
J=imadjust(I,stretchlim(I),[]);
figure,subplot(1,2,1),imshow(I),subplot(1,2,2),imshow(J);



%adapthisteq: es parecido al histeq, pero a diferencia mejora el contraste
%operando sobre pequeñas regiones. 
%Parametros posibles 

% 'NumTiles'     Two-element vector of positive integers: [M N].
%                    [M N] specifies the number of tile rows and
%                    columns.  Both M and N must be at least 2. 
%                    The total number of image tiles is equal to M*N.
%  
%                    Default: [8 8].
% 
%  'ClipLimit'    Real scalar from 0 to 1.
%                    'ClipLimit' limits contrast enhancement. Higher numbers 
%                    result in more contrast. 
%         
%                    Default: 0.01.
%  'Range'        One of the strings: 'original' or 'full'.
%                    Controls the range of the output image data. If 'Range' 
%                    is set to 'original', the range is limited to 
%                    [min(I(:)) max(I(:))]. Otherwise, by default, or when 
%                    'Range' is set to 'full', the full range of the output 
%                    image class is used (e.g. [0 255] for uint8).
%  
%                    Default: 'full'.
%  'Distribution' Distribution can be one of three strings: 'uniform',
%                    'rayleigh', 'exponential'.
%                    Sets desired histogram shape for the image tiles, by 
%                    specifying a distribution type.
%  
%                    Default: 'uniform'.
%  'Alpha'        Nonnegative real scalar.
%                    'Alpha' is a distribution parameter, which can be supplied 
%                    when 'Dist' is set to either 'rayleigh' or 'exponential'.
%  
%                    Default: 0.4.
J=adapthisteq(I);
J2=adapthisteq(I,'clipLimit',0.005,'Distribution','uniform');
J3=adapthisteq(I,'clipLimit',0.005,'Distribution','exponential');
J4=adapthisteq(I,'clipLimit',0.005,'Distribution','rayleigh');
figure,imshow(J);
figure,imshow(J2);figure,imshow(J3);figure,imshow(J4);

    
