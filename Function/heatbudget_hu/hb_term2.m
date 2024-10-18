function  [term2_u,term2_v,lon,lat] = hb_term2(lon_read,lat_read,depth_read,temp_tp,uvel_tp,vvel_tp,mld_tp,temp_exp,uvel_exp,vvel_exp,mld_exp,lon_box,lat_box,dx,dy)
% [term2_u,term2_v,lon,lat] = hb_term2(lon_read,lat_read,depth_read,temp_tp,uvel_tp,vvel_tp,mld_tp,temp_exp,uvel_exp,vvel_exp,mld_exp,lon_box,lat_box,dx,dy)
% Version 1.0 (beta)
% Calculate the second right hand of the mixed layer heat budget near equator or small region.
% This term is unually named the horizontal advection term.
% Here, I do not take into account the change in zonal distance with latitude.
% This issue will be addressed in a future release.
%
%   Inputs:
%      lon_read      - longitude, 1°¡m. The lon_read must be eastward,ascending and equispaced.
%      lat_read      - latitude, 1°¡n. The lat_read must be northward and ascending and equispaced.
%      depth_read    - depth, 1°¡q. The depth_read must be downward and ascending and equispaced.Unit is m;
%      temp_tp   - the reference potential temperature data (e.g. climatological),
%                       m°¡n°¡q°¡p, lon°¡lat°¡detph°¡time. Unit is °„C.
%      uvel_tp   - the reference zonal ocean current velocity data (e.g. climatological),
%                       m°¡n°¡q°¡p, lon°¡lat°¡detph°¡time. Unit is m/s, m/day or m/month, depends on the temperature data.
%      vvel_tp   - the reference merional ocean current velocity data (e.g. climatological),
%                       m°¡n°¡q°¡p, lon°¡lat°¡detph°¡time. Unit is m/s, m/day or m/month, depends on the temperature data.
%      mld_tp    - the reference mixed layer depth data (e.g. climatological),
%                       m°¡n°¡p (lon°¡lat°¡time), or m°¡n or just a number. Unit is m.
%
%      temp_exp   - the original potential temperature data, same as temp_tp.
%      uvel_exp   - the original zonal ocean current velocity data, same as uvel_tp.
%      vvel_exp   - the original merional ocean current velocity data, same as vvel_tp.
%
%      mld_exp    - the original mixed layer depth data, same as mld_tp.
%      lon_box    - the longitude boundary of the analyze region,1°¡2, e.g.,[360-170,360-120];
%      lat_box    - the latitude boundary of the analuze region,1°¡2,e.g.,[-5,5];
%      dx         - the distance of one longitude interval.
%      dy         - the distance of one latitude interval.
%
%   The last five data are optional. If mld_exp is empty, mld_exp = mld_tp.
%   If lon_box and lat_box are empty, the whole region will be calculated.
%   If dx and dy are empty, them will be calculated by the lon_read and lat_read, respectively.
%
%   Outputs:
%      term2_u      - the zonal advection term.
%      term2_v      - the merional advection term.
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
if nargin < 10
    error('Needs more than 9 datasets');
end
if nargin < 15
    dy = distance(lat_read(1),0,lat_read(2),0)*2*pi*6.3781e6/360;
end
if nargin < 14
    dx = distance(0,lon_read(1),0,lon_read(2))*2*pi*6.3781e6/360;
end
if nargin < 13
    lat_box = [min(lat_read),max(lat_read)];
end
if nargin < 12
    lon_box = [min(lon_read),max(lon_read)];
end
if nargin < 11
    mld_exp = mld_tp;
end

if ~isequal(size(temp_tp), size(temp_exp))
    error('The two temp matrix dimensions must be the same');
elseif ~isequal(size(uvel_tp), size(uvel_exp))
    error('The two uvel matrix dimensions must be the same');
elseif ~isequal(size(vvel_tp), size(vvel_exp))
    error('The two vvel matrix dimensions must be the same');
elseif ~isequal(size(temp_tp), size(uvel_tp))
    error('The temp and uvel matrix dimensions must be the same');
elseif ~isequal(size(temp_tp), size(vvel_tp))
    error('The temp and vvel matrix dimensions must be the same');
elseif length(lon_read) ~= size(temp_tp, 1) || length(lat_read) ~= size(temp_tp, 2)
    error('The grid and matrix dimensions must be the same');
end
%% set MLD
if ndims(mld_tp) > 3
    error('The MLD dimensions must be less than three');
