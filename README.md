# SIT <img src="https://github.com/lei-zhang/SIT/raw/master/network_demo.jpg" align="right" width="250px">

[![GitHub repo size](https://img.shields.io/github/repo-size/lei-zhang/SIT?color=brightgreen&logo=github)](https://github.com/lei-zhang/SIT)
[![GitHub language count](https://img.shields.io/github/languages/count/lei-zhang/SIT?color=brightgreen&logo=github)](https://github.com/lei-zhang/SIT)
[![DOI](https://img.shields.io/badge/DOI-10.1126%2Fsciadv.abb4159-informational)](https://advances.sciencemag.org/content/6/34/eabb4159)
[![GitHub last commit](https://img.shields.io/github/last-commit/lei-zhang/SIT?color=orange&logo=github)](https://github.com/lei-zhang/SIT)<br />
[![Twitter Follow](https://img.shields.io/twitter/follow/lei_zhang_lz?label=%40lei_zhang_lz)](https://twitter.com/lei_zhang_lz)
[![Twitter Follow](https://img.shields.io/twitter/follow/SysNeuroHamburg?label=%40SysNeuroHamburg)](https://twitter.com/SysNeuroHamburg)
[![Lab2 Twitter Follow](https://img.shields.io/twitter/follow/ScanUnit?label=%40ScanUnit)](https://twitter.com/ScanUnit)


Code and data for the **social influence task (SIT)**, accompanying the paper: 

**Zhang, L. & Gläscher, J. (2020). A brain network supporting social influences in human decision-making.** *Science Advances*, **6**, eabb4159. <br />
[DOI: 10.1126/sciadv.abb4159](https://advances.sciencemag.org/content/6/34/eabb4159).
___

**Outreach:**
* A **1.4-min #SciComm** video in lay English is available on [YouTube](https://youtu.be/EGUQ0jTno_c) and [bilibili](https://www.bilibili.com/video/BV1aC4y1t7dj/).
* A **1-hour talk** on this paper is available on [YouTube](https://youtu.be/PQe9bv07Qmc#t=03m35s) and [bilibili](https://www.bilibili.com/video/BV15K411n7eN/). The slides deck is available [here](presentation_zhang_gläscher_2020.pdf).
* Part of the **experimental setup** was previously covered by a European television channel [Arte Xenius](https://www.arte.tv/en/videos/RC-014038/xenius/) (in [German](https://www.youtube.com/watch?v=xWvLVdg3CeE#t=05m04s) and [French](https://www.youtube.com/watch?v=M-VEvlWEMJc#t=05m43s)).
* A [**Twitter thread**](https://twitter.com/lei_zhang_lz/status/1296243279260983296?s=20) summarizing the main findings.
* **Media coverage** (selection): [COSMOS](https://cosmosmagazine.com/health/body-and-mind/sometimes-we-need-to-learn-from-others/), [UNIVIE](https://medienportal.univie.ac.at/presse/aktuelle-pressemeldungen/detailansicht/artikel/when-learning-on-your-own-is-not-enough/), [UKE](https://www.uke.de/allgemein/presse/pressemitteilungen/detailseite_98176.html) (German), [APA.at](https://science.apa.at/rubrik/medizin_und_biotech/Wie_man_aus_Erfahrung_und_von_anderen_lernt/SCI_20200820_SCI39371351256046858) (German), [EurekAlert](https://www.eurekalert.org/pub_releases/2020-08/uov-wlo082020.php), [medicalxpress](https://medicalxpress.com/news/2020-08-neuroscientists-delineate-social-decision-making-human.html).
___

**This repository contains:**
```
root
 ├── data # Preprocessed behavioral data & fMRI BOLD time series data
 │    ├── behavioral
 │    ├── fMRI
 ├── code # Matlab, R, & Stan code to run analyses and produce figures
 │    ├── behavioral
 │    ├── fMRI
 │    ├── stanmodel
```

**Note 1**: to properly run all scripts, you may need to set the root of this repository as your working directory. <br />
**Note 2**: to properly run all modeling analyses, you may need to install the [{RStan} package](https://mc-stan.org/users/interfaces/rstan.html) in R. <br />
**Note 3**: to reproduce the Matlab figures, you may need the [NaN Suite](https://www.mathworks.com/matlabcentral/fileexchange/6837-nan-suite), the [color brewer](https://www.mathworks.com/matlabcentral/fileexchange/34087-cbrewer-colorbrewer-schemes-for-matlab) toolbox, the [niceGroupPlot kit](https://github.com/BeckyLawson/niceGroupPlot), and the [offsetAxes](https://github.com/anne-urai/Tools/blob/master/plotting/offsetAxes.m) function. 
___

## Behavioral analyses
* Figure 1B: [plot_single_sub_data.m](code/behavioral/plot_single_sub_data.m)
* Figure 1D-E: [plot_main_behav_within_trial.m](code/behavioral/plot_main_behav_within_trial.m)
* Figure 1F-G: [plot_acc_bet_within_trial.m](code/behavioral/plot_acc_bet_within_trial.m)
* Figure 1H-I: [plot_main_behav_between_trial.m](code/behavioral/plot_main_behav_between_trial.m)

## Computational modeling
* Hierarchical Bayesian models written in the [Stan](https://mc-stan.org/) language: [code/stanmodel](code/stanmodel)\*
* Figure 2E-H: [plot_m6b_winning.r](code/behavioral/plot_m6b_winning.r) --> The stanfit object needs to be downloaded at [Figshare](https://bit.ly/3kYIHyb).
* Figure 2I-J: [plot_param_and_behav.m](code/behavioral/plot_param_and_behav.m)
* Figure 3A: [plot_dec_var_corr.m](code/behavioral/plot_dec_var_corr.m)

\* Interested in how to code computational models in Stan? Feel free to check out my [BayesCog](https://github.com/lei-zhang/BayesCog_Wien) lectures (recipient of the 2020 **SIPS Commendation**, Society for the Improvement of Psychological Science).

## fMRI BOLD time-series analyses
* Figure 3D-F, 4D: [plot_time_series.m](code/fMRI/plot_time_series.m)\*
* core function for the time-series analyses: [ts_corr_basic.m](code/fMRI/ts_corr_basic.m) --> relies on [normalise.m](code/normalise.m)
* permutation test: [ts_perm_test.m](code/fMRI/ts_perm_test.m)

\* See our [tutorial paper (Zhang & Lengersdorff et al., 2020)](https://doi.org/10.1093/scan/nsaa089) for more details regarding the justification/solidification of prediction error signals.

## fMRI connectivity analyses
* Figure 4C,G,I: [plot_connectivity_strength.m](code/fMRI/plot_connectivity_strength.m)

___

For bug reports, please contact Lei Zhang ([lei.zhang@univie.ac.at](mailto:lei.zhang@univie.ac.at), or [@lei_zhang_lz](https://twitter.com/lei_zhang_lz)).

Thanks to [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) and [shields.io](https://shields.io/).

___

### LICENSE

This license (CC BY-NC 4.0) gives you the right to re-use and adapt, as long as you note any changes you made, and provide a link to the original source. Read [here](https://creativecommons.org/licenses/by-nc/4.0/) for more details. 

![](https://upload.wikimedia.org/wikipedia/commons/9/99/Cc-by-nc_icon.svg)
