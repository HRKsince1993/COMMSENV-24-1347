function curlz=curlz_atmos_walker(longitude, latitude, u, v)
    R=6.3781e6; % earth's radius
    dx=dx_atmos_walker(longitude);
    dy=dy_atmos_walker(latitude);
    [~, du]=gradient(u);
    [dv, ~]=gradient(v);
    curlz=dv./dx-du./dy;
end