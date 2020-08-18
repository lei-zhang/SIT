[![GitHub repo size](https://img.shields.io/github/repo-size/lei-zhang/SIT?color=brightgreen&logo=github)](https://github.com/lei-zhang/SIT)
[![GitHub language count](https://img.shields.io/github/languages/count/lei-zhang/SIT?color=brightgreen&logo=github)](https://github.com/lei-zhang/SIT)
[![DOI](https://img.shields.io/badge/DOI-10.1126%2Fsciadv.abb4159-informational)](https://advances.sciencemag.org/content/6/34/eabb4159)
[![GitHub last commit](https://img.shields.io/github/last-commit/lei-zhang/SIT?color=orange&logo=github)](https://github.com/lei-zhang/SIT)<br />
[![Twitter Follow](https://img.shields.io/twitter/follow/lei_zhang_lz?label=%40lei_zhang_lz)](https://twitter.com/lei_zhang_lz)
[![Twitter Follow](https://img.shields.io/twitter/follow/SysNeuroHamburg?label=%40SysNeuroHamburg)](https://twitter.com/SysNeuroHamburg)
[![Lab2 Twitter Follow](https://img.shields.io/twitter/follow/ScanUnit?label=%40ScanUnit)](https://twitter.com/ScanUnit)

Code and data for the **social influence task (SIT)**, accompanying the paper: <br />
**Zhang, L. & Gläscher, J. (2020). A brain network supporting social influences in human decision-making.** *Science Advances*, **6**, eabb4159. <br />
[DOI: 10.1126/sciadv.abb4159](https://advances.sciencemag.org/content/6/34/eabb4159).
___

**Outreach:**
* A **1.25-min #SciComm** video in lay English is available on [YouTube]() and [BiliBili]() (links to be updated).
* A **1-hour talk** on this paper is available on [YouTube](https://youtu.be/PQe9bv07Qmc) and [BiliBili](https://www.bilibili.com/video/BV15K411n7eN/). The slides deck is available [here](presentation_zhang_gläscher_2020.pdf).
* Part of the **experimental setup** was previously covered by a European television channel [Arte Xenius](https://www.arte.tv/en/videos/RC-014038/xenius/) (in [German](https://www.youtube.com/watch?v=xWvLVdg3CeE#t=05m04s) and [French](https://www.youtube.com/watch?v=M-VEvlWEMJc#t=05m43s)).
___

**This repository contains:**
```
root
 ├── data # Preprocessed behavioral data & fMRI BOLD time series data
 │    ├── behavioral
 │    ├── fMRI
 ├── code # Matlab & R code to run analyses and produce figures
 │    ├── behavioral
 │    ├── fMRI
```

**Note 1**: to properly run all scripts, you may need to set the root of this repository as your work directory. <br />
**Note 2**: to properly run all modeling analyses, you may need to install the [{RStan} package](https://mc-stan.org/users/interfaces/rstan.html) in R. <br />
**Note 3**: to reproduce the Matlab figures, you may need the [NaN Suite](https://www.mathworks.com/matlabcentral/fileexchange/6837-nan-suite), the [color brewer](https://www.mathworks.com/matlabcentral/fileexchange/34087-cbrewer-colorbrewer-schemes-for-matlab) toolbox, and the [offsetAxes](https://github.com/anne-urai/Tools/blob/master/plotting/offsetAxes.m) function. 
___

## Behavioral analyses
* Figure 1B: [plot_single_sub_data.m](code/behavioral/plot_single_sub_data.m)
* Figure 1D-E: [plot_main_behav_within_trial.m](code/behavioral/plot_main_behav_within_trial.m)
* Figure 1F-G: [plot_acc_bet_within_trial.m](code/behavioral/plot_acc_bet_within_trial.m)
* Figure 1H-I: [plot_main_behav_between_trial.m](code/behavioral/plot_main_behav_between_trial.m)

## Computational modeling
* Figure 2E-H: [plot_m6b_winning.r](code/behavioral/plot_m6b_winning.r)
* Figure 2I-J: [plot_param_and_behav.m](code/behavioral/plot_param_and_behav.m)

## fMRI time series analyses
* Figure 3A: [plot_dec_var_corr.m](code/behavioral/plot_dec_var_corr.m)
* Figure 3D-F: [pe_time_series_plot.m](code/fMRI/pe_time_series_plot.m)
* core function: [ts_corr_basic.m](code/fMRI/ts_corr_basic.m) --> relies on [normalise.m](code/normalise.m)
* permutation test: [ts_perm_test.m](code/fMRI/ts_perm_test.m)

## fMRI connectivity analyses
* Figure 4B-C:
* Figure 4D:
* Figure 4F-I:

___

For bug reports, please contact Lei Zhang ([lei.zhang@univie.ac.at](mailto:lei.zhang@univie.ac.at), or [@lei_zhang@lz](https://twitter.com/lei_zhang_lz)).

Thanks to [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) and [shields.io](https://shields.io/).

___

### LICENSE

This license (CC BY-NC 4.0) gives you the right to re-use and adapt, as long as you note any changes you made, and provide a link to the original source. Read [here](https://creativecommons.org/licenses/by-nc/4.0/) for more details. 

![](https://upload.wikimedia.org/wikipedia/commons/9/99/Cc-by-nc_icon.svg)
