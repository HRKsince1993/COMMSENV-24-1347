function [grad_x, grad_y]=grad_atmos_walker(longitude, latitude, H)
    dx=dx_atmos_walker(longitude);
    dy=dy_atmos_walker(latitude);
    [grad_x, grad_y]=gradient(H);
    grad_x=grad_x./dx;
    grad_y=grad_y./dy;
end