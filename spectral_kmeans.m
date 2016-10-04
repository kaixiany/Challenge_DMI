function label = spectral_kmeans(adj,K)
	[eigv,~] = eigs(adj, K);
	kmeanslabel = kmeans(eigv, K, 'replicates', 100 );
	label = kmeanslabel;
end