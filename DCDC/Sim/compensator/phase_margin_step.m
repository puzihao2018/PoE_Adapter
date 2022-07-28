clear

%--------------- bode plot settings ----------------------
options = bodeoptions
options.FreqUnits = 'Hz'
%---------------------------------------------------------
vinList = [32, 40, 48, 56, 68]
ioutlist = [0.5, 1, 1.5, 2, 2.5, 3]
voutList = [5, 9, 12, 20]
getMargins(vinList, ioutlist, voutList)


function getMargins(vinList, ioutlist, voutList)
fignum = 0
for i = 1 : length(vinList)
    for j = 1 : length(ioutlist)
        for k = 1 : length(voutList)
    %--------------- power stage parameters ------------------
    fignum = fignum + 1
    Vin = vinList(i)
    Vout = voutList(k)
    L = 47e-6
    C = 330e-6
    rc = 20e-3
    rl = 0.0335
    R = Vout / ioutlist(j)
    Ri = 0.022
    Fsw = 500e3
    Tsw = 1/Fsw
    D_ = 1 - Vout/Vin
    D = Vout/Vin
    S1 = (Vin - Vout) / L
    S2 = Vout / L
    A = 10
    %----------------------------------------------------------

    %---------------- lm5116 ramp calculation -----------------
    Ir = 5e-6*(Vin - Vout) + 25e-6
    Cr = 680e-12
    Rr = 178e3
    Vcc = 7.4
    gm = 5e-6
    Ios = Vcc / Rr + 25e-6
    %----------------------------------------------------------
    %---------------- power stage transfer function -----------
    s = tf('s')

    Ksl = gm * Tsw / Cr
    Vsl = Ios * Tsw / Cr
    Km = 1 / ((D - 0.5) * A * Ri * Tsw / L + (1 - 2 * D) * Ksl + Vsl / Vin)
    wz = 1/(rc*C)
    wp = 1/(R*C) + 1 / (Km * A * Ri * C)
    wn = pi * Fsw
    Se = ((Vin - Vout) * Ksl + Vsl)/Tsw
    Sn = Vout * A * Ri / L
    mc = Se / Sn
    Q = 1 / (pi * (mc - 0.5))

    Fp = (1 + s/wz) / (1 + s/wp) % 1p1z function

    Fh = 1 / (1 + s / (wn * Q) + s^2/(wn^2)) % second order function

    K = R / (Ri*A) * 1 / (1 + R/(Km * A * Ri)) % DC gain

    Gps = K * Fp * Fh 

    %----------------------------------------------------------

    %--------------- feedback compensator (type II) ------------
    C1 = 800e-12
    C2 = 100e-12
    R2 = 230e3
    R1 = 178e3
    Hcomp = (1+s*R2*C1)/(s*R1*(C1+C2)*(1+s*R2*C1*C2/(C1+C2)))
    
    
    figure(fignum)
    margin( Hcomp * Gps)
    title(['Vin = ' num2str(Vin,'%02d') 'V ' 'Vout = ' num2str(Vout,'%02d') 'V ' 'Iout = ' num2str(ioutlist(j),'%02d') 'A'])
        end
    end
end
end
