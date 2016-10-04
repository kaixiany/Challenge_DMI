function label = score(adj, K)

%--------------------------------------------------------------------------
% score.m:  find the community labels by the SCORE method 
%--------------------------------------------------------------------------
%
% Authors: 
%    Pengsheng Ji and Jiashun Jin
%
% Description: 
%    This function takes the adjacency matrix of an undirected network and the estimated number
%    of communities, and gives the community label by the SCORE method. The K leading eigenvectors
%    of the adjacency matrix are calculated; then the element-wise ratios of the latter eigenvectors
%    to the first leading eigenvector are calculated; then run the kmeans algorithm on these ratios. 
%    Make sure that the network is connected (e.g., by using the function grComp from the grTheory Toolbox).
%
% Usage:
%    label = score(adj, K)
%
% Input: 
%    adj    the symmetric adjacency matrix with 0 or 1 only
%    K      the number of communities in the network
%
% Output:
%    label  the community label by the SCORE method
%
% References:
%   (1) Jin, J. (2015) Fast community detection by SCORE. Ann. Statist. 43, no. 1, 57--89. doi:10.1214/14-AOS1265.
%    http://projecteuclid.org/euclid.aos/1416322036.
%   (2) Ji, P. and Jin, J. (2016). Coauthorship and Citation Networks for Statisticians. Annals of Applied 
%    Statistics, to appear  with discussion. arXiv:1410.2840


[eigv,db] = eigs(adj, K);

% compute the element-wise ratios
[m, n] = size(adj);
ratio = zeros(m, K-1);
for j=2:K
    ratio(:,j-1) = eigv(:,j)./eigv(:,1)  ; 
end

% thresholding is included below but most of time it is not necessary
thresh = log(m);
ratio(ratio > thresh) = thresh;
ratio(ratio < -thresh) = -thresh;


% cluster the eigen-ratio using kmeans with different initial values; 
% OK to see some warnings when some clusters become empty
kmeanslabel = kmeans(ratio, K, 'replicates', 100 ); 

label = kmeanslabel;
end