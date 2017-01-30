function LstM=String(Lst)
% extend and linearize string length
[Ns,~]=size(Lst);
LstM=zeros(Ns,3,2);
for i=1:Ns
    for j=1:3
        if j==1&&i==1; LstM(i,j,:)=Lst(i,:)-(Lst(i,:)-Lst(i+1,:))/3;
        elseif j==1; LstM(i,j,:)=Lst(i,:)+(Lst(i-1,:)-Lst(i,:))/3;
        end
        if j==2; LstM(i,j,:)=Lst(i,:); end
        if j==3&&i==Ns; LstM(i,j,:)=Lst(i,:)+(Lst(i-1,:)-Lst(i,:))/3;
        elseif j==3; LstM(i,j,:)=Lst(i,:)-(Lst(i,:)-Lst(i+1,:))/3;
        end
    end
end
