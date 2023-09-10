function [tasks,wRel] = d_var_one(label_mat)

m = size(label_mat,1);
Model = crowd_model(label_mat);
key_var_one = variationalEM_one_coin_crowd_model(Model, 'ell',[2,1],'maxIter',10,'TOL',1e-3);
tasks = key_var_one.ans_labels';
rel = key_var_one.alpha_correct';
wRel = abs(rel/max(abs(rel)));

end
