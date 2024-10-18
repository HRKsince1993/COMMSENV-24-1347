function dx=dx_atmos_walker(longitude)
    R=6.3781e6; % earth's radius
    [dx, ~]=gradient(longitude);
    dx=dx.*(pi./180).*R;
end