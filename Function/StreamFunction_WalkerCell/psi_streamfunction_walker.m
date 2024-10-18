function [psi, Upsi, Vpsi]=psi_streamfunction_walker(longitude, latitude, u, v)
% ======================================================================= %
% Calculate stream function of a atmospheric flow pattern
% Input
%   longitude: Longitude, deg
%   latitude: Latitude, deg
%   u: Zonal Wind, m/s
%   v: Meditorial Wind, m/s
% Output
%   psi: Stream Function, m/s^-2
%   Upsi, Vpsi: Vorticity Wind component, m/s
% Note
%   More information about the arrangement of input data, or if you get ill
%   results (e.g. NaN or Inf value), see "check_input".
    MAX=3000; % maximum iteration (corresponding eps: 1e-7)
    epsilon=1e-5; % precision
    sor_index=0.2;
    [M, N]=size(longitude);
    psi=zeros([M N]); % initialization
    Res=ones([M N]).*-9999;
    curlz=curlz_atmos_walker(longitude, latitude, u, v);
    dx2=dx_atmos_walker(longitude).^2;
    dy2=dy_atmos_walker(latitude).^2;
    for k=1:MAX
        for i=2:M-1
            for j=2:N-1
                Res(i, j)=(psi(i+1, j)+psi(i-1, j)-2*psi(i, j))./dx2(i, j)+...
                          (psi(i, j+1)+psi(i, j-1)-2*psi(i, j))./dy2(i, j)-...
                           curlz(i, j);
                psi(i, j)=psi(i, j)+(1+sor_index)*Res(i, j)/(2/dx2(i, j)+2/dy2(i, j));
            end
        end
        if(max(max(Res))<epsilon)
            break % <----- Terminate the loop
        end
    end
    % vorticity wind
    [DpsiDx, DpsiDy]=grad_atmos_walker(longitude, latitude, psi);
    Upsi=-DpsiDy;
    Vpsi=DpsiDx;
    % make boundary NaN 
    psi(1, :)=NaN; Upsi(1, :)=NaN; Vpsi(1, :)=NaN;
    psi(M, :)=NaN; Upsi(M, :)=NaN; Vpsi(M, :)=NaN;
    psi(:, 1)=NaN; Upsi(:, 1)=NaN; Vpsi(:, 1)=NaN;
    psi(:, N)=NaN; Upsi(:, N)=NaN; Vpsi(:, N)=NaN;
end
