function Node0=Ring(Nr,Lc0,position,Center0,theta0)
% Locate nodes inside one ring.
Node0=zeros(Nr,3);
dir=sign(Lc0(2)-Lc0(1));
alpha0=pi/2/Nr;
LcR=linspace(min(Lc0),max(Lc0),Nr/2);
Rc=LcR/2/sin(pi/Nr);
Rc=[fliplr(Rc),Rc];
Rotate=[cos(theta0) -sin(theta0) 0;sin(theta0) cos(theta0) 0;0 0 1];
for i=1:Nr
    alpha=2*pi*(i-1)/Nr-alpha0*position;
    j=mod(i-floor(Nr/4)+1+round((dir+1)*Nr/4),Nr)+1;
    Node0(i,:)=Rotate*[0; -Rc(j)*sin(alpha); -Rc(j)*cos(alpha)]+Center0;
end