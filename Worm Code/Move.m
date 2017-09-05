function State=Move(Control,Parameter,State,Handles)
% Body motion based on the control methods.
[Ns,Nr,Rs,Lt,StepTime,Lmax,CF,Option]=Parameter{:};
[Node,Center,Lc,theta,Time]=State{:};
Time0=0;    % Local time.
[Ms,~]=size(Control);  %  Number of moving segments.
direction=Anchor(Control,Lc,Lmax);   % Which direction to move.
step=zeros(Ms,2);  % Step distance of cable length (both sides).
while 1     % Iterate frames.
    % Motion data are usually extracted here.(The moment before each frame)
    % Use the plot handles from the main code to plot graphs.
    % If codes for one figure are deleted from the main code, that figure's
    %   corresponding codes here should also be deleted to avoid bugs.
    
    % An example of the plot of 1st Seg's center X-coord vs time.
    addpoints(Handles{5},Time,Center(1,2,1))
    
    % An example of the slip trajectory plot.
    % Make sure codes for figure3 are enabled or disabled in both "Worm.m" and "Move.m".
    %figure(3)
    %for iSk=1:Ns
    %    if abs(Lc(iSk,:)-[Lmax,Lmax])<(0.01*[Lmax,Lmax])
    %        plot(Node(iSk,2,1,1),Node(iSk,2,1,2),'Color',[iSk/Ns,1-iSk/Ns,Option(3)],'Marker','.','MarkerSize',5)
    %    end
    %end
    
    for iMs=1:Ms
        seq=Control(iMs,3);    % Which segment to move.
        dir=direction(iMs);    % Which direction to move.
        LcM1=Cable(Lc);   % Generalized cable lengths before.
        gap1=Gap(Ns,Nr,Lt,Lc,seq);   % Gap between two rings before.
        beta1=Beta(Ns,Nr,LcM1,gap1,seq); % Included angles between two neighboring rings before.
        [Vexpand,Vcontract,Tau]=Speed(Time0); % Read actuator speeds.
        speed=Vexpand*(Control(iMs,1:2)>0)+Vcontract*(Control(iMs,1:2)<0); % Actuator speeds.
        step(iMs,:)=Control(iMs,1:2).*speed*StepTime*pi*Rs/15/Nr; % Step distance of cable length change.
        Lc(seq,:)=Lc(seq,:)+CF(3)*step(iMs,:);   % Update cable length.
        LcM2=Cable(Lc);   % Generalized cable lengths after.
        gap2=Gap(Ns,Nr,Lt,Lc,seq);   % Gap between two rings after.
        beta2=Beta(Ns,Nr,LcM2,gap2,seq); % Included angles between two neighboring rings after.
        Dgap=dir*CF(1)*(gap2-gap1);    % Delta gap between two frames.
        Dbeta=dir*CF(2)*(beta2-beta1);  % Delta beta between two frames.
        for iM=1+2*~(seq-1):6-2*~(seq-Ns)   % #Gap
            AncSeg=seq+floor((iM-(5-dir)/2)/3); % Anchoring segment during motion.
            MovSeg=seq+floor((iM-(5+dir)/2)/3); % Moving segment during motion.
            AncRing=mod(iM+(1+dir)/2,3)+1; % Anchoring ring during motion.
            MovRing=mod(iM+(1-dir)/2,3)+1; % Moving ring during motion.
            Ctheta=(theta(AncSeg,AncRing)+theta(MovSeg,MovRing))/2; % Moving direction during motion.
            Ccoord=squeeze(Center(AncSeg,AncRing,:)+Center(MovSeg,MovRing,:))/2; % Rotate center during motion.
            Break=0;
            for jM=((1-Ns)*dir+1+Ns)/2:dir:seq+dir     % #Seg
                if Break==1; break; end
                for kM=2-dir:dir:2+dir     % #Ring
                    if jM==AncSeg&&kM==AncRing; Break=1; break; end
                    Rotate=[cos(Dbeta(iM)) -sin(Dbeta(iM)) 0; sin(Dbeta(iM)) cos(Dbeta(iM)) 0; 0 0 1]; % Rotate matrix.
                    Center(jM,kM,:)=squeeze(Center(jM,kM,:))+[cos(Ctheta);sin(Ctheta);0]*Dgap(iM);  % Straight motion.
                    Center(jM,kM,:)=(Rotate*(squeeze(Center(jM,kM,:))-Ccoord)+Ccoord)';   % Turning motion.
                    theta(jM,kM)=theta(jM,kM)+Dbeta(iM);   % Update each ring's theta.
                    Node(jM,kM,:,:)=Ring(Nr,LcM2(jM,kM,:),(-1)^(jM+kM-1),squeeze(Center(jM,kM,:)),theta(jM,kM));   % Update each ring's nodes.
                end
            end
        end
    end
    Update(Ns,Nr,Node,Handles{1:3});    % Update the body status.
    Time=Time+StepTime;
    Time0=Time0+StepTime;
    if Time0>Tau; break; end    % End of one control
    if Option(2); writeVideo(Handles{4},getframe(gcf)); end    % Video recording
    drawnow
end
State={Node,Center,Lc,theta,Time};     % Return the model's state.
