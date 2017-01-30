function direction=Anchor(Control,Lst,Lmax)
% determine which direction and which segments to move
% this is a rough estimation
% force analysis will help improve the precision
[Ns,~]=size(Lst);
[Ms,~]=size(Control);
seq=Control(:,3);
direction=zeros(1,Ms);
[anteAnchor,postAnchor]=deal(0);
for i=1:Ms
    for j1=1:seq(i)-1
        if ~any(j1==seq)&&isequal(Lst(j1,:),[Lmax,Lmax])
            anteAnchor=anteAnchor+1;
        end
    end
    for j2=seq(i)+1:Ns
        if ~any(j2==seq)&&isequal(Lst(j2,:),[Lmax,Lmax])
            postAnchor=postAnchor+1;
        end
    end
    if anteAnchor~=postAnchor
        direction(i)=sign(postAnchor-anteAnchor);
    elseif seq(i)-1~=Ns-seq(i)
        direction(i)=sign(Ns-2*seq(i)+1);
    else
        direction(i)=1;
    end
end
