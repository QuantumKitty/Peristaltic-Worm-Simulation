function Dgap=DeltaGap(Ns,gap,Center,seq)
% 2 neighbouring circles' delta gap between each 2 frames
Dgap=zeros(1,6);
Dgap(3)=mean(gap(3,:))-norm(squeeze(Center(seq,1,:))-squeeze(Center(seq,2,:)));
Dgap(4)=mean(gap(4,:))-norm(squeeze(Center(seq,2,:))-squeeze(Center(seq,3,:)));
if seq~=1
    Dgap(1)=mean(gap(1,:))-norm(squeeze(Center(seq-1,2,:))-squeeze(Center(seq-1,3,:)));
    Dgap(2)=mean(gap(2,:))-norm(squeeze(Center(seq-1,3,:))-squeeze(Center(seq,1,:)));
end
if seq~=Ns
    Dgap(5)=mean(gap(5,:))-norm(squeeze(Center(seq,3,:))-squeeze(Center(seq+1,1,:)));
    Dgap(6)=mean(gap(6,:))-norm(squeeze(Center(seq+1,1,:))-squeeze(Center(seq+1,2,:)));
end

