function direction=Anchor(Control,Lc,Lmax)
% Determine which direction and which segments to move.
% The side with less anchoring segments will move.
% This is an estimation, precision can be improved.
[Ns,~]=size(Lc);
[Ms,~]=size(Control);
seq=Control(:,3);
direction=zeros(1,Ms);
Tol=0.01; % Segment at MaxDiameter (tolerance=0.01*MaxDia) will anchor.
[anteAnchor,postAnchor]=deal(0);
for i=1:Ms
    for j1=1:seq(i)-1
        if ~any(j1==seq)&&~any(abs(Lc(j1,:)-[Lmax,Lmax])>(Tol*[Lmax,Lmax]))
            anteAnchor=anteAnchor+1;
        end
    end
    for j2=seq(i)+1:Ns
        if ~any(j2==seq)&&~any(abs(Lc(j2,:)-[Lmax,Lmax])>(Tol*[Lmax,Lmax]))
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
