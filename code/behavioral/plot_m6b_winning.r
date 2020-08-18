# plot group-level posterior densities of model parameters
# appears as Fig. 2E-H in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

#### prereq #### 
## download the Stanfit object from https://bit.ly/3kYIHyb, due to that Github cannot host large files
## save it to the 'data/behavioral/' folder, see below

#### load data and pkgs####
library(rstan)
library(ggplot2)
f = readRDS('data/behavioral/m6b_winning.RData')

#### plot, mean (short tick) + 95%HDI (shaded fill) ####

## general plotting config
tksz = 24 #ticks
ttsz = 26 #titles
tm_config = theme_classic() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(size=2),
        axis.ticks = element_line(color='black', size=1.5),
        axis.ticks.length=unit(.3, "cm"),
        axis.text.x  = element_text(color='black', face='bold',size=tksz),
        axis.text.y  = element_text(color='black', face='bold',size=tksz),
        axis.title.x = element_text(color='black', face='bold',size=ttsz),
        axis.title.y = element_text(color='black', face='bold',size=ttsz) )

#### Choice1-related parameters ####
clr1 = '#478fc2'
clr2 = '#375f97'
clr3 = '#2A3132'
s1 = c('lr_mu', 'disc_mu', 'beta_mu[1]','beta_mu[2]')

g1 = stan_plot(f$fit, pars = s1, ci_level=.95,outer_level=.99,point_est='mean',show_density=T, fill_color=clr1, est_color=clr3)
g1 = g1 + tm_config + labs(title="",y="",x="") + 
          scale_y_continuous(breaks=1:4, labels=rev(c(expression(alpha),expression(gamma),
                                                      expression(paste(beta, '(',italic('V')['self'], ')')),
                                                      expression(paste(beta, '(',italic('V')['other'],')')))),
                                              limits=c(.8, 4.8))   +
          scale_x_continuous(breaks=c(0, .5, 1), limits=c(0,1.08), labels=c('0','0.5','1'))
print(g1)	    

#### Choice2-related parameters ####
s2 = c('beta_mu[3]','beta_mu[4]','beta_mu[6]','beta_mu[5]')

g2 = stan_plot(f$fit, pars = s2, ci_level=.95,outer_level=.99,point_est='mean', show_density=T, fill_color=clr2, est_color=clr3)
g2 = g2 + tm_config + labs(title="",y="",x="") + 
                      scale_y_continuous(breaks=1:4,	labels=rev(c(
                          expression(paste(beta, '(bias)')),
                          #expression(paste(beta, '(', italic('V')^{'chn'}, '-',  italic('V')^{'unchn'}, ')'       )),
                          expression(paste(beta, '(', italic('V')['chosen'], '-',  italic('V')['unchosen'], ')'       )),
                          expression(paste(beta, '(Bet1)')),
                          expression(paste(beta, '(', italic('w'), '.' , 'N'['against'], ')'   ))
                       )), limits=c(.8,4.8))	+
          scale_x_continuous(breaks=c(-2,-1,0,1,2), limits=c(-2.5,2))
print(g2)

#### Bet1-related parameters ####
clr1 = '#86ac41'
clr2 = '#486b00'
clr3 = '#2A3132'
s3 = c('thres_diff_mu', 'beta_mu[8]','beta_mu[7]')

g3 = stan_plot(f$fit, pars = s3, ci_level=.95,outer_level=.99,point_est='mean', show_density=T,  fill_color=clr1, est_color=clr3)
g3 = g3 + tm_config + labs(title="",y="",x="") + 
          scale_y_continuous(breaks=1:3,	labels=rev(c(
              expression(paste(theta)), 
              expression(paste(beta, '(', italic('V')['chosen'], '-',  italic('V')['unchosen'], ')' )),
              expression(paste(beta, '(bias)'))
            )), limits=c(.8,3.8))		+
            scale_x_continuous(breaks=c(0,.5,1), limits=c(0,1), labels = c('0','0.5','1'))
print(g3)

#### Bet2-related parameters ####
s4 = c('beta_mu[9]','beta_mu[10]','beta_mu[11]','beta_mu[12]')

g4 = stan_plot(f$fit, pars = s4, ci_level=.95,outer_level=.99,point_est='mean', show_density=T, fill_color=clr2, est_color=clr3)
g4 = g4 + tm_config + labs(title="",y="",x="") + 
          scale_y_continuous(breaks=1:4,	labels=rev(c(
              expression(paste(beta, '(', italic('w'), '.' , 'N'['with'], ')')),
              expression(paste(beta, '(', italic('w'), '.' , 'N'['against'], ')')),
              expression(paste(beta, '(', italic('w'), '.' , 'N'['with'], ')')),
              expression(paste(beta, '(', italic('w'), '.' , 'N'['against'], ')'))
              )), limits=c(.8,4.8))	+
          scale_x_continuous(breaks=c(-2,-1,0,1), limits=c(-2.0,1))
print(g4)

# end of script
