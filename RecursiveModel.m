function RecursiveModel(delta_t)
    % This is a function that models the flight dynamics for water bottle 
    % rockets

    %Gonna first test out how hard it'll be to write as an iterative functino
    % recursive function
    %We can write a

    %Keep iterating the code while rocket has positive velocity

    %Preassigning values to
    %The 3 key variables that will persist, water mass, rocket velocity, and 
    %internal bottle pressure
    %we can set the conditions for the simulation inside the code
    %before we compile and run it, as opposed to having the overall functiona
    %call include conditions bc as a re

    %The variable values here serve no purpose beyond holding space
    P_int = 0;      %internal pressure [kPa]
    m_water = 0;    %mass of the water in the rocket [kg]
    v_rocket = 0;   %velocity of the rocket relative to a fixed frame

    F_thrust = 0;   %thrust force on the rocket
    F_weight = 0;   %thrust force on the rocket
    F_drag = 0;     %thrust force on the rocket

    %{
    Your final report should present your results from the semester. 
    At a minimum, your report should include experimental and 
    theoretical comparisons for: peak altitude, thrust duration, 
    maximum thrust force, and position vs. time plots.  

    Project submission requires
     - peak altitude
        need a persistent height matrix
     - thrust duration
        will need
     - maximum thrust force
     - position vs. time plots
    %}

    %Constant variables, currently filled with dummy numbers
    R_water = 997 %density of liquid water [kg/m^3]
    R_air =  1.293 %density of atmospheric air [kg/m^3]
    C_d = 0.5 %Drag coefficient [Unitless]
    g = 9.81 %gravitational constant [m/s^2]
    m_bottle = 0; %mass of empty bottle without water [kg]
    V_bottle = 0; %fillable volume of the empty bottle [kg]
    m_air = 0.25 %mass of empty bottle without water [kg]
    P_atm = 0.01 %atmospheric pressure [kPa]
    D_rocket = 0.1 %diameter of the rocket [m]
    D_nozzle = 0.02 %diameter of the rocket [m]
    A_rocket = pi()*(D_rocket/2)^2%cross sectional area of rocket body [m^3]
    A_nozzle = pi()*(D_nozzle/2)^2%cross sectional area of rocket nozzle [m^3]
    gamma = 1.4 %

    %Changing variables 
    persistent v_water = 0 %velocity of water moving inside of rocket body
    persistent v_WR  = 0 %expulsion velocity of the water in relation to the rocket's nozzle
    persistent m_rocket = 0; %total mass of rocket in CV [kg]

    bool_waterleftinside = 1 %set to 0 when the mass of water in the 
    %rocket is below or equal to 0, this then should enable something 
    %later to start decreasing air mass

    %persistent arrays for the values that we're looking to keep track of
    %by the end of the simulation and during each iteration for plotting
    %and analysis
    persistent pARRAY;
    persistent mARRAY;
    persistent vARRAY;
    persistent hARRAY;
    persistent tARRAY;

    if isempty(vARRAY)
        vARRAY(1) = 0;
    end
    
    persistent totalTime; %total elapsed time
    if isempty(totalTime)
        totalTime = 0;
    end
    
    persistent count;
    if isempty(count)
        count = 1;
    end

    if (vARRAY(count) < 0)
        plot(tARRAY, hARRAY);
        title('Cool Rocket Simulation');
        xlabel('Time (s)');
        ylabel('Position (m)');
        
        clear RecursiveModel;
    elseif(isempty(pARRAY)||isempty(mARRAY)||isempty(vARRAY)||isempty(hARRAY))
        %Setting initial conditions on the persistent arrays
        P_int = 1;      %[kPa]
        m_water = 1;    %[kg]
        v_rocket = 0;    %[m/s]
        m_water = 0;    %[m]

        pARRAY = [pARRAY, P_int];
        mARRAY = [mARRAY, m_water];
        vARRAY = [vARRAY, v_rocket];
        hARRAY = [hARRAY, h];
        tARRAY = [tARRAY, totalTime];
        
        RecursiveModel(delta_t);
    else
        % Calling our sub-functions
        [v_water, m_dot, V1] = initiation(mARRAY(count), vARRAY(count), pARRAY(count));
        [F_thrust, F_weight, F_drag] = assessment(v_water);
        [mARRAY(count+1), vARRAY(count+1), pARRAY(count+1)] = progression(F_thrust, F_weight, F_drag, V1);
        hARRAY(count+1) = vARRAY(count+1)*delta_t;

        totalTime = delta_t + totalTime;
        tARRAY = [tARRAY, totalTime];
        
        count = count + 1;
        
        %Initiating recursion
        RecursiveModel(delta_t);
    end
end

function [v_water, m_dot, V1] = initiation(m_water, v_rocket, P_int)
    v_water = sqrt(2(P_int-P_atm)/(R_water(1-(A_nozzle/A_rocket)^2)));
    v_WR = A_nozzle*v_water/A_rocket;
    m_dot = R_water*A_nozzle*v_WR;
    V1 = V_bottle - m_water/R_water;
end

function [F_thrust, F_weight, F_drag] = assessment(v_water)
    F_thrust = m_dot*v_water+A_nozzle*(P_int-P_atm);
    m_rocket = m_water + m_air + m_bottle;
    F_weight = m_rocket*g;
    F_drag = 1/2*R_air*v_rocket^2*C_d*A_rocket;
end

function [m_water, v_rocket, P_int] = progression(F_thrust, F_weight, F_drag, V1)
    F_net = F_thrust - F_weight - F_drag;
    m_water = m_water + m_dot*delta_t;
    V2 = V_bottle - m_water/R_water;
    next_m_rocket = m_water + m_air + m_bottle; %using updated m_water value
    v_rocket = (m_rocket*v_rocket + F_net*delta_t)/next_m_rocket;
    P_int = P_int*(V1/V2)^gamma
end