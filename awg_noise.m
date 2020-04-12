function yb = awg_noise(y,SNR)
%AWG_NOISE Adds additive white gaussian noise
%   yb = AWG_NOISE(y,SNR) is y disturbed with additive white gaussian 
%   noise using a signal noise ratio given by SNR

sigma=sqrt(var(y(:))/(10^(SNR/10)));
yb=y+randn(size(y))*sigma; 

end

