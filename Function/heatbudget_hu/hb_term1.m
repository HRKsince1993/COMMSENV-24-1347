function [term1,lon,lat]= hb_term1(lon_read,lat_read,heatflux_tp,heatflux_exp,mld_tp,mld_exp,lon_box,lat_box,s_d,c_p)
% [term1,lon,lat] = heatbudget_term0(lon_read,lat_read,temp_tp,temp_exp,lon_box,lat_box)
% Version 1.0 (beta)
% Calculate the first right hand of the mixed layer heat budget near equator or small region. 
% This term is unually named the net heat flux term.
% Here, I do not take into account the change in zonal distance with latitude.
% This issue will be addressed in a future release.
% 
%   Inputs:
%      lon_read      - longitude, 1¡Ám. The lon_read must be eastward,ascending and equispaced.
%      lat_read      - latitude, 1¡Án. The lat_read must be northward and ascending and equispaced.
%      heatflux_tp   - the reference heat flux data (e.g. climatological),
%                       m¡Án¡Áp, lon¡Álat¡Átime. Unit is w/m2 or J/month/m2.
%                       Positive value means ocean loss heat.
%      heatflux_exp  - the original heat flux data, same as heatflux_tp.
%      mld_tp        - the reference mixed layer depth, m¡Án¡Áp or m¡Án or just a number
% 
%      mld_exp    - the original mixed layer depth, same as mld_tp
%      lon_box    - the longitude boundary of the analyze region,1¡Á2, e.g.,[360-170,360-120];
%      lat_box    - the latitude boundary of the analuze region,1¡Á2,e.g.,[-5,5];
%      s_d        - the seawater density (default: 1025 kg/m3)
%      c_p        - the specific heat of seawater at constant pressure (default: 3940 J/kg/K)
%   The last five data are optional. If mld_exp is empty, mld_exp = mld_tp. 
%   If lon_box and lat_box are empty, the whole region will be calculated.
%   The land grid values of the heat flux or MLD fields must be NaN;
%
%   Outputs:
%      term1      - the result 
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
if nargin < 5
    error('Needs more than five dataset');
end
if nargin < 10
    c_p = 1025;
end
if nargin < 9
    s_d = 3940;
end
if nargin < 8
    lat_box = [min(lat_read),max(lat_read)];
end
if nargin < 7
     lon_box = [min(lon_read),max(lon_read)];
end
if nargin < 7
     mld_exp = mld_tp;
end

if ~isequal(size(heatflux_tp), size(heatflux_exp))
    error('The matrix dimensions must be the same');
elseif length(lon_read) ~= size(heatflux_tp, 1) || length(lat_read) ~= size(heatflux_tp, 2)
    error('The grid and matrix dimensions must be the same');
end
%% set MLD
if ndims(mld_tp) > 3
    error('The MLD dimensions must be less than three');
elseif isscalar(mld_tp) % a number 
    mld_tp = zeros(size(heatflux_tp)) + mld_tp;
elseif ismatrix(mld_tp) && ~isscalar(mld_tp) && ~isvector(mld_tp) % 2D matrix
    bin1 = zeros(size(heatflux_tp));
    for i1 = 1:size(bin1,3)
        bin1(:,:,i1) = mld_tp;
    end
    mld_tp = bin1;
    clear bin1
end

if ndims(mld_exp) > 3
    error('The MLD dimensions must be less than three');
elseif isscalar(mld_exp) % a number 
    mld_exp = zeros(size(heatflux_exp)) + mld_exp;
elseif ismatrix(mld_exp) && ~isscalar(mld_exp) && ~isvector(mld_exp) % 2D matrix
    bin1 = zeros(size(heatflux_exp));
    for i1 = 1:size(bin1,3)
        bin1(:,:,i1) = mld_exp;
    end
    mld_exp = bin1;
    clear bin1
end
%% check MLD dimension
if ~isequal(size(mld_tp), size(heatflux_tp)) || ~isequal(size(mld_exp), size(heatflux_exp))
    error('The MLD size should be the same as heat flux data');
end
%% calculation
l_lon = lon_read >= lon_box(1) & lon_read <= lon_box(2);
l_lat = lat_read >= lat_box(1) & lat_read <= lat_box(2);

lon = lon_read(l_lon);
lat = lat_read(l_lat);

% TPCtrl
bin1_tp = heatflux_tp(l_lon,l_lat,:)./(mld_tp(l_lon,l_lat,:)*s_d*c_p);% ¡ãC/month
% Exp
bin1_exp = heatflux_exp(l_lon,l_lat,:)./(mld_exp(l_lon,l_lat,:)*s_d*c_p);% ¡ãC/month
term1 = squeeze(mean(mean(bin1_exp - bin1_tp,1),2));
end