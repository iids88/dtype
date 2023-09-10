function [error] = d_min_max_xv(label_mat,true_labels)
Model = crowd_model_minmax(label_mat,'true_labels',true_labels);
opts={'maxIter',10,'TOL',1e-3','verbose',1};
key_min_max = XV_Likelihood_MinimaxEntropy_crowd_model(Model,'algorithm','categorical',opts{:});
error = key_min_max.error_rate;
end

