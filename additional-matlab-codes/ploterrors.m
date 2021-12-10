function ploterrors(scan, varagin)
%    PLOTERRORS(SCAN, VARAGIN) plots the error between the 
%    original data as a 1 dimensional vector and approximated data for each 
%    wave name in VARAGIN. VARAGIN must be a cell of wavelet names as 
%    strings (available by typing 'wavemngr('read',1)' into MATLAB).  
    
    %Normalizing the data with the average of the first 100 points.  
    inputsize = size(scan);
    input1d = mean(scan'); 
    first100avg = mean(input1d(1, [1:100]));
    input1d = (input1d - first100avg);
    peak = max(abs(input1d));
    input1d = input1d / peak; 
    
    %Finding the 1 dimensional approximation of the input data and plotting
    %the difference between the normalized approximation and the normalized
    %data. 
    approx = signalavg1d(scan, varagin); 
    for i=1:length(varagin)
        normalized_approx = (approx(i, :) - first100avg) / peak;
        errortransform = input1d - approx(i, :);
        figure('Name', char(varagin(i)));
        plot([1:1024], errortransform, 'Color', 'black'); set(gca, 'FontSize', 20); axis tight;
        ylim([-1 1])
    end
        
end