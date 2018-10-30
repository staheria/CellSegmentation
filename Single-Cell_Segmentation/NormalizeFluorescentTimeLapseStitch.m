function I2 = NormalizeFluorescentTimeLapseStitch(I, n)
    
    height = (size(I,1)-1)/n;
    
    for i=1:n
        Y = ((i-1)*height:(i*height))+1;
        Temp = sort(I(Y,:));
        BackIntensity(i) = mean(mean( Temp(1:round(height/4),:) ));
    end
    
    BackIntensity = BackIntensity-min(BackIntensity);
    I2 = I;
    
    for i=1:n
        Y = ((i-1)*height:(i*height))+1;
        I2(Y,:) = I2(Y,:)-BackIntensity(i);
    end
   
end
