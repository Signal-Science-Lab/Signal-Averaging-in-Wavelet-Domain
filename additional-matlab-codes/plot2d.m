function f = plot2d(scan, varagin)
%   PLOT2D(SCAN, VARAGIN) plots the original data and approximated data for
%   each wave name in VARAGIN. VARAGIN must be a cell of wavelet names as
%   strings (available by typing 'wavemnger('read', 1)' into MATLAB). 
    
    %Normalizing the data with the average of the first 100 points.  
    inputsize = size(scan);
    input1d = mean(scan'); 
    first100avg = mean(input1d(1, [1:100]));
    input1d = (input1d - first100avg);
    peak = max(abs(input1d));
    input1d = input1d / peak; 

    %Finding the 1 dimensional approximation of the input data and plotting
    %the both the approximation and the original data. 
    approx = signalavg1d(scan, varagin); 
    errortable = [];
    for i=1:length(varagin)
        errortransform = 0;
        normalized_approx = (approx(i, :) - first100avg)/peak;
         errortransform = rms(input1d - normalized_approx);
        errortransform = round(errortransform, 6);
        errortable = [errortable, errortransform];
        
        figure('Name', char(varagin(i)));
        plot(normalized_approx, 'Color', 'r'); set(gca, 'FontSize', 20); axis tight; hold on;
        plot([1:inputsize(1)], input1d, 'Color', 'b'); set(gca, 'FontSize', 20); axis tight;
        txt = ['Error = ', num2str(errortable(i))];
        legend([char(varagin(i)),' Transform'], txt) 
    end

    figure('Name', 'mean');
    plot(input1d, 'Color', 'b'); set(gca, 'FontSize', 20); axis tight; hold on;
    
    f = errortable;
end
