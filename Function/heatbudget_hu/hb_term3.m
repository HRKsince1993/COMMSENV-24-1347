function  [term3,lon,lat] = hb_term3(lon_read,lat_read,temp_above_tp,temp_mld_tp,wvel_mld_tp,uvel_mld_tp,vvel_mld_tp,mld_tp,temp_above_exp,temp_mld_exp,wvel_mld_exp,uvel_mld_exp,vvel_mld_exp,mld_exp,lon_box,lat_box,three,dx,dy)
% [term3,lon,lat] = hb_term3(lon_read,lat_read,temp_tp,temp_mld_tp,wvel_mld_tp,uvel_mld_tp,vvel_mld_tp,mld_tp,temp_exp,temp_mld_exp,wvel_mld_exp,uvel_mld_exp,vvel_mld_exp,mld_exp,lon_box,lat_box,three,dx,dy)
% Version 1.0 (beta)
% Calculate the third right hand of the mixed layer heat budget near equator or small region.
% This term is unually named the vertical advection term.
% Here, I do not take into account the change in zonal distance with latitude.
% This issue will be addressed in a future release.
% 
%   Inputs:
%      lon_read      - longitude, 1×m. The lon_read must be eastward,ascending and equispaced.
%      lat_read      - latitude, 1×n. The lat_read must be northward and ascending and equispaced.
%      temp_above_tp - the reference mean potential temperature above mixed layer depth (e.g. climatological),
%                       m×n×p, lon×lat×time. Unit is °C.
%      temp_mld_tp   - the reference potential temperature 5m below mixed layer depth (e.g. climatological),
%                       m×n×p, lon×lat×time. Unit is °C.
%      wvel_mld_tp   - the reference vertical ocean current velocity at mixed layer depth (e.g. climatological),
%                       m×n×p, lon×lat×time. Unit is m/s, m/day or m/month, depends on the temperature data.
%                       Positive value is downward.
%      uvel_mld_tp   - the reference zonal ocean current velocity at mixed layer depth (e.g. climatological),
%                       m×n×p, lon×lat×time. Unit is m/s, m/day or m/month, depends on the temperature data.
%      vvel_mld_tp   - the reference merional ocean current velocity at mixed layer depth (e.g. climatological),
%                       m×n×p, lon×lat×time. Unit is m/s, m/day or m/month, depends on the temperature data.
%      mld_tp        - the reference mixed layer depth data (e.g. climatological),
%                       m×n×p (lon×lat×time), or m×n or just a number. Unit is m.
%
%      temp_above_exp  - the original mean potential temperature above mixed layer depth, same as temp_tp.
%      wvel_mld_exp    - the original vertical ocean current velocity at mixed layer depth, same as wvel_mld_tp.
%      uvel_mld_exp    - the original zonal ocean current velocity at mixed layer depth, same as uvel_mld_tp.
%      vvel_mld_exp    - the original merional ocean current velocity at mixed layer depth, same as vvel_mld_tp.
%
%      mld_exp    - the original mixed layer depth data, same as mld_tp.
%      lon_box    - the longitude boundary of the analyze region,1×2, e.g.,[360-170,360-120];
%      lat_box    - the latitude boundary of the analuze region,1×2,e.g.,[-5,5];
%      three      -  1:only enter the MLD(w>0) are condisered;2:do not consider enter or out (default: 1)        
%      dx         - the distance of one longitude interval.
%      dy         - the distance of one latitude interval.        
%
%   The last six data are optional. If mld_exp is empty, mld_exp = mld_tp.
%   If lon_box and lat_box are empty, the whole region will be calculated.
%   If dx and dy are empty, them will be calculated by the lon_read and lat_read, respectively.
%
%   Outputs:
%      term3      - the vertical advection term.
%      lon        - the longitude of the analyze region
%      lat        - the latitude of the analyze region
%
%   Author:
%      Ruikun Hu
%      Ph.D of physical oceanography
%      State Key Laboratory of Satellite Ocean Environment Dynamics,
%      Second Institute of Oceanography, Ministry of Natural Resources, Hangzhou, China
%      ruikunhu@sio.org.cn
%      28th, 08, 2024
%% check
if nargin < 13
    error('Needs more than 12 datasets');
end
if nargin < 19
    dy = distance(lat_read(1),0,lat_read(2),0)*2*pi*6.3781e6/360;
end
if nargin < 18
    dx = distance(0,lon_read(1),0,lon_read(2))*2*pi*6.3781e6/360;
end
if nargin < 17
    three = 1;
end
if nargin < 16
    lat_box = [min(lat_read),max(lat_read)];
end
if nargin < 15
    lon_box = [min(lon_read),max(lon_read)];
end
if nargin < 14
    mld_exp = mld_tp;
end

if three ~= 1 || three ~= 2
    error('Parameter three should be 1 or 2');
elseif ~isequal(size(temp_above_tp), size(temp_above_exp))
    error('The two temp matrix dimensions must be the same');
elseif ~isequal(size(temp_mld_tp), size(temp_mld_exp))
    error('The two temp at MLD matrix dimensions must be the same');
elseif ~isequal(size(wvel_mld_tp), size(wvel_mld_exp))
    error('The two wvel at MLD matrix dimensions must be the same');
elseif ~isequal(size(uvel_mld_tp), size(uvel_mld_exp))
    error('The two uvel at MLD matrix dimensions must be the same');
elseif ~isequal(size(vvel_mld_tp), size(vvel_mld_exp))
    error('The two vvel at MLD matrix dimensions must be the same');
elseif ~isequal(size(temp_mld_tp), size(wvel_mld_tp))
    error('The temp and wvel matrix dimensions must be the same');
