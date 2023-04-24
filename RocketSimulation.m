% constants
p_atm = 101325;         % Pa
psiToPa = 6894.76;      % conversion factor
gamma = 1.4;            % adiabatic index of air
c_d = 0.345;            % estimated coefficient of drag (from NASA)
rho_air = 1.293;        % kg/m^3
rho_water = 997;        % kg/m^3
m_rocket = 0.198;       % empty rocket mass
v_rocket = 1.25*0.001;  % m^3
r_rocket = 0.043;       % m
r_nozzle = 0.0108;      % m
g = 9.81;               % m/s^2
mToFt = 3.28;           % conversion factor

% combining constants for the drag force calculation into one value
beta = 0.5*c_d*rho_air*pi()*r_rocket^2; 

% simulation parameters
delta_t = 0.01;         % s, can set different delta time steps
maxFrames = 10000;
launchPressure = input("What was the gauge launch pressure in psi? ")*psiToPa; % converted to Pa
launchVolume = input("What was the initial volume of water in mL? ")*10^(-6); % converted to m^3
initAirVolume = v_rocket - launchVolume;

% frame 1 (initial conditions) and setting up arrays
p = zeros(maxFrames, 1);
p(1) = launchPressure + p_atm; % start pressure array with p(1) = initial total pressure
m = zeros(maxFrames, 1);
m(1) = m_rocket + launchVolume * rho_water; % start mass array with m(1) = initial total mass
m_dot = zeros(maxFrames, 1);
m_dot(1) = -pi()*r_nozzle^2*rho_water*sqrt(2*launchPressure/rho_water);
T = zeros(maxFrames, 1);
T(1) = 2*pi()*r_nozzle^2*launchPressure; % start thrust force array with T(1) = initial thrust force
v = zeros(maxFrames, 1);    % start velocity array with v(1) = 0 m/s
u = zeros(maxFrames, 1);    % start exhaust velocity array with u(1) = 0 m/s
h = zeros(maxFrames, 1);    % start height array with h(1) = 0 m
time = zeros(maxFrames, 1); % start time array with time(1) = 0 s

% looping calculations
i = 1; % index
while(h(i) >= 0 && i < maxFrames)
    time(i+1) = time(i) + delta_t;
    p(i+1) = p(1)*((initAirVolume + (m(1) - m(i))/rho_water)/initAirVolume)^(-gamma);
    u(i+1) = sqrt(2*(p(i)-p_atm)/(rho_water*(1-(r_nozzle/r_rocket)^4))); % (A_nozzle/A_rocket)^2 = (r_nozzle/r_rocket)^4
    if(m(i) >= m_rocket)
        m_dot(i+1) = -rho_water*pi()*r_nozzle^2*u(i);
        T(i+1) = -m_dot(i)*u(i+1)+pi()*r_nozzle^2*(p(i)-p_atm);
        v(i+1) = v(i) + (T(i)/m(i) - g - (beta*v(i)*abs(v(i)))/m(i))*delta_t;
        h(i+1) = h(i) + v(i)*delta_t;
        m(i+1) = m(i) + m_dot(i)*delta_t;
    else
        v(i+1) = v(i) + (-g -(beta*v(i)*abs(v(i)))/m_rocket)*delta_t;
        h(i+1) = h(i) + v(i)*delta_t;
        m(i+1) = m(i);
    end
    i = i + 1;
end

h(i) = 0; %forcing the final height to be non-negative to keep the y-axis non-negative when plotted

%Plotting the height of the rocket as a function of time
plot(time(1:i), mToFt*h(1:i)); 
xlabel("Time [s]");
ylabel("Height [ft]");
title("Max Height: " + num2str(mToFt*max(h)) + " ft; Thrust Duration: " + num2str(find(T == 0, 1)*delta_t) + " s; Max Thrust: " + num2str(max(T)*0.2248) + " lbs");
