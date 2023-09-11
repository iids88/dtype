# D-type model for crowdsourcing

This repository includes codes for "[A Worker-Task Specialization Model for Crowdsourcing: Efficient Inference and Fundamental Limits](https://arxiv.org/abs/2111.12550)," which is published in IEEE Transactions on Information Theory.

# Explanations
In `data` folder, one can find csv data files.
There are two files storing the ground truth labels for each task: `gt_athlete.csv` and `gt_netflix.csv`. Also, there are two files which have the answer labels for each task: `ans_athlete.csv` and `ans_netflix.csv`. Answers on each task were obtained from multiple workers in [Amazon Mechanical Turk](https://www.mturk.com/ "mTurk home").
## Synthetic data
Run `main_reliable.m` or `main_spammer.m` to get results using systhetic data which is generated in the d-type model.

## Real data
Run `main_real.m` to get results using real data obtained from [Amazon Mechanical Turk](https://www.mturk.com/ "mTurk home"). 

---

