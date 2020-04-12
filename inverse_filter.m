function x = inverse_filter(h,y)
%INVERSE_FILTER Applies the inverse filter
%   x = INVERSE_FILTER(h,y) is y filtered by the inverse filter given by h
%   Attention: h cannot have null values

fftx=fft2(y)./fft2(h);
x=ifft2(fftx);

end


