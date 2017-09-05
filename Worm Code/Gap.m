function gap=Gap(Ns,Nr,Lt,Lc,seq)
% Gap between two rings.
gap=zeros(6,2);
midL=sqrt(Lt^2-Lc(seq,:).^2/2/(1+cos(pi/Nr)));
gap(3:4,:)=repmat(midL,2,1);
if seq~=1
    anteL=sqrt(Lt^2-Lc(seq-1,:).^2/2/(1+cos(pi/Nr)));
    gap(1,:)=anteL;
    gap(2,:)=(anteL+midL)/2;
end
if seq~=Ns
    postL=sqrt(Lt^2-Lc(seq+1,:).^2/2/(1+cos(pi/Nr)));
    gap(6,:)=postL;
    gap(5,:)=(postL+midL)/2;
end
