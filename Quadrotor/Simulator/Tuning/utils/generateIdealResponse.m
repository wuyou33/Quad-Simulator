function wanted_pos = generateIdealResponse(name, simulation_time, ts, initial_value, final_value,...
    initial_delay, ramp_lenght, overshoot, overshoot_lenght, overshoot_div, overshoot_numbers)

t = (0:ts:simulation_time)';

DIV_LENGHT=2;

wanted_pos=repmat(initial_value,simulation_time/ts+1,1);

% Ramp
START_CYCLE=initial_delay;
END_CYCLE=initial_delay+ramp_lenght;
for i= START_CYCLE:END_CYCLE
    wanted_pos(i)=(i-START_CYCLE)/(END_CYCLE-START_CYCLE);
end

% Overshoot
for num_cycles = 1:overshoot_numbers
    START_CYCLE=END_CYCLE;
    END_CYCLE=START_CYCLE+floor(overshoot_lenght/DIV_LENGHT);
    INITIAL_POS=0;
    if(mod(num_cycles,2))
        SIGNUM = 1;
    else
        SIGNUM = -1;
    end
    INCREMENT=SIGNUM*overshoot/(num_cycles*overshoot_div);
    for i= START_CYCLE:END_CYCLE
        wanted_pos(i)=1+INITIAL_POS+INCREMENT*(i-START_CYCLE)/(END_CYCLE-START_CYCLE);
    end
    START_CYCLE=END_CYCLE;
    END_CYCLE=START_CYCLE+floor(overshoot_lenght/DIV_LENGHT);
    INITIAL_POS=INCREMENT;
    INCREMENT=-INCREMENT;
    for i= START_CYCLE:END_CYCLE
        wanted_pos(i)=1+INITIAL_POS+INCREMENT*(i-START_CYCLE)/(END_CYCLE-START_CYCLE);
    end
end

% Stable
START_CYCLE=END_CYCLE;
END_CYCLE=simulation_time/ts+1;
for i= START_CYCLE:END_CYCLE
    wanted_pos(i)=final_value;
end

wanted_pos = timeseries(wanted_pos,t,'Name',name);

