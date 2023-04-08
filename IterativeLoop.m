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
    
    m_rocket = 0; %this is changing but dependent on m_water anyways
    m_bottle = 0; %mass of empty bottle without water [kg]
    m_air = 0.25 %mass of empty bottle without water [kg]
    V_bottle = 0; %fillable volume of the empty bottle [m^3]
    
    P_atm = 0.01; %atmospheric pressure [kPa]
    D_rocket = 0.1; %diameter of the rocket [m]
    D_nozzle = 0.02; %diameter of the rocket [m]
    A_rocket = pi()*(D_rocket/2)^2; %cross sectional area of rocket body [m^3]
    A_nozzle = pi()*(D_nozzle/2)^2; %cross sectional area of rocket nozzle [m^3]
    gamma = 1.4; %
    
    %initial values, will be set in another scope
    m_water; 
    m_water = 0;   %mass of the water in the rocket [kg]
    P_int = 0;      %internal pressure [kPa]
    v_rocket = 0;   %velocity of the rocket relative to a fixed frame
    
    %these variables change but are derived from the other changing
    %variables. The values here are purely for initializing the variable.
    v_water = 0;    %velocity of water moving inside of rocket body
    v_WR = 0;       %expulsion velocity of the water in relation to the rocket's nozzle
    F_thrust = 0;   %thrust force on the rocket
    F_weight = 0;   %thrust force on the rocket
    F_drag = 0;     %thrust force on the rocket
    
    bool_waterleftinside = true; %set to 0 when the mass of water in the 
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
        count = 0;
    end

    %loop until velocity < 0 
    while (!(vARRAY(count)<0)) 
        if (count = 0)
            %Setting initial conditions on the persistent arrays
            P_int = 1;      %[kPa]
            m_water = 1;    %[kg]
            v_rocket = 0;   %[m/s]
            h = 0;          %[m]

            pARRAY = [pARRAY, P_int];
            mARRAY = [mARRAY, m_water];
            vARRAY = [vARRAY, v_rocket];
            hARRAY = [hARRAY, h];
            tARRAY = [tARRAY, 0];
        elseif (count > 0)
            %initiation
            v_water = sqrt(2*(pARRAY(count)-P_atm)/(R_water*(1-(A_nozzle/A_rocket)^2)));
            v_WR = A_nozzle*v_water/A_rocket;
            m_dot = R_water*A_nozzle*v_WR;
            V1 = V_bottle - m_water/R_water;

            %assessment
            F_thrust = m_dot*v_water+A_nozzle*(pARRAY(count)-P_atm);
            m_rocket = mARRAY(count) + m_air + m_bottle;
            F_weight = m_rocket*g;
            F_drag = 1/2*R_air*v_rocket^2*C_d*A_rocket;

            %progression
            F_net = F_thrust - F_weight - F_drag;
            mARRAY(count+1) = mARRAY(count) + m_dot*delta_t;
            V2 = V_bottle - mARRAY(count+1)/R_water;
            next_m_rocket = mARRAY(count+1) + m_air + m_bottle; %using updated m_water value
            vARRAY(count+1) = (m_rocket*vARRAY(count)+ F_net*delta_t)/next_m_rocket;
            pARRAY(count+1) = pARRAY(count)*(V1/V2)^gamma
            hARRAY(count+1) = vARRAY(count)*delta_t;

            %timekeeping
            tARRAY(count+1) = tARRAY(count)+delta_t;

            count = count + 1;
        else
            disp('uh oh');
        end
    end

    plot(tARRAY, hARRAY);
    title('Cool Rocket Simulation');
    xlabel('Time (s)');
    ylabel('Position (m)');
end