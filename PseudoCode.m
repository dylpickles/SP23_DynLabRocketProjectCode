%{
test2
Launch Stages: 
1. Propulsion
    Closed, pressurized system
    Open, Water Thrust
    Open, Air Thrust
2. Descent
    Ballistic trajectory descent
    
Can you simply code each launch ...
stage as it's own thing without ...
needing recursion? 

Variables
R_water = %density of water [kg/m^3]
R_air = %density of atmospheric air [kg/m^3]

C_d = 0.5 %Drag coefficient
mu = %friction coefficient

m_rocket = %mass of empty bottle without water
m_water = %mass of water in the bottle

P_atm = %atmospheric pressure, [kPa]
D_rocket = %diameter of the rocket
A_rocket = %cross sectional area of rocket body [m^3]
A_nozzle = %cross sectional area of rocket nozzle [m^3]

v_rocket = %absolute velocity of the rocket
v_water = %expulsion velocity of the water

no_water = 0 %set to 1 when the mass of water in the rocket is below...
                or equal to 0, this then should enable something later...
                to start decreasing air mass

Equations: 
Drag
F_drag = 0.5*

How do we test sections of our code and check the accuracy of all our inputs? 
    Vet every hard coded number we're putting in esp with units

Reynolds Transport? 

Unsorted assumptions: 
1. Assume rocket flight path is basically straight up
    should we assume some launch angle? that'll def significantly change...
    the expected max height

Calculating A_rocket
Assumptions: 
1. Rocket is perfect cylinder
A_rocket = pi*(D_rocket/2)^2


%}