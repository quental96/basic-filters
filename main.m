%% Signal Processing

% When acquiring an image, several disturbances can be introduced by the 
% imaging system, the acquisition chain or the surrounding noise. 
%
% This file explores and develops methods that allow us to reconstruct 
% an image as faithfully as possible:
%
%    white_noise.m
%    fft_convolution.m
%    FiltreInverse.m
%    FiltreWiener.m
%    lambda_optimal.m
%
% The data is structured as follows:
% 
%    Blabla
%

%% Initialization
clear ; close all; clc;

%% Data loading and variable definition

% Load images that we will be using
pal_img = double(imread('Palaiseau.bmp'));
y = size(pal_img, 1);
x = size(pal_img, 2);
text_img = double(imread('Text.tif'));

% Plot images
fprintf('Visualizing images.\n');

figure('Name','Images','NumberTitle','off');
subplot 121;
imagesc(pal_img);
colormap('gray');
title('Palaiseau');
axis image;
subplot 122;
imagesc(text_img);
colormap('gray');
title('Text');
axis image;

% Load basic windows
load('windows.mat');

fprintf('Program paused. Press enter to continue.\n');
pause;
fprintf('\n');

%% Part 1: Basic filter testing with controlled disturbances

% In the following sections we will observe the windows that will be
% applied on the Palaiseau image in order to simulate disturbances, the 
% effects they have on said image and then test basic filters. For filter
% testing we will only focus on the PSF related disturbances, as the Rect
% related disturbance serve only as a comparison.

%% Window descriptions

% Calculate Fourier tranforms of the useful filters
fft_PSF = fft2(PSF);
fft_Rect = fft2(Rect);

% Visualize pertinent information on windows and their FTs
fprintf('Visualizing Windows and their Fourier transforms.\n');

% PSF
figure('Name','Point Spread Function','NumberTitle','off');
imagesc(fftshift(PSF));
axis([x/2-50 x/2+50 y/2-50 y/2+50]);
colormap spring;
title('PSF');

figure('Name','FT of PSF','NumberTitle','off');
subplot 221;
imagesc(fftshift(abs(fft_PSF)));
colormap spring;
title('Modulus of FT(PSF)');
subplot 222;
imagesc(fftshift(angle(fft_PSF)));
colormap spring;
title('Phase of FT(PSF)');
subplot 223;
imagesc(fftshift(real(fft_PSF)));
colormap spring;
title('Real part of TF(PSF)');
subplot 224;
imagesc(fftshift(imag(fft_PSF)));
colormap spring;
title('Imaginary part of TF(PSF)');

% Rect
figure('Name','Rectangle Function','NumberTitle','off');
imagesc(fftshift(Rect));
axis([x/2-50 x/2+50 y/2-50 y/2+50]);
colormap summer;
title('Rect');

figure('Name','FT of Rect','NumberTitle','off');
subplot 221;
imagesc(fftshift(abs(fft_Rect)));
colormap summer;
title('Modulus of FT(Rect)');
subplot 222;
imagesc(fftshift(angle(fft_Rect)));
colormap summer;
title('Phase of FT(Rect)');
subplot 223;
imagesc(fftshift(real(fft_Rect)));
colormap summer;
title('Real part of TF(Rect)');
subplot 224;
imagesc(fftshift(imag(fft_Rect)));
colormap summer;
title('Imaginary part of TF(Rect)');

% Cuts at zero frequency
figure('Name','FT Cuts','NumberTitle','off');
subplot 121;
x1=1:length(fft_Rect(:,1));
y1=fftshift(abs(fft_Rect(:,1)));
plot(x1,y1,'r');
title('FT(Rect)');
subplot 122;
x2=1:length(fft_PSF(:,1));
y2=fftshift(abs(fft_PSF(:,1)));
plot(x2,y2,'b');
title('FT(PSF)');

fprintf('Program paused. Press enter to continue.\n');
pause;
fprintf('\n');

%% Disturbance simulation

% Perfect image convoluted to PSF and Rect
y0_rect = fft_convolution(Rect,pal_img);
y0_psf = fft_convolution(PSF,pal_img);

% Addition of additive white gaussian noise
SNR = 40;
fprintf('Signal Noise Ratio for additive white gaussian noise: %d.\n',...
    SNR);
yb_rect = awg_noise(y0_rect,SNR);
yb_psf = awg_noise(y0_psf,SNR);

% Verification of the disturbance
fprintf('Visualizing disturbances.\n');

figure('Name','Disturbances','NumberTitle','off');

subplot 221;
imagesc(y0_rect);
colormap('gray');
title('y0\_rect');
axis image;
subplot 222;
imagesc(yb_rect);
colormap('gray');
title('yb\_rect');
axis image;

subplot 223;
imagesc(y0_psf);
colormap('gray');
title('y0\_psf');
axis image;
subplot 224;
imagesc(yb_psf);
colormap('gray');
title('yb\_psf');
axis image;

fprintf('Program paused. Press enter to continue.\n');
pause;
fprintf('\n');

%% Inverse filter

fprintf('Visualizing inverse filter results.\n');

figure('Name','Inverse Filter','NumberTitle','off');

subplot 131;
imagesc(pal_img);
colormap('gray');
title('Palaiseau');
axis image;

subplot 132;
imagesc(inverse_filter(PSF,y0_psf));
colormap('gray');
title('Filtered y0\_psf');
axis image;

subplot 133;
imagesc(inverse_filter(PSF,yb_psf));
colormap('gray');
title('Filtered yb\_psf');
axis image;

fprintf('Program paused. Press enter to continue.\n');
pause;
fprintf('\n');

%% Wiener filter

lambda = optimal_lambda(PSF,yb_psf,pal_img);
fprintf('Optimal lambda: %d.\n',lambda);

fprintf('Visualizing Wiener filter results.\n');

figure('Name','Wiener Filter','NumberTitle','off');


subplot 131;
imagesc(pal_img);
colormap('gray');
title('Palaiseau');
axis image;

subplot 132;
imagesc(wiener_filter(PSF,y0_psf,lambda));
colormap('gray');
title('Filtered y0\_psf');
axis image;

subplot 133;
imagesc(wiener_filter(PSF,yb_psf,lambda));
colormap('gray');
title('Filtered yb\_psf');
axis image;

fprintf('Program paused. Press enter to continue.\n');
pause;
fprintf('\n');

%% Part 2: Camera shake fix with Wiener filter


delta=50; % by how many pixels the image was moved
fprintf('Blur delta: %d.\n',delta);

h=zeros(size(text_img));
h(1,1:delta)=1; % blur window

fprintf('Visualizing camera shake restoration.\n');

figure('Name','Camera Shake','NumberTitle','off');

subplot 121
imagesc(text_img)
title('Blurred text')
colormap('gray')
axis image

subplot 122
imagesc(wiener_filter(h,text_img,1)) % optimal lambda is 1
title('Restored text')
colormap('gray')
axis image