%------------------------------------------------------------------------%
%This function is used to perform adaptive SCORE                         %
%Author: Kaixian Yu, Ph.D.                                               %
%Department of Biostatistics                                             %
%the University of Texas MD Anderson Cancer Center                       %
%10/02/2016                                                              %
%One may use/distributed/reproduce/modify under GPLv2.                   %
%                                                                        %
%The author of this file is not responsible for any SCORE related issue. %
%------------------------------------------------------------------------%

function multi_stage_score(N,path_to_score,in_file,out_file,Max_size,Min_size,Max_iter,M)
%	N             : Number of first split, must be integer, and larger than 1
%	path_to_score : specify the path to the folder containing SCORE program, 
%                       ***only matlab version of SCORE supported at the moment***
%	in_file       : specify the path to input edge file, the input file can be 2/3 columns
%			representing unweighted/weighted networks
%	out_file      :	specify the path to output file,
%                       this program produces the community with only node id
%			the form of the output file as follows:
%			community_id	strength	node_ids
%			where the strength is always 0.5, as SCORE do not model the strength
%	Max_size      :	largest community allowed
%	Min_size      : smallest community allowed
%	Max_iter      : Despite anything, we only split the whole data Max_iter rounds, 
%                       even if at the end of Max_iter there are still super big clusters
%	M             : Number of split from the second round.
	addpath(path_to_score); % where the score.m is.
	edge_input      = load(in_file); % loading edges
	[size_1,size_2] = size(edge_input);
	col1            = [(edge_input(:,1) + 1) ; (edge_input(:,2) + 1) ];
	col2            = [(edge_input(:,2) + 1) ; (edge_input(:,1) + 1) ];
	if size_2 < 3 % if 2 columns, construct an unweighted network.
		val = ones(size_1 * 2,1);
	else % otherwise a weighted network.
		val = [edge_input(:,3) ; edge_input(:,3)];
	end
	net_s        = max(col1);% biggest node id
	ensp_names   = 1:net_s; 
	actual_nodes = unique(col1);% actual nodes presented in the network
	weighted_adj = sparse(col1, col2, val, net_s, net_s);% adjacency matrix
	%first round
	size_community = zeros(1,N);% tracking the size of each community
	block_matrix   = cell(1,N);% tracking the adj matrix for each community
	block_names    = cell(1,N);% node names of each community
	tmp = score(weighted_adj,N);%first split
	for i = 1:(N)
		ind=find(tmp == i);
		size_community(i) = length(ind);
		block_matrix{i}   = weighted_adj(ind,ind);
		block_names{i}    = ensp_names(ind);
	end
	% refine
	iter=1;
	while max(size_community)>Max_size && iter <= Max_iter
		new_block_matrix   = [];
		new_block_names    = [];
		new_size_community = [];
		for i = 1: length(block_names)
			if size_community(i) > Max_size
				S                  = min(M,ceil(size_community(i)/Max_size));
				tmp                = score(block_matrix{i},S);
				tmp_size_community = zeros(1,S);
				tmp_block_matrix   = cell(1,S);
				tmp_block_names    = cell(1,S);
				for j = 1:S
					ind = find(tmp==j);
					tmp_size_community(j) = length(ind);
					tmp_block_matrix{j}   = block_matrix{i}(ind,ind);
					tmp_block_names{j}    = block_names{i}(ind);
				end
				new_block_matrix   = [new_block_matrix,tmp_block_matrix];
				new_block_names    = [new_block_names,tmp_block_names];
				new_size_community = [new_size_community,tmp_size_community];
			else
				new_block_matrix   = [new_block_matrix,block_matrix(i)];
				new_block_names    = [new_block_names,block_names(i)];
				new_size_community = [new_size_community,size_community(i)];			
			end
		end
		iter           = iter + 1;
		size_community = new_size_community;
		block_matrix   = new_block_matrix;
		block_names    = new_block_names;
		
	end
	Ncla = length(size_community);
	
	for j = 1:Ncla
		tmp_nodes = intersect(block_names{j},actual_nodes) - 1;
		if length(tmp_nodes) <= Max_size && length(tmp_nodes) >= Min_size
			dlmwrite(out_file, [j, 0.5, tmp_nodes'], 'delimiter', '\t', '-append');
		end
	end
	
end

	

