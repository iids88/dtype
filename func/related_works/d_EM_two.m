function [tasks] = d_EM_two(label_mat)

m = size(label_mat,1);
verbose = 1;
options = {'maxIter',10, 'TOL', 1e-3};
Model = crowd_model(label_mat);
key_EM_two = EM_two_coin_crowd_model(Model,options{:});
tasks = key_EM_two.ans_labels';

end
