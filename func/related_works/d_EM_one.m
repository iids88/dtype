function [tasks,wRel] = d_EM_one(label_mat)

m = size(label_mat,1);
verbose = 1;
options = {'maxIter',10, 'TOL', 1e-3};
Model = crowd_model(label_mat);
key_EM_one = EM_one_coin_crowd_model(Model,options{:});
tasks = key_EM_one.ans_labels';
wRel = key_EM_one.reliability';

end

