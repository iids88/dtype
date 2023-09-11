# D-type model for crowdsourcing

This repository includes codes for "[A Worker-Task Specialization Model for Crowdsourcing: Efficient Inference and Fundamental Limits](https://arxiv.org/abs/2111.12550)," which is published in IEEE Transactions on Information Theory.

# Explanations
In `data` folder, one can find csv data files.
There are two files storing the ground truth labels for each task: `gt_athlete.csv` and `gt_netflix.csv`. Also, there are two files which have answer labels for each task: `ans_athlete.csv` and `ans_netflix.csv`. Answers on each task were obtained from multiple workers in [Amazon Mechanical Turk](https://www.mturk.com/ "mTurk home").

## Synthetic data
Run `main_reliable.m` or `main_spammer.m` to get results using systhetic data which is generated in the d-type model.

## Real data
Run `main_real.m` to get results using real data obtained from [Amazon Mechanical Turk](https://www.mturk.com/ "mTurk home"). 

---
# References
In Fig. 4 of [the paper](https://arxiv.org/abs/2111.12550), we compared our algorithms to different algorithms below.

|Papers|Authors|Abbreviations for algorithms|
|------------------------------------------------------------------------------|-------|----------------------------|
|[Maximum likelihood estimation of observer error-rates using the em algorithm](https://rss.onlinelibrary.wiley.com/doi/abs/10.2307/2346806)|A. P. Dawid, and A. M. Skene|EM|
|Variational inference for crowdsourcing|Q. Liu, J. Peng, and A. T. Ihler|Variational|
|Budget-optimal task allocation for reliable crowdsourcing systems|D. R. Karger, S. Oh, and D. Shah|KOS|
|Aggregating crowdsourced binary rating|N. Dalvi, A. Dasgupta, R. Kumar, and V. Rasgoti|Ratio-Eigen|
|Spectral methods meetem: A provably optimal algorithm for crowdsourcing|Y. Zhang, X. Chen, D. Zhou, and M. I. Jordan|SpecEM|
|Aggregating ordinal labels from crowds by minimax conditional entropy|D. Zhou, Q. Liu, J. Platt, and C. Meek|Minimax|


