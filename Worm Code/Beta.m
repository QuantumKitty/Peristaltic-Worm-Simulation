function beta=Beta(Ns,Nr,LcM,gap,seq)
% Included angles between two neighboring rings.
beta=ones(1,6);
RingDia=ones(1,6);  % Ring Diameter
RingDiaM=ones(1,7);
for iM=1:7
    Seg=seq+floor((iM-3)/3);
    Ring=mod(iM,3)+1;
    if ~(Seg==0||Seg==Ns+1)
        RingDiaM(iM)=mean(LcM(Seg,Ring,:))*2*cos(pi/Nr);
    end
end
for i=1:6
    RingDia(i)=mean([RingDiaM(i) RingDiaM(i+1)]);
    beta(i)=atan((gap(i,2)-gap(i,1))/RingDia(i));
end