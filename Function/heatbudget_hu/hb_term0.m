function [term0,lon,lat] = hb_term0(lon_read,lat_read,temp_tp,temp_exp,lon_box,lat_box)
% [term0,lon,lat] = heatbudget_term0(lon_read,lat_read,temp_tp,temp_exp,lon_box,lat_box)
% Version 1.0 (beta)
% Calculate the left hand of the mixed layer heat budget near equator or small region. 
% Here, I do not take into account the change in zonal distance with latitude.
% This issue will be addressed in a future release.
% 
%   Inputs:
%      lon_read   - longitude, 1¡Ám. The lon_read must be eastward,ascending and equispaced.
%      lat_read   - latitude, 1¡Án. The lat_read must be northward and ascending and equispaced.
%      temp_tp    - the reference mixed layer temperature data (e.g. climatological), m¡Án¡Áp, lon¡Álat¡Átime
%      temp_exp   - the original mixed layer temperature data, m¡Án¡Áp, lon¡Álat¡Átime
%      lon_box    - the longitude boundary of the analyze region,1¡Á2, e.g.,[360-170,360-120];
%      lat_box    - the latitude boundary of the analuze region,1¡Á2,e.g.,[-5,5];
%   The lon_box and lat_box are optional. If they are empty, the whole region will be calculated.        
%   
%   Outputs:
%      term0      - the result 
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
if nargin < 4
    error('Needs more than four dataset');
end
if nargin < 6
    lat_box = [min(lat_read),max(lat_read)];
end
if nargin < 5
    lon_box = [min(lon_read),max(lon_read)];
end

if ~isequal(size(temp_tp), size(temp_exp))
    error('The matrix dimensions must be the same');
elseif length(lon_read) ~= size(temp_tp, 1) || length(lat_read) ~= size(temp_tp, 2)
    error('The grid and matrix dimensions must be the same');
end

if ndims(temp_tp) > 3
    error('The temp data must be lon¡Álat¡Átime');
end
%% calculation
tempa = temp_exp - temp_tp;
tempa_dt = tempa(:,:,2:end) - tempa(:,:,1:end-1);

l_lon = lon_read >= lon_box(1) & lon_read <= lon_box(2);
l_lat = lat_read >= lat_box(1) & lat_read <= lat_box(2);

lon = lon_read(l_lon);
lat = lat_read(l_lat);

term0 = squeeze(nanmean(nanmean(tempa_dt(l_lon,l_lat,:),1),2));
end