elseif isscalar(mld_tp) % a number
    mld_tp = zeros(size(temp_tp,1),size(temp_tp,2),size(temp_tp,4)) + mld_tp;
elseif ismatrix(mld_tp) && ~isscalar(mld_tp) && ~isvector(mld_tp) % 2D matrix
    bin1 = zeros(size(temp_tp,1),size(temp_tp,2),size(temp_tp,4));
    for i1 = 1:size(bin1,3)
        bin1(:,:,i1) = mld_tp;
    end
    mld_tp = bin1;
    clear bin1
end

if ndims(mld_exp) > 3
    error('The MLD dimensions must be less than three');
elseif isscalar(mld_exp) % a number
    mld_exp = zeros(size(temp_exp,1),size(temp_exp,2),size(temp_exp,4)) + mld_exp;
elseif ismatrix(mld_exp) && ~isscalar(mld_exp) && ~isvector(mld_exp) % 2D matrix
    bin1 = zeros(size(temp_exp,1),size(temp_exp,2),size(temp_exp,4));
    for i1 = 1:size(bin1,3)
        bin1(:,:,i1) = mld_exp;
    end
    mld_exp = bin1;
    clear bin1
end
%% check MLD dimension
if ~isequal(size(mld_tp), [size(temp_tp,1),size(temp_tp,2),size(temp_tp,4)]) || ~isequal(size(mld_exp), [size(temp_exp,1),size(temp_exp,2),size(temp_exp,4)])
    error('The MLD size should be the same as temp data');
end
%% calculation
lon_x = lon_read(1:end-1);
uvel_tp_xy = uvel_tp(1:end-1,1:end-1,:,:);
uvel_exp_xy = uvel_exp(1:end-1,1:end-1,:,:);
dTdx_tp = (temp_tp(2:end,1:end-1,:,:) - temp_tp(1:end-1,1:end-1,:,:))/dx;
dTdx_exp = (temp_exp(2:end,1:end-1,:,:) - temp_exp(1:end-1,1:end-1,:,:))/dx;

lat_y = lat_read(1:end-1);
vvel_tp_xy = vvel_tp(1:end-1,1:end-1,:,:);
vvel_exp_xy = vvel_exp(1:end-1,1:end-1,:,:);
dTdy_tp = (temp_tp(1:end-1,2:end,:,:) - temp_tp(1:end-1,1:end-1,:,:))/dy;
dTdy_exp = (temp_exp(1:end-1,2:end,:,:) - temp_exp(1:end-1,1:end-1,:,:))/dy;

mld_tp_xy = mld_tp(1:end-1,1:end-1,:);
mld_exp_xy = mld_exp(1:end-1,1:end-1,:);
%%
l_lon = lon_x >= lon_box(1) & lon_x <= lon_box(2);
l_lat = lat_y >= lat_box(1) & lat_y <= lat_box(2);

lon = lon_x(l_lon);
lat = lat_y(l_lat);

bin_mld_tp = mld_tp_xy(l_lon,l_lat,:);
bin_mld_exp = mld_exp_xy(l_lon,l_lat,:);

bin_term2_u_tp = uvel_tp_xy(l_lon,l_lat,:,:).*dTdx_tp(l_lon,l_lat,:,:);
bin_term2_u_exp = uvel_exp_xy(l_lon,l_lat,:,:).*dTdx_exp(l_lon,l_lat,:,:);
bin_term2_v_tp = vvel_tp_xy(l_lon,l_lat,:,:).*dTdy_tp(l_lon,l_lat,:,:);
bin_term2_v_exp = vvel_exp_xy(l_lon,l_lat,:,:).*dTdy_exp(l_lon,l_lat,:,:);

bin_term2_u = -bin_term2_u_exp + bin_term2_u_tp;
bin_term2_v = -bin_term2_v_exp + bin_term2_v_tp;
%%
mld_tp = squeeze(mean(mean(bin_mld_tp,1),2));
mld_exp = squeeze(mean(mean(bin_mld_exp,1),2));

clear term2_u term2_v
for i1 = 1:size(bin_term2_u,4)
    d1 = depth_read <= min(mld_exp(i1),mld_tp(i1));
    term2_u(i1) = squeeze(mean(mean(mean(bin_term2_u(:,:,d1,i1),1),2),3));
    term2_v(i1) = squeeze(mean(mean(mean(bin_term2_v(:,:,d1,i1),1),2),3));
end
end
