# Social influence task (SIT)

**Code and data accompanying the paper: <br />
Zhang, L. & Gläscher, J. (2020). A brain network supporting social influences in human decision-making.** <br />
[DOI: 10.1101/551614](https://www.biorxiv.org/content/10.1101/551614v3).

___

This repository contains:
```
root
 ├── data # Preprocessed behavioral data & fMRI BOLD time series data
 │    ├── behavioral
 │    ├── fMRI
 ├── code # Matlab & R code to run analyses and produce figures
 │    ├── behavioral
 │    ├── fMRI
```

(Most contents are under construction. Please stay tuned and come back later.) <br />
**Note 1**: to properly run all scripts, you may need to set the root of this repository as your work directory. <br />
**Note 2**: to properly run all modeling analyses, you may need to install the [{RStan} package](https://mc-stan.org/users/interfaces/rstan.html) in R. <br />
**Note 3**: to reproduce the Matlab figures, you may need the [color brewer](https://www.mathworks.com/matlabcentral/fileexchange/34087-cbrewer-colorbrewer-schemes-for-matlab) toolbox and the [offsetAxes](https://github.com/anne-urai/Tools/blob/master/plotting/offsetAxes.m) function. 

## Behavioral analyses
* Figure 1B: 
* Figure 1D-E: 
* Figure 1F-G: 

## Computational modeling
* Figure 2E-H: 
* Figure 2I-J: 

## fMRI time series analyses
* Figure 3D-F: [pe_time_series_plot.m](code/fMRI/pe_time_series_plot.m)
* core function: [ts_corr_basic.m](code/fMRI/ts_corr_basic.m) --> relies on [normalise.m](code/normalise.m)
* permutation test: [ts_perm_test.m](code/fMRI/ts_perm_test.m)

## fMRI connectivity analyses
* Figure 4B-C:
* Figure 4D:
* Figure 4F-I:

___

For bug reports, please contact Lei Zhang ([lei.zhang@univie.ac.at](mailto:lei.zhang@univie.ac.at)), or [@lei_zhang@lz](https://twitter.com/lei_zhang_lz).

Thanks to this [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).

___

### LICENSE

This license (CC BY-NC 4.0) gives you the right to re-use and adapt, as long as you note any changes you made, and provide a link to the original source. Read [here](https://creativecommons.org/licenses/by-nc/4.0/) for more details. 

![](https://upload.wikimedia.org/wikipedia/commons/9/99/Cc-by-nc_icon.svg)
