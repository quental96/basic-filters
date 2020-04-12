function lambda = optimal_lambda(h,y,x)
%OPTIMAL_LAMBDA Finds optimal lambda for Wiener filter
%   lambda = OPTIMAL_LAMBDA(h,y,x) is the optimal lambda for a given Wiener
%   filter, found through exhaustive search
%   Note: can be greatly optimized

index=1;
L=linspace(0.001,10,100);
moyenne=mean(mean((abs(wiener_filter(h,y,L(1))-x)).^2));
for i=1:length(L)
        ecart = mean(mean((abs(wiener_filter(h,y,L(i))-x)).^2));
        if ecart < moyenne
            index=i;
            m=ecart;
        end    
lambda=L(index);

end