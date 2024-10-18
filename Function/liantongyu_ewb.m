function tauxa_ewb = liantongyu_ewb(tauxa,yu_taux,yu_taux2)
% compute the eastern wind burst region
% tauxa is the zonal wind speed or zonal wind stress anomalies, must be
% 3D(e.g. lon*lat*time). The last dimensionality must be time.
% yu_taux is the wind burst threshold value. The default is 0.05N/m2.
% yu_taux2 is the threshold of the omitted values. The default is 0.001N/m2.

%   Author:
%      Ruikun Hu
%      Ph.D of physical oceanography
%      State Key Laboratory of Satellite Ocean Environment Dynamics, 
%      Second Institute of Oceanography, Ministry of Natural Resources, Hangzhou, China
%      ruikunhu@sio.org.cn
%      27th, 04, 2024
%%
if nargin < 1
    error(message('stats:regress:TooFewInputs'));
elseif nargin == 1
    yu_taux = 0.05;
    yu_taux2 = 0.001;
elseif nargin == 2
    yu_taux2 = 0.001;
elseif nargin > 2
    error(message('stats:regress:TooManyInputs'));
end

if size(tauxa,4) > 1
    error(message('The wind data must be 3D'));
end

tauxa = -tauxa;
tauxa_ewb = zeros(size(tauxa));
for i1 = 1:size(tauxa,3)
    region_taux = tauxa(:,:,i1);

    uvel_wwb = region_taux;
    uvel_wwv = region_taux;
    uvel_wwb(uvel_wwb < yu_taux) = nan;
    uvel_wwv(uvel_wwv <= yu_taux2) = nan;

    [x_n,y_n] = find(~isnan(uvel_wwb));

    if isempty(x_n) || isempty(y_n)
        continue
    else
        bin4 = uvel_wwv;
        bin4(bin4>=0) = 1;
        bin4(isnan(bin4)) = 0;
        bin5 = bwlabel(bin4);

        clear bin_region_p
        for i2 = 1:length(x_n)
            [x0,y0] = find(uvel_wwb == uvel_wwb(x_n(i2),y_n(i2)));
            bin_region_p(:,:,i2) = double(bin5 == bin5(x0,y0));
        end
        bin_region_p2 = mean(bin_region_p,3);
        bin_region_p2(bin_region_p2>0) = 1;
        region_p = bin_region_p2;

        tauxa_ewb(:,:,i1) = -region_taux.*region_p;
    end
end
end