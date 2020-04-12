function y0 = fft_convolution(h,x)
%FFT_CONVOLUTION Performs convolution operation
%   y0 = FFT_CONVOLUTION(h,x) is the convolution of h and x through the 
%   Fourier space

y0=ifft2(fft2(h).*fft2(x)); 

end



