This README is constructed for the DREAM challenge: Disease Modules identification
# subchallenge 1
Make sure you have matlab installed, and run from command line:

matlab -nodesktop -nodisplay -r "multi_stage_score(N,path_to_score,in_file,out_file,Max_size,Min_size,Max_iter,M)"
%	N             : Number of first split, must be integer, and larger than 1
%	path_to_score : specify the path to the folder containing SCORE program, 
%                   ***only matlab version of SCORE supported at the moment***
%	in_file       : specify the path to input edge file, the input file can be 2/3 columns
%					representing unweighted/weighted networks
%	out_file      :	specify the path to output file,
%                   this program produces the community with only node id
%				    the form of the output file as follows:
%					community_id	strength	node_ids
%				    where the strength is always 0.5, as SCORE do not model the strength
%	Max_size      :	largest community allowed
%	Min_size      : smallest community allowed
%	Max_iter      : Despite anything, we only split the whole data Max_iter rounds, 
%                   even if at the end of Max_iter there are still super big clusters
%	M             : Number of split from the second round.

## One example running on redhat 7.x and matlab2014b is posted below
matlab -nodesktop -nodisplay -r "multi_stage_score(2,'./score-Matlab/','1_ppi_anonym_v2.txt','./output/1_ppi_anonym_v2.txt',100,3,10,5)"

# subchallenge 2
Very similar to Subchallenge 1, only thing different is this one uses a function called combining_information, the usage as follows:

matlab -nodesktop -nodisplay -r "combining_information(N,path_to_score,in_file,out_file,Max_size,Min_size,Max_iter,M)"
%	N             : Number of first split, must be integer, and larger than 1
%	path_to_score : specify the path to the folder containing SCORE program, 
%                   ***only matlab version of SCORE supported at the moment***
%	in_file       : specify the path to input edge file, the input file can be 2/3 columns
%					representing unweighted/weighted networks, the files should be given in cell
%					form, e.g. {'file1','file2'}
%	out_file      :	specify the path to output file,
%                   this program produces the community with only node id
%				    the form of the output file as follows:
%					community_id	strength	node_ids
%				    where the strength is always 0.5, as SCORE do not model the strength
%	Max_size      :	largest community allowed
%	Min_size      : smallest community allowed
%	Max_iter      : Despite anything, we only split the whole data Max_iter rounds, 
%                   even if at the end of Max_iter there are still super big clusters
%	M             : Number of split from the second round.

## One example is 
matlab -nodesktop -nodisplay -r "multi_stage_score(2,'./score-Matlab/',{'1_ppi_anonym_aligned_v2.txt','2_ppi_anonym_aligned_v2.txt'},'./output/test.txt',100,3,10,5)"
