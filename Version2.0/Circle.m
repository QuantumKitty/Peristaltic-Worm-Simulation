function Node0=Circle(Nr,Lst1,Lst2,position,Center0,theta0)
% Locate nodes for 1 circle
% position= -1(near) / 1(far)
Node0=zeros(Nr,3);
dir=sign(Lst2-Lst1);
alpha0=pi/2/Nr;
LstC=linspace(min(Lst1,Lst2),max(Lst1,Lst2),Nr/2);
Rst=LstC/2/sin(pi/Nr);
Rst=[fliplr(Rst),Rst];
Rotate=[cos(theta0) -sin(theta0) 0;sin(theta0) cos(theta0) 0;0 0 1];
for i=1:Nr
    alpha=2*pi*(i-1)/Nr-alpha0*position;
    j=mod(i-floor(Nr/4)+1+round((dir+1)*Nr/4),Nr)+1;
    Node0(i,:)=Rotate*[0; -Rst(j)*sin(alpha); -Rst(j)*cos(alpha)]+Center0;
end
