function [tasks] = d_var_two(label_mat)

m = size(label_mat,1);
Model = crowd_model(label_mat);
key_var_two = variationalEM_two_coin_crowd_model(Model, 'ell',[2,1;1,2],'maxIter',10,'TOL',1e-3);
tasks = key_var_two.ans_labels';

end
