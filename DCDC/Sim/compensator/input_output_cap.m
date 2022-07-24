clear
%input cap calculation
Iout = 3.2      % output current
D = 0.5         % Dutycycle that results in highest Cin
Vin_pp = 0.05   % peak-to-peak input voltage
Fsw = 500e3
Cin = D * (1-D) * Iout / (Vin_pp * Fsw)

%bulk cap calculation

%bulk esr

Vin = 48
Vout = 20
eta = 0.9
Vin_tran = 0.5 % voltage drop due to output current step-up
Istep = 3 %output current step-up
Dmax = Vout/ Vin / eta
esr_max = Vin_tran / (Istep * Dmax) % maximum esr
Trise = 50e-6 %current rise time, s

Tol = 0.2 %tolerance fraction

%bulk capacitance:
Cb_min = 0.5 * Istep * Dmax * Trise / Vin_tran - Cin * (1 - Tol)

%out cap (os)
Vout_min = 5
L = 22e-3
Vos = 0.1
Cout = (Istep ^ 2) * L / (2 * Vout_min * Vos)

