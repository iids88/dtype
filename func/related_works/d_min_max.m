function [error] = d_min_max(label_mat,true_labels)
Model = crowd_model_minmax(label_mat,'true_labels',true_labels);
lambda_worker = 4*Model.Ndom^2;
lambda_task = lambda_worker * (mean(Model.DegWork)/mean(Model.DegTask));
opts={'lambda_worker',lambda_worker,'lambda_task',lambda_task,'maxIter',10,'TOL',1e-3','verbose',1};
key_min_max = MinimaxEntropy_crowd_model(Model,'algorithm','categorical',opts{:});
tasks = key_min_max.ans_labels';
error = key_min_max.error_rate;
end

