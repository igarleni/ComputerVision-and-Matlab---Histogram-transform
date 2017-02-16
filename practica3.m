%
woman=imread('mujer.jpg');
figure,subplot(3,2,1),subimage(woman),title('Original'),subplot(3,2,2),imhist(woman);


%%%%%%%%%%%%%%%%%%%%
%add and substract
womanAdd=woman+100;
subplot(3,2,3),subimage(womanAdd),title('Add'), subplot(3,2,4),imhist(womanAdd);
womanSubstract=woman-100;
subplot(3,2,5),subimage(womanSubstract),title('Substract'), subplot(3,2,6),imhist(womanSubstract);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Multiplication and division
Imul=woman*1.5;
Idiv=woman/2;
figure,subplot(3,2,1),subimage(woman),title('Original'),subplot(3,2,2),imhist(woman);
subplot(3,2,3),subimage(Imul),title('Multiplication'), subplot(3,2,4),imhist(Imul);
subplot(3,2,5),subimage(Idiv),title('Division'), subplot(3,2,6),imhist(Idiv);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%imadjust with strechlim

%stretchlim(woman,TOL) devuelve un par de valores de gris que pueden ser usados
%para imadjust para incrementar el contraste de la image. Si TOL no se da
%se supone que es [0,01 0.99] saturando un 2%
J=imadjust(woman,stretchlim(woman),[]);
figure,subplot(1,2,1),imshow(woman),subplot(1,2,2),imshow(J);


%%%%%%%%%%%%%%%%%%%%%%%%%%
%imadjust for gamma correction

%Stretching: -->imadjust
%   *Los valores inferiores a un cierto umbral se anulan
%   *Los superiores a otro umbral se saturan al maximo
%   *Los valores intermedios se transforman con alguna funcion

%imadjust(woman) mapea los valores de manera que satura %1
%  IMADJUST(woman,[LOW_IN; HIGH_IN],[LOW_OUT; HIGH_OUT]) maps the values
%     in intensity image woman to new values in J such that values between LOW_IN
%     and HIGH_IN map to values between LOW_OUT and HIGH_OUT. Values below
%     LOW_IN and above HIGH_IN are clipped; that is, values below LOW_IN map
%     to LOW_OUT, and those above HIGH_IN map to HIGH_OUT. You can use an
%     empty matrix ([]) for [LOW_IN; HIGH_IN] or for [LOW_OUT; HIGH_OUT] to
%     specify the default of [0 1]. If you omit the argument, [LOW_OUT;
%     HIGH_OUT] defaults to [0 1].
J=imadjust(woman);
K = imadjust(woman,[0.3 0.7],[]); %los valores entre 0.3-0.7 se mapea a 0-1
figure,subplot(2,3,1),imshow(woman),title('Original'),subplot(2,3,2),...
imshow(J),title('Adjust'),subplot(2,3,3), imshow(K),title('Adjust 0.3-0.7'),...
subplot(2,3,4),imhist(woman),subplot(2,3,5),imhist(J),subplot(2,3,6),imhist(K);


%%%%%%%%%%%%%%%%%%%%%%%%%%
%imadjust for substraction (-100)

substractionRatio = 100/255;
K = imadjust(woman,[substractionRatio 1],[0 1-substractionRatio]);
figure,subplot(2,2,1),imshow(woman),title('Original'),...
    subplot(2,2,2), imshow(K),title('Substraction'),...
    subplot(2,2,3),imhist(woman),subplot(2,2,4),imhist(K);


%%%%%%%%%%%%%%%%%%%%%
%Image equalization

%ECUALIZAR-->histeq
%q=histeq(b) se devuelve la imagen con el histograma equalizado
Ieq=histeq(woman);
figure,subplot(2,2,1),imshow(woman),subplot(2,2,2),imhist(woman);
subplot(2,2,3),imshow(Ieq),subplot(2,2,4),imhist(Ieq);


%%%%%%%%%%%%%%%%%%%
%COLOR IMAGES
dance = imread('danza.ppm');

