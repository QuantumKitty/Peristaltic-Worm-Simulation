function [v_expand,v_contract,Tau]=Speed(time)
% Actuator speeds and operating time (Tau).
% Speed and Tau should MATCH to avoid exceeding maximum or minimum segment diameter.
%   Otherwise, the simulation will possibly crash (just as the robot will break).
% Different speed methods can be saved in "switch" structure.
method=1;
switch method
    case 1
        Tau=2.37;
        v_expand=70;
        v_contract=70;
    case 2
        Tau=2.99;
        if time<=Tau/2
            v_expand=70;
            v_contract=14.53*time^2+8.69*time+23.92;
        elseif time>Tau/2&&time<=Tau
            v_expand=14.53*(2.99-time)^2+8.69*(2.99-time)+23.92;
            v_contract=70;
        end
end