function State=Move(Control,Parameter,State,Option,Handles)
% segment movement
[Ns,Nr,StepTime,UnitTime,Lp,Lmax]=Parameter{:};
[Node,Center,Lst,theta,Time]=State{:};
Time0=Time;
[Ms,~]=size(Control);  % #moving segments
direction=Anchor(Control,Lst,Lmax);   % which direction to move
step=zeros(Ms,2);  % step distance for string length (both sides)
for iS=1:Ms
    step(iS,:)=(Control(iS,[1 2])-Lst(Control(iS,3),:))/UnitTime*StepTime;
end
while 1     % iterate frames
    if ~Option(1)
        for iSk=1:Ns
            if isequal(Lst(iSk,:),[Lmax,Lmax])
                addpoints(Handles{5}{iSk},Node(iSk,2,1,1),Node(iSk,2,1,2))
            end
        end
        for iB=1:Ns
            for jB=1:2
                kNr=3*jB-1/2+(-1)^iB/2;
                Lside=norm(squeeze(Node(iB,1,kNr,1:2)-Node(iB,3,kNr,1:2)));
                addpoints(Handles{6}{iB,jB},Time,Lside+200*(iB-1))
            end
        end
        for iA=1:Ns-1
            InAngle=abs(theta(iA,2)-theta(iA+1,2))*180/pi;
            addpoints(Handles{7}{iA},Time,InAngle+100*(iA-1))
        end
    end
    for iMs=1:Ms    % which segment to move
        seq=Control(iMs,3);    % which segment to move
        dir=direction(iMs);    % which direction to move
        Lst(seq,:)=Lst(seq,:)+step(iMs,:);   % update string length
        gap=Gap(Ns,Nr,Lp,Lst,seq);   % gap between two circles
        Dgap=DeltaGap(Ns,gap,Center,seq);    % 2 neighbouring circles' delta gap between each 2 frames
        LstM=String(Lst);   % extend and linearize string length
        Dtheta=DeltaTheta(Ns,Nr,LstM,gap,theta,seq,dir);
        for iM=1+2*~(seq-1):6-2*~(seq-Ns)
            thetaIni=theta(seq+floor((iM-(5-dir)/2)/3),mod(iM+(1+dir)/2,3)+1);   % posterior or antetior circle's theta
            Rcenter=squeeze(Center(seq+floor((iM-(5+dir)/2)/3),mod(iM+(1-dir)/2,3)+1,:));     % rotate center, current circle
            Break=0;
            for jM=((1-Ns)*dir+1+Ns)/2:dir:seq+dir
                if Break==1; break; end
                for kM=2-dir:dir:2+dir
                    if jM==seq+floor((iM-(5-dir)/2)/3)&&kM==mod(iM+(1+dir)/2,3)+1; Break=1; break; end
                    Center(jM,kM,:)=(Rotate(Dtheta(iM))*(squeeze(Center(jM,kM,:))-Rcenter)+Rcenter)';   % turning movement
                    Center(jM,kM,:)=squeeze(Center(jM,kM,:))+dir*[cos(thetaIni);sin(thetaIni);0]*Dgap(iM);  % straight movement
                    theta(jM,kM)=theta(jM,kM)+Dtheta(iM);   % update each circle's theta
                    Node(jM,kM,:,:)=Circle(Nr,LstM(jM,kM,1),LstM(jM,kM,2),...   % update each circle's nodes
                        (-1)^(jM+kM-1),squeeze(Center(jM,kM,:)),theta(jM,kM));
                end
            end
        end
    end
    for ii=1:Ns
        for jj=1:3
            set(Handles{9}{ii,jj},'XData',Center(ii,jj,1),'YData',Center(ii,jj,2),'ZData',Center(ii,jj,3));
        end
    end
    Update(Ns,Nr,Node,Handles{1:4});
    Time=Time+StepTime;
    if Time-Time0>=UnitTime-StepTime/10; break; end
    if Option(5); writeVideo(Handles{8},getframe(gcf)); end
    drawnow
end
State={Node,Center,Lst,theta,Time};
