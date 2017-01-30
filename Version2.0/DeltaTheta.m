function Dtheta=DeltaTheta(Ns,Nr,LstM,gap,theta,seq,dir)
% delta theta of circle between each 2 frames
% this function still needs to be improved for more precise simulation
Dtheta=zeros(1,6);
DiaMin=195*2;   % needs a better calculation
theta0=theta(seq,1)-theta(seq,2);
%DiaMin=2*min(LstM(seq,1,:))/2/sin(pi/Nr);
Dtheta(3)=dir*(atan((gap(3,2)-gap(3,1))/DiaMin)-theta0);
theta0=theta(seq,2)-theta(seq,3);
%DiaMin=2*min(LstM(seq,2,:))/2/sin(pi/Nr);
Dtheta(4)=dir*(atan((gap(4,2)-gap(4,1))/DiaMin)-theta0);
if seq~=1
    theta0=theta(seq-1,2)-theta(seq-1,3);
    %DiaMin=2*min(LstM(seq-1,2,:))/2/sin(pi/Nr);
    Dtheta(1)=dir*(atan((gap(1,2)-gap(1,1))/DiaMin)-theta0);
    theta0=theta(seq-1,3)-theta(seq,1);
    %DiaMin=2*min(LstM(seq-1,3,:))/2/sin(pi/Nr);
    Dtheta(2)=dir*(atan((gap(2,2)-gap(2,1))/DiaMin)-theta0);
end
if seq~=Ns
    theta0=theta(seq,3)-theta(seq+1,1);
    %DiaMin=2*min(LstM(seq,3,:))/2/sin(pi/Nr);
    Dtheta(5)=dir*(atan((gap(5,2)-gap(5,1))/DiaMin)-theta0);
    theta0=theta(seq+1,1)-theta(seq+1,2);
    %DiaMin=2*min(LstM(seq+1,1,:))/2/sin(pi/Nr);
    Dtheta(6)=dir*(atan((gap(6,2)-gap(6,1))/DiaMin)-theta0);
end