% constants
p_atm = 101325; % Pa
psiToPa = 6894.76; % conversion factor
gamma = 1.4; % adiabatic index of air
c_d = 0.345; % estimated coefficient of drag (from NASA)
rho_air = 1.293; % kg/m^3
rho_water = 997; % kg/m^3
m_rocket = 0.198; % empty rocket mass, kg
v_rocket = 1.25*0.001; % m^3
r_rocket = 0.043; % m
r_nozzle = 0.015; % m
g = 9.81; % m/s^2
mToFt = 3.28; % conversion factor
beta = 0.5*c_d*rho_air*pi()*r_rocket^2; % multiplying constants for the drag force

% simulation parameters
delta_t = 0.01; % s, can set different delta time steps
launchPressure = input("What was the gauge launch pressure in psi? ")*psiToPa; % converted to Pa
launchVolume = input("What was the initial volume of water in mL? ")*10^(-6); % converted to m^3
initAirVolume = v_rocket - launchVolume;
cutoffSpeed = 10; % m/s, max downward speed before ending simulation
turbulenceFactor = 1.5; %experimental

% frame 1 (initial conditions) and setting up arrays
p = zeros(10000, 1);
p(1) = launchPressure + p_atm; % start pressure array with p(1) = initial total pressure
m = zeros(10000, 1);
m(1) = m_rocket + launchVolume * rho_water; % start mass array with m(1) = initial total mass
m_dot = zeros(10000, 1);
m_dot(1) = -pi()*r_nozzle^2*rho_water*sqrt(2*launchPressure/rho_water);
v = zeros(10000, 1);
% start velocity array with v(1) = 0 m/s
h = zeros(10000, 1); % start height array with h(1) = 0 m/s
T = zeros(10000, 1);
T(1) = 2*pi()*r_nozzle^2*launchPressure; % start thrust force array with T(1) = initial thrust force
time = zeros(10000, 1);

% looping calculations
i = 1; % index
while(v(i) > -cutoffSpeed && i < 10000)
    time(i+1) = time(i) + delta_t;
    p(i+1)= p(1)*((initAirVolume + (m(1) - m(i))/rho_water)/initAirVolume)^(-gamma);
    
    fprintf('Frame: %i |P: %fPa|v: %fm/s|Height: %fft|m: %fkg |m_dot: %fkg/s|Time: %fs\n', i, p(i), v(i), h(i), m(i), m_dot(i), time(i));
    if(m(i) >= m_rocket)
        %disp("thrusting")
        T(i+1) = 2*pi()*r_nozzle^2*(p(i)-p_atm);
        m_dot(i+1) = -pi()*r_nozzle^2*rho_water*sqrt(2*(p(i)-p_atm)/rho_water)/turbulenceFactor;
        v(i+1) = v(i) + (T(i)/m(i) - g - (beta*v(i)*abs(v(i)))/m(i))*delta_t;
        h(i+1) = h(i) + v(i)*delta_t;
        m(i+1) = m(i) + m_dot(i)*delta_t;
    else
        %disp("weee")
        v(i+1) = v(i) + (-g -(beta*v(i)*abs(v(i)))/m_rocket)*delta_t;
        h(i+1) = h(i) + v(i)*delta_t;
        m(i+1) = m(i);
    end
    
    i = i + 1;
end

plot(time(1:i), mToFt*h(1:i));
disp("Max Height: " + num2str(mToFt*max(h)) + " ft")

