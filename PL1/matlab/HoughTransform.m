function [H, rhoScale, thetaScale] = HoughTransform(Im, threshold, rhoRes, thetaRes)
    % assuming that the resolution is given by radians in thetaRes and by units of length in rhoRes
    % im is the edge magnitude scale
    height = size(Im,1);
    width = size(Im, 2);
    rhoMax = sqrt(width ^2 + height ^ 2);
    thetaMax = pi;
    noBinsRho = floor(2*rhoMax / rhoRes);
    noBinsTheta = floor(thetaMax / thetaRes);
    H = zeros(noBinsRho, noBinsTheta);
    
    realThetaInterval = thetaMax / noBinsTheta;
    realRhoInterval = 2*rhoMax / noBinsRho;

    rhoScale = (-rhoMax + realRhoInterval / 2) : (realRhoInterval) : (rhoMax - realRhoInterval/2);
    thetaScale = (realThetaInterval / 2) : realThetaInterval : (thetaMax - realThetaInterval/2);
    disp(rhoScale(end))
    disp(thetaScale(end) * 180 / pi)

    for i = 1:height
        for j = 1:width
            if Im(i,j) >= threshold
                for thetaPos = 1 : noBinsTheta
                    theta = thetaScale(1,thetaPos);
                    rho = i * sin(theta) + j * cos(theta);

                    rhoPos = floor((rho + rhoMax) / realRhoInterval) + 1;
                    H(rhoPos, thetaPos) = H(rhoPos, thetaPos) +1;
                end
            end
        end
    end
    
end
        
        