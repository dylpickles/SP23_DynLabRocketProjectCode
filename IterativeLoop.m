function IterativeLoop(delta_t)
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
    
    %Flight 14 Data
    %200	ml water
    %20	psi launch pressure
    %54 ft apogee
    
    %Setting initial conditions on the persistent arrays
    P_int = 30*6.89476;      %internal pressure [kPa], converted from psi
    v_rocket = 0;   %velocity of the rocket relative to a fixed frame [m/s]
    h = 0;          %height [m]
    V_water = 150/1000000; %for the test flight we care about
    
    %Constant variables
    R_water = 997;      %density of liquid water [kg/m^3]
    R_air =  1.293;     %density of atmospheric air [kg/m^3]
    C_d = 0.5;          %Drag coefficient [Unitless]
    g = 9.81;           %gravitational constant [m/s^2]
    m_water = V_water*R_water; %mass of the water in the rocket [kg]
    
    m_rocket = 0; %this is changing but dependent on m_water anyways
    m_bottle = 0.198; %mass of empty bottle without water [kg]
    V_bottle = 1250/1000000; %fillable volume of the empty bottle [m^3], 1250mL
    
    m_air = (V_bottle-V_water)*R_air;
    
    P_atm = 101.325; %atmospheric pressure [kPa]
    D_rocket = 0.086; %diameter of the rocket [m]
    D_nozzle = 0.01; %diameter of the rocket [m]
    A_rocket = pi()*(D_rocket/2)^2; %cross sectional area of rocket body [m^2]
    A_nozzle = pi()*(D_nozzle/2)^2; %cross sectional area of rocket nozzle [m^2]
    gamma = 1.4; %
    
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
    pARRAY = [];
    mARRAY = [];
    vARRAY = [];
    hARRAY = [];
    tARRAY = [];

    if isempty(vARRAY)
        vARRAY(1) = 0;
    end
    
    persistent totalTime; %total elapsed time
    if isempty(totalTime)
        totalTime = 0;
    end

    pARRAY = [pARRAY, P_int];
    mARRAY = [mARRAY, m_water];
    vARRAY = [vARRAY, v_rocket];
    hARRAY = [hARRAY, h];
    tARRAY = [tARRAY, 0];
    
    frame = 2;

    %loop until velocity < 0 
    while vARRAY(frame-1)>= -5 
        
        %initiation
        v_water = sqrt(2*(pARRAY(frame-1))/(R_water*(1-(A_nozzle/A_rocket)^2)));
        v_WR = A_nozzle*v_water/A_rocket;
        m_dot = -R_water*A_nozzle*v_WR;
        V1 = V_bottle - m_water/R_water;
        m_rocket = mARRAY(frame-1) + m_air + m_bottle;

        %assessment
        F_thrust = -m_dot*v_WR+A_nozzle*(pARRAY(frame-1))*1000; %x1000 bc we're using kPa and need to be using Pa
        %the "-" in front of the m_dot term is to unify the direction such
        %that thrust is pointing upwards
        F_weight = m_rocket*g;
        F_drag = 1/2*R_air*vARRAY(frame-1)^2*C_d*A_rocket;
        
        fprintf('Frame: %i Forces |Thrust: %f|Weight: %f|Drag: %f \n', frame, F_thrust, F_weight, F_drag);

        %progression
        F_net = F_thrust - F_weight - F_drag;
        mARRAY(frame) = mARRAY(frame-1) + m_dot*delta_t;
        V2 = V_bottle - mARRAY(frame)/R_water;
        next_m_rocket = mARRAY(frame) + m_air + m_bottle; %using updated m_water value
        vARRAY(frame) = (m_rocket*vARRAY(frame-1)+ F_net*delta_t)/next_m_rocket;
        pARRAY(frame) = pARRAY(frame-1)*(V1/V2)^gamma;
        hARRAY(frame) = vARRAY(frame-1)*delta_t;

        %timekeeping
        tARRAY(frame) = tARRAY(frame-1)+delta_t;
        
        fprintf('Frame: %i |P: %fkPa|V: %fm/s|M: %fkg |Time: %fs\n', frame, pARRAY(frame), vARRAY(frame), mARRAY(frame), tARRAY(frame));

        frame = frame + 1;
    end
    
    plot(tARRAY, hARRAY);
    title('Cool Rocket Simulation');
    xlabel('Time (s)');
    ylabel('Position (m)');
    
    max_height = max(hARRAY)*3.28*7 %max height in feet, 7 is our BS factor
end