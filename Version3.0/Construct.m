function [hNode,hCable,hTube]=Construct(Ns,Nr,Node,Ini,color,hNode,hCable,hTube)
% Create an initial body.
if Ini
    colorN='m';
else
    colorN='k';
end
for iN=1:Ns       % Node plot.
    for jN=1:3
        for kN=1:Nr
            hNode{iN,jN,kN}=plot3(Node(iN,jN,kN,1),Node(iN,jN,kN,2),...
                Node(iN,jN,kN,3),'Color',colorN,'Marker','.','MarkerSize',25);
        end
    end
end
for iT=1:Ns      % Tube&Cable plot.
    for jT=1:3
        if iT==Ns&&jT==3; break;end
        if Ini
            colorP='y';
        else
            colorP=[(3*(iT-1)+jT)/3/Ns,1-(3*(iT-1)+jT)/3/Ns,color];
        end
        for kT=1:Nr
            if ~Ini&&jT==2; hCable{iT,kT}=plot3(...
                    [Node(iT,jT,kT,1),Node(iT,jT,mod(kT,Nr)+1,1)],...
                    [Node(iT,jT,kT,2),Node(iT,jT,mod(kT,Nr)+1,2)],...
                    [Node(iT,jT,kT,3),Node(iT,jT,mod(kT,Nr)+1,3)],...
                    'Color','b','LineWidth',1);
            end
            iT1=iT+floor(jT/3);
            jT1=mod(jT,3)+1;
            kT1=kT+(-1)^(iT+jT);
            kT2=kT1+Nr*(fix((Nr-kT1)/Nr)-fix(kT1/(Nr+1)));
            hTube{iT,jT,kT,1}=plot3(...
                [Node(iT,jT,kT,1),Node(iT1,jT1,kT,1)],...
                [Node(iT,jT,kT,2),Node(iT1,jT1,kT,2)],...
                [Node(iT,jT,kT,3),Node(iT1,jT1,kT,3)],...
                'Color',colorP,'LineWidth',2);
            hTube{iT,jT,kT,2}=plot3(...
                [Node(iT,jT,kT,1),Node(iT1,jT1,kT2,1)],...
                [Node(iT,jT,kT,2),Node(iT1,jT1,kT2,2)],...
                [Node(iT,jT,kT,3),Node(iT1,jT1,kT2,3)],...
                'Color',colorP,'LineWidth',2);
        end
    end
end