elseif ~isequal(size(temp_mld_tp), size(uvel_mld_tp))
    error('The temp and uvel matrix dimensions must be the same');
elseif ~isequal(size(temp_mld_tp), size(vvel_mld_tp))
    error('The temp and vvel matrix dimensions must be the same');
elseif length(lon_read) ~= size(temp_above_tp, 1) || length(lat_read) ~= size(temp_above_tp, 2)
    error('The grid and matrix dimensions must be the same');
end
%% set MLD
if ndims(mld_tp) > 3
    error('The MLD dimensions must be less than three');
elseif isscalar(mld_tp) % a number
    mld_tp = zeros(size(temp_above_tp)) + mld_tp;
elseif ismatrix(mld_tp) && ~isscalar(mld_tp) && ~isvector(mld_tp) % 2D matrix
    bin1 = zeros(size(temp_above_tp));
    for i1 = 1:size(bin1,3)
        bin1(:,:,i1) = mld_tp;
    end
    mld_tp = bin1;
    clear bin1
end

if ndims(mld_exp) > 3
    error('The MLD dimensions must be less than three');
elseif isscalar(mld_exp) % a number
    mld_exp = zeros(size(temp_above_exp)) + mld_exp;
elseif ismatrix(mld_exp) && ~isscalar(mld_exp) && ~isvector(mld_exp) % 2D matrix
    bin1 = zeros(size(temp_above_exp));
    for i1 = 1:size(bin1,3)
        bin1(:,:,i1) = mld_exp;
    end
    mld_exp = bin1;
    clear bin1
end
%% check MLD dimension
if ~isequal(size(mld_tp), size(temp_above_tp)) || ~isequal(size(mld_exp), size(temp_above_exp))
    error('The MLD size should be the same as temp data');
end
%% calculation   
% entrainment velocity
    lon_x = lon_read(1:end-1);
    lat_y = lat_read(1:end-1);

    % TPctrl
    wvel_mld_tp2 = wvel_mld_tp(1:end-1,1:end-1,1:end-1);% wvel
    dzdt_mld_tp = mld_tp(1:end-1,1:end-1,2:end) - mld_tp(1:end-1,1:end-1,1:end-1);% dh/dt
    dhdx_mld_tp = (mld_tp(2:end,1:end-1,1:end-1) - mld_tp(1:end-1,1:end-1,1:end-1))./dx;% dh/dx
    bin_term_u_tp =  uvel_mld_tp(1:end-1,1:end-1,1:end-1).*dhdx_mld_tp;% u*dh/dx
    dhdy_mld_tp = (mld_tp(1:end-1,2:end,1:end-1) - mld_tp(1:end-1,1:end-1,1:end-1))./dy;% dh/dy
    bin_term_v_tp =  vvel_mld_tp(1:end-1,1:end-1,1:end-1).*dhdy_mld_tp;% v*dh/dy
    bin_evel_tp = wvel_mld_tp2 + dzdt_mld_tp + bin_term_u_tp + bin_term_v_tp;

    % Exp
    wvel_mld_exp2 = wvel_mld_exp(1:end-1,1:end-1,1:end-1);% wvel
    dzdt_mld_exp = mld_exp(1:end-1,1:end-1,2:end) - mld_exp(1:end-1,1:end-1,1:end-1);% dh/dt
    dhdx_mld_exp = (mld_exp(2:end,1:end-1,1:end-1) - mld_exp(1:end-1,1:end-1,1:end-1))./dx;% dh/dx
    bin_term_u_exp =  uvel_mld_exp(1:end-1,1:end-1,1:end-1).*dhdx_mld_exp;% u*dh/dx
    dhdy_mld_exp = (mld_exp(1:end-1,2:end,1:end-1) - mld_exp(1:end-1,1:end-1,1:end-1))./dy;% dh/dy
    bin_term_v_exp =  vvel_mld_exp(1:end-1,1:end-1,1:end-1).*dhdy_mld_exp;% v*dh/dy
    bin_evel_exp = wvel_mld_exp2 + dzdt_mld_exp + bin_term_u_exp + bin_term_v_exp;
    
    if three == 1;
        bin_evel_tp(bin_evel_tp < 0) = 0;% 只考虑卷入
        bin_evel_exp(bin_evel_exp < 0) = 0;% 只考虑卷入
    end
    %% dT/H
    % TPCtrl
    dT_tp = temp_above_tp(1:end-1,1:end-1,1:end-1) - temp_mld_tp(1:end-1,1:end-1,1:end-1); 
    dTdH_tp = dT_tp./mld_tp(1:end-1,1:end-1,1:end-1);
    % Exp
    dT_exp = temp_above_exp(1:end-1,1:end-1,1:end-1) - temp_mld_exp(1:end-1,1:end-1,1:end-1);
    dTdH_exp = dT_exp./mld_exp(1:end-1,1:end-1,1:end-1);
    %%
    l_lon = lon_x >= lon_box(1) & lon_x <= lon_box(2);
    l_lat = lat_y >= lat_box(1) & lat_y <= lat_box(2);

    lon = lon_x(l_lon);
    lat = lat_y(l_lat);

    bin_term3_tp = -bin_evel_tp.*dTdH_tp;
    bin_term3_exp = -bin_evel_exp.*dTdH_exp;

    term3_tp = squeeze(mean(mean(bin_term3_tp(l_lon,l_lat,:),1),2));
    term3_exp = squeeze(mean(mean(bin_term3_exp(l_lon,l_lat,:),1),2));

    term3 = term3_exp - term3_tp;
end