%%%%%%%%%%%%%%%
%Equalize RGB
equ=cat(3,histeq(dance(:,:,1)),histeq(dance(:,:,2)),histeq(dance(:,:,3)));
%histograma de equ
f=figure(2); set(f,'Name','Equalized image');
subplot(3,3,1);imshow(dance),title('original RGB');
subplot(3,3,2);imshow(equ),title('Ecualized');
subplot(3,3,4);imshow(equ(:,:,1)),title('Red');
subplot(3,3,5);imshow(equ(:,:,2)),title('Green');
subplot(3,3,6);imshow(equ(:,:,3)),title('Blue');
subplot(3,3,7);imhist(equ(:,:,1)),title('Hist Red');
subplot(3,3,8);imhist(equ(:,:,2)),title('Hist Green');
subplot(3,3,9);imhist(equ(:,:,3)),title('Hist Blue');

%%%%%%%%%%%%%%%
%Equalize HSV
imghsv=rgb2hsv(dance);
equ2=hsv2rgb(cat(3,histeq(imghsv(:,:,1)),histeq(imghsv(:,:,2)),histeq(imghsv(:,:,3) )));
f=figure(5); set(f,'Name','Equalized image');
subplot(3,3,1);imshow(imghsv),title('original HSV');
subplot(3,3,2);imshow(equ2),title('Ecualized');
subplot(3,3,4);imshow(equ2(:,:,1)),title('Red');
subplot(3,3,5);imshow(equ2(:,:,2)),title('Green');
subplot(3,3,6);imshow(equ2(:,:,3)),title('Blue');
subplot(3,3,7);imhist(equ2(:,:,1)),title('Hist Red');
subplot(3,3,8);imhist(equ2(:,:,2)),title('Hist Green');
subplot(3,3,9);imhist(equ2(:,:,3)),title('Hist Blue');


%%%%%%%%%%
%Imadjust for transfer function with Y = 0.75
field = imread('campo.ppm');
fieldGray = rgb2gray(field);
mini = 110/255;
maxi = 190/255;
fieldAdj = imadjust(fieldGray,[mini maxi],[]);
palfa = 0.75;
c=1;
Id=im2double(fieldGray);
Ig1=c*(Id.^palfa);
a=255/(max(max(Ig1))-min(min(Ig1)));
b=255-a*max(max(Ig1));
Iu8=uint8(a*Ig1+b);
Itrun= im2uint8(Ig1);
figure,subplot(2,2,1),imshow(Ig1,[]),subplot(2,2,2),imhist(Iu8),...
  subplot(2,2,3),imshow(Itrun),subplot(2,2,4),imhist(Itrun);

%%%%%%%%%%%%%%%%%%%
%adapthisteq function
womanAdapt = adapthisteq(woman);
figure,subplot(2,2,1),imshow(woman),title('Original'),...
    subplot(2,2,2),imshow(womanAdapt), title('adaptHisteq image'),...
    subplot(2,2,3),imhist(woman), ...
    subplot(2,2,4),imhist(womanAdapt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Combining techniques to improve an image
landscape = imread('paisaje.jpg');
equ=cat(3,histeq(landscape(:,:,1)),histeq(landscape(:,:,2)),histeq(landscape(:,:,3)));
figure,subplot(2,3,1),imshow(landscape),title('Original'),...
    subplot(3,3,3),imshow(equ), title('Histeq image'),...
    subplot(3,3,4);imhist(landscape(:,:,1)),title('Red'),...
    subplot(3,3,5);imhist(landscape(:,:,2)),title('Green'),...
    subplot(3,3,6);imhist(landscape(:,:,3)),title('Blue'),...
    subplot(3,3,7);imhist(equ(:,:,1)),title('Hist Red'),...
    subplot(3,3,8);imhist(equ(:,:,2)),title('Hist Green'),...
    subplot(3,3,9);imhist(equ(:,:,3)),title('Hist Blue');
equSum = imadjust(equ,[0.3 1],[]);
figure,subplot(1,3,1),imshow(landscape),title('Original'),...
    subplot(1,3,2),imshow(equ), title('Histeq image'),...
    subplot(1,3,3),imshow(equSum), title('Final image');
