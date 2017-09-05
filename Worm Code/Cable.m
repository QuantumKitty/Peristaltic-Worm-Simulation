function LcM=Cable(Lc)
% Generalized cable lengths (For all rings).
% Linearize.
[Ns,~]=size(Lc);
LcM=zeros(Ns,3,2);
for i=1:Ns
    for j=1:3
        if j==1&&i==1; LcM(i,j,:)=Lc(i,:)-(Lc(i,:)-Lc(i+1,:))/3;
        elseif j==1; LcM(i,j,:)=Lc(i,:)+(Lc(i-1,:)-Lc(i,:))/3;
        end
        if j==2; LcM(i,j,:)=Lc(i,:); end
        if j==3&&i==Ns; LcM(i,j,:)=Lc(i,:)+(Lc(i-1,:)-Lc(i,:))/3;
        elseif j==3; LcM(i,j,:)=Lc(i,:)-(Lc(i,:)-Lc(i+1,:))/3;
        end
    end
end
