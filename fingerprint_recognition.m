clear; close all; clc;

I = imread('fp.png');

%grayscale transformation
I = rgb2gray(I);

figure, imshow(I); title('original');

I = double(I);

%image normalisation
%new mean and variance
M0 = 0.5;
V0 = 0.5;
N = normalize(I, M0, V0);
%figure, imshow(N); title('normalized');


%segmented using Otsu method
level = graythresh(N);   %The threshold is normalized to the range [0, 1].                       
seg = imbinarize(N,level); 
figure, imshow(seg); title("segmented using Otsu method");

Nseg = N.*(~seg);


%Spatial estimation
%orientation estimation
%[Gmag, Gdir] = imgradient(segN, 'sobel');

W=4;
Sx = [-1 0 1;-2 0 2;-1 0 1];
Sy = [-1 -2 -1;0 0 0;1 2 1];
Gx = imfilter(Nseg, Sx);
Gy = imfilter(Nseg, Sy);

[m,n] = size(Nseg);
Vx = zeros(m,n);
Vy = zeros(m,n);
for i=1+W/2:m-W/2
    for j=1+W/2:n-W/2
        tp = Gx(i-W/2:i+W/2, j-W/2:j+W/2).*Gy(i-W/2:i+W/2, j-W/2:j+W/2);
        Vx(i,j) = 2*sum(tp(:));
        
        tp = ((Gx(i-W/2:i+W/2, j-W/2:j+W/2))^2) - ((Gy(i-W/2:i+W/2, j-W/2:j+W/2))^2);
        Vy(i,j) = sum(tp(:));
    end
end

theta = 0.5*atan(Vx./Vy);
%figure, imshow(theta); title('t');


%smoothing directional map
%{
vx = Gmag.*cos(Gdir);
vy = Gmag.*sin(Gdir);

vxg = imgaussfilt(vx, 0.1);
vyg = imgaussfilt(vy, 0.1);

Gdirg = atan(vyg/vxg);

figure, imshow(sqrt(vxg.^2+vyg.^2));
%}


Yx = cos(2*theta);
Yy = sin(2*theta);

sigma = 0.1;
h = fspecial('gaussian',[3 3],sigma);
Yxg = imfilter(Yx, h);
Yyg = imfilter(Yy, h);

theta2 = 0.5*atan(Yyg./Yxg);
%figure, imshow(theta2);

theta2 = rad2deg(theta2);
theta2 = wrapTo360(theta2);
theta2(isnan(theta2))=0;





%gabor filter
[m,n] = size(theta2);
wavelength = 5;
W = 40;
gaborres = zeros(m,n);
for i=1+W/2:m-W/2
    for j=1+W/2:n-W/2
        mag = mygabor(N(i-W/2:i+W/2, j-W/2:j+W/2),wavelength,theta2(i,j));
        gaborres(i,j) = mag;
    end
end

figure, imshow(uint8(gaborres));



function [res] = mygabor(I, wavelength, orientation)
    [m,n]=size(I);
    res = 0;
    for x=-m/2: m/2
        for y=-n/2:n/2
            xp = x*sin(orientation) + y*cos(orientation);
            yp = x*cos(orientation) - y*sin(orientation);
            res = res + exp(-0.5*(((xp^2)/(0.5*wavelength))+((yp^2)/(0.5*wavelength))))*cos(2*pi*wavelength*xp);
        end
    end
    
end



% normalization function
function [N] = normalize(I, M0, V0)
    [m,n] = size(I);
    M = (1/(m*n))*sum(I(:));

    tmp = (I-M).^2;
    variance = (1/(m*n))*sum(tmp(:));
    
    N = zeros(m,n);
    for i=1:m
        for j=1:n
            if I(i,j)>M
                N(i,j) = M0 + sqrt((V0*(I(i,j)-M)^2)/variance);
            else
                N(i,j) = M0 - sqrt((V0*(I(i,j)-M)^2)/variance);
            end
        end
    end
end
