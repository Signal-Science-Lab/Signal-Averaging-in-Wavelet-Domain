function sigavg = signalavg1d(scan, varagin)
% SIGNALAVG1D approximates data with a the haar wavelet. 
%
%   SIGNALAVG decomposes data given by 'scan' with the haar wavelet and 
%   creates a 1 dimensional reconstruction with the haar wavelet using the 
%   approximation coefficient and the zeroed detail coefficients, as in
%   SIGNALAVG. The data is decomposed and reconstructed at the maximum
%   decomposition level where each column of the given data is a separate
%   scan.

%Determining the size of the scan to be used while looping over data.
inputsize = size(scan);       

%Selecting the maximum decomposition level, the base 2 log of the number of
%columns. 
maxlevel = floor(log2(inputsize(2))); 

sigavg = [];
for k=1:length(varagin)
    %Approximating the data.
    data2d = [];
    for i=1:inputsize(1)
        %An approximation is created for each row of the data. 
        approximations = [];

        %Finding the haar wavelet decomposition of each row of the data at the
        %maximum decomposition level.
        [c, l] = wavedec(scan(i, :), maxlevel, char(varagin(k)));
        D = {};
        dcoef = [];

        %Zeroing the detail coefficients. 
        %For each level up to the maximum decomposition level, the detail
        %coefficients of the decomposition is selected, multiplied by 0, and
        %appended to D. The detail coefficients are found with MATLAB's
        %'detcoef'.
        for j=1:maxlevel
            D{j} = detcoef(c, l, j);
            D{j} = D{j} * 0;           
            dcoef = [D{j}, dcoef];
        end

        %Finding the approximation cefficient from the decomposition vector at
        %the maximum decomposition level with MATLAB's 'appcoef'.
        acoef = appcoef(c, l, char(varagin(k)), maxlevel);

        %Concatenating the approximation and detail coefficients to be used in
        %the reconstruction.
        ccoef = [acoef, dcoef];

        %Reconstructing the data with the haar wavelet with the coefficients
        %and MATLAB's 'waverec'.
        appr = waverec(ccoef, l, char(varagin(k)));
        data2d = [data2d; [appr(1)]];
    end
    sigavg = [sigavg; data2d'];
end