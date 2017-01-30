function []=Update(Ns,Nr,Node,hNode,hString,hPipe1,hPipe2)
% Update nodes and pipes after each iteration.
for iN=1:Ns       % node update
    for jN=1:3
        for kN=1:Nr
            set(hNode{iN,jN,kN},'XData',Node(iN,jN,kN,1),'YData',...
                Node(iN,jN,kN,2),'ZData',Node(iN,jN,kN,3));
        end
    end
end
for iP=1:Ns      % pipe&string update
    for jP=1:3
        if iP==Ns&&jP==3; break;end
        for kP=1:Nr
            if jP==2; set(hString{iP,kP},...
                    'XData',[Node(iP,jP,kP,1),Node(iP,jP,mod(kP,Nr)+1,1)],...
                    'YData',[Node(iP,jP,kP,2),Node(iP,jP,mod(kP,Nr)+1,2)],...
                    'ZData',[Node(iP,jP,kP,3),Node(iP,jP,mod(kP,Nr)+1,3)]);
            end
            iP1=iP+floor(jP/3);
            jP1=mod(jP,3)+1;
            kP1=kP+(-1)^(iP+jP);
            kP2=kP1+Nr*(fix((Nr-kP1)/Nr)-fix(kP1/(Nr+1)));
            set(hPipe1{iP,jP,kP},...
                'XData',[Node(iP,jP,kP,1),Node(iP1,jP1,kP,1)],...
                'YData',[Node(iP,jP,kP,2),Node(iP1,jP1,kP,2)],...
                'ZData',[Node(iP,jP,kP,3),Node(iP1,jP1,kP,3)]);
            set(hPipe2{iP,jP,kP},...
                'XData',[Node(iP,jP,kP,1),Node(iP1,jP1,kP2,1)],...
                'YData',[Node(iP,jP,kP,2),Node(iP1,jP1,kP2,2)],...
                'ZData',[Node(iP,jP,kP,3),Node(iP1,jP1,kP2,3)]);
        end
    end
end