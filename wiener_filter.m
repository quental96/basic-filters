function x = wiener_filter(h,y,lambda) %lambda=DSP(bruit)/DSP(signal)
%WIENER_FILTER Applies the Wiener filter
%   x = WIENER_FILTER(h,y,lambda) is y filtered by the Wiener filter given
%   by h and parameter lambda

fftx=fft2(y).*conj(fft2(h))./(abs(fft2(h)).^2+ lambda);
x=ifft2(fftx);

end

