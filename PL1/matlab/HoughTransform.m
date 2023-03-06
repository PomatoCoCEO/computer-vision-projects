function [H, rhoScale, thetaScale] = HoughTransform(Im, threshold, rhoRes, thetaRes)
    % assuming that the resolution is given by radians in thetaRes and by units of length in rhoRes
    % im is the edge magnitude scale

    % acc_mode, 'gradient-based'
    height = size(Im,1);
    width = size(Im, 2);
    rhoMax = sqrt(width ^2 + height ^ 2);
    thetaMax = 2*pi;
    noBinsRho = floor(rhoMax / rhoRes);
    noBinsTheta = floor(thetaMax / thetaRes);
    H = zeros(noBinsRho, noBinsTheta);
    
    realThetaInterval = thetaMax / noBinsTheta;
    realRhoInterval = rhoMax / noBinsRho;

    rhoScale = (realRhoInterval / 2) : (realRhoInterval) : (rhoMax - realRhoInterval/2);
    thetaScale = (realThetaInterval / 2) : realThetaInterval : (thetaMax - realThetaInterval/2);
    % if strcmp(acc_mode, 'gradient-based')
    %     disp('gradient-based increment hough transform');
    % elseif strcmp(acc_mode, 'incrementation-based')
    %     disp('unitary increment hough transform');
    % end
      
    for i = 1:height
        for j = 1:width
            if Im(i,j) >= threshold
                for thetaPos = 1 : noBinsTheta
                    theta = thetaScale(1,thetaPos);
                    rho = i * sin(theta) + j * cos(theta);
                    if rho >= 0
                        rhoPos = floor((rho) / realRhoInterval) + 1;
                        % if strcmp(acc_mode, 'gradient-based')
                        %     H(rhoPos, thetaPos) = H(rhoPos, thetaPos) + Im(i, j);
                        % elseif strcmp(acc_mode, 'incrementation-based')
                        H(rhoPos, thetaPos) = H(rhoPos, thetaPos) + 1;
                        % end
                    end
                end
            end
        end
    end
    
end
        
        