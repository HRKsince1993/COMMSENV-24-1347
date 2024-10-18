function [taux,tauy]=cal_windstrss(u10m,v10m)

% taux = Cd(V)﹞老﹞k﹞(u10-u0)﹞V;
% tauy = Cd(V)﹞老﹞k﹞(v10-v0)﹞V;
% Here 老 is the surface air density, u10 and v10 are the zonal and meridional 
% wind speeds at 10 m, and u0 and v0 are the zonal and meridional components of 
% surface ocean current velocity, respectively. Also, V is the relative wind 
% speed defined as V=max{0.5,[(u10-u0)^2+(v10-v0)^2]^(1/2)}, and k is a function of stability, 
% which is very close to 1.0 in most of the tropical Pacific; 
% Cd is the neutral drag coefficient at 10m defined as Cd(V)=0.0027/V+0.000142+0.0000764V. 
% By assuming u0=v0=0, k=1, and 老=1.25 kg/m^3, we can roughly estimate the wind stress of NCEP2 using Eqs. (1) and (2).

% ref LIAN, T., and D. CHEN, 2021: The essential role of early-spring westerly wind bursts in generating the centennial
% extreme 1997/98 el ni?o. J. Clim., 34, 83778388, https://doi.org/10.1175/JCLI-D-21-0010.1.

v_abs = sqrt((u10m.*u10m) + (v10m.*v10m));
v_abs(v_abs < 0.5) = 0.5;

cd_v = 0.0027./v_abs + 0.000142 + 0.0000764*v_abs;
taux = cd_v.*u10m.*v_abs*1.25;
tauy = cd_v.*v10m.*v_abs*1.25;

end%