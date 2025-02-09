function [Cxy,coh,freq] = coherence_measure_3d(f1, f2)
%%
K = size(f1,2);
Fs = 215;
window = 40;
noverlap = window/2;
f=[];
for k=1:K
    [Pxx,freq] = cpsd( f1(:,k), f1(:,k), window,noverlap,f, Fs);
    [Pyy,freq] = cpsd( f2(:,k), f2(:,k), window,noverlap,f, Fs);
    [Pxy,freq] = cpsd( f1(:,k), f2(:,k), window,noverlap,f, Fs);

    Kxy  = real( Pxy );
    Qxy  = imag( Pxy );
    coh(:,k)  = Pxy.*conj(Pxy)./(Pxx.*Pyy);
    c(k) = sqrt(coh(:,k)'*Pxx/sum(Pxx));
end
Cxy=c;


