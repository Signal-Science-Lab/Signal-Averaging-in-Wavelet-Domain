function sigavg = signalavg(scan)
% SIGNALAVG approximates data with a the haar wavelet. 
%
%   SIGNALAVG decomposes data given by 'scan' with the haar wavelet and 
%   creates a reconstruction with the haar wavelet using the 
%   approximation coefficient and the zeroed detail coefficients. The
%   approximation coefficient acts as a low pass filter to create a rough,
%   low frequency representation of signal information, while the detail
%   coefficients act as high pass filters to hold higher frequency and much
%   finer signal information. The data is decomposed and reconstructed at 
%   the maximum decomposition level where each column of the given data is
%   a separate scan.
%
%   Authors: L. Woldemariam and M. Srivastava, 12-Nov-2020.
%   Last Revision: 18-Feb-2021.
%
%   Copyright 2021, Signal Science Lab
%   
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%   
%       http://www.apache.org/licenses/LICENSE-2.0
%   
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.

%Determining the size of the scan to be used while looping over data.
inputsize = size(scan);       

%Selecting the maximum decomposition level, the base 2 log of the number of
%columns. 
maxlevel = floor(log2(inputsize(2))); 

%Approximating the data.
data2d = [];
for i=1:inputsize(1)
    %An approximation is created for each row of the data. 
    approximations = [];
    
    %Finding the haar wavelet decomposition of each row of the data at the
    %maximum decomposition level.
    [c, l] = wavedec(scan(i, :), maxlevel, 'haar');
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
    acoef = appcoef(c, l, 'haar', maxlevel);
    
    %Concatenating the approximation and detail coefficients to be used in
    %the reconstruction.
    ccoef = [acoef, dcoef];
    
    %Reconstructing the data with the haar wavelet with the coefficients
    %and MATLAB's 'waverec'.
    appr = waverec(ccoef, l, 'haar');
    size(appr)
    data2d = [data2d; [appr]];
    
end

end
