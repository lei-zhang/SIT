// M2b + SL (others’ RL update) -- Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]
data {
  int<lower=1> nSubjects;                                // number of subjects
  int<lower=1> nTrials;                                  // number of trials 
  int<lower=1, upper=nTrials> Tsubj[nSubjects];          // number of valid trials per participant
  int<lower=1,upper=2> choice1[nSubjects,nTrials];       // 1st choices, 1 or 2
  int<lower=1,upper=2> choice2[nSubjects,nTrials];       // 2nd choices, 1 or 2
  int<lower=0,upper=1> chswtch[nSubjects,nTrials];       // choice switch, 0 or 1
  real<lower=-1,upper=1> reward[nSubjects,nTrials];      // outcome, 1 or -1
  int<lower=1,upper=3> bet1[nSubjects,nTrials];          // 1st bet, 1,2 or 3   
  int<lower=1,upper=3> bet2[nSubjects,nTrials];          // 2nd bet, 1,2 or 3
  real<lower=0,upper=1>  wgtWith_ms[nSubjects,nTrials];       
  real<lower=0,upper=1>  wgtAgst_ms[nSubjects,nTrials];  
  matrix<lower=0.25,upper=1>[nTrials,4]  wOthers[nSubjects];  // others' weight
  int<lower=1,upper=2> otherChoice2[nSubjects,nTrials,4];
  real<lower=-1,upper=1> otherReward[nSubjects,nTrials,4];
}

transformed data {
  vector[2] initV; // initial values for V
  int<lower=1> K;  // number of levels of confidence rating 
  int<lower=1> B;  // number of beta predictors  
    
  initV  = rep_vector(0.0,2);   
  B      = 11;
  K      = 3;
}

parameters {
  // group-level parameters
  real lr_my_mu_pr;   // learning rate for self
  real<lower=0> lr_my_sd;
  real lr_oth_mu_pr;  // // learning rate for other
  real<lower=0> lr_oth_sd;
  real tau_oth_mu_pr;   // tau_mu before probit  
  real<lower=0> tau_oth_sd;
  vector[B] beta_mu;
  vector<lower=0>[B] beta_sd;
  real thres_diff_mu_pr;
  real<lower=0> thres_diff_sd; 
  
  // subject-level raw parameters, follows norm(0,1), for later Matt Trick
  vector[nSubjects] lr_my_raw;  
  vector[nSubjects] lr_oth_raw;  
  vector[nSubjects] tau_oth_raw;
  vector[nSubjects] beta_raw[B];   // dim: [B, nSubjects]
  vector[nSubjects] thres_diff_raw;  
}

transformed parameters {
  vector<lower=0,upper=1>[nSubjects] lr_my;
  vector<lower=0,upper=1>[nSubjects] lr_oth;
  vector<lower=0,upper=5>[nSubjects] tau_oth;
  vector[nSubjects] beta[B];
  vector<lower=0>[nSubjects] thres_diff;
  
  // Matt Trick, note that the input of Phi_approx must be 'real' rather than 'vector'
  lr_my = Phi_approx( lr_my_mu_pr + lr_my_sd * lr_my_raw );
  lr_oth = Phi_approx( lr_oth_mu_pr + lr_oth_sd * lr_oth_raw );
  tau_oth = Phi_approx( tau_oth_mu_pr + tau_oth_sd * tau_oth_raw ) * 5;
  for (i in 1:B) {
    beta[i] = beta_mu[i] + beta_sd[i] * beta_raw[i];
  }
  thres_diff = exp(thres_diff_mu_pr + thres_diff_sd * thres_diff_raw);
}

model {
  // define the value and pe vectors
  vector[2] myValue[nTrials+1];
  vector[2] otherValue[nTrials+1];
  vector[nTrials] pe;
  vector[nTrials] penc;
  real valdiff;
  vector[2] valfun1;
  real valfun2;
  real betfun1;
  real betfun2;
  
  // hyperparameters
  lr_my_mu_pr  ~ normal(0,1);
  lr_my_sd  ~ cauchy(0,2);
  lr_oth_mu_pr  ~ normal(0,1);
  lr_oth_sd  ~ cauchy(0,2);
  beta_mu  ~ normal(0,1);
  beta_sd  ~ cauchy(0,2);
  tau_oth_mu_pr ~ normal(0,1);
  tau_oth_sd    ~ cauchy(0,2);
  thres_diff_mu_pr ~ normal(0,1);
  thres_diff_sd ~ cauchy(0,2);
  
  // individual parameter
  lr_my_raw  ~ normal(0,1);  
  lr_oth_raw  ~ normal(0,1);  
  for (i in 1:B) {
    beta_raw[i]  ~ normal(0,1);
  }
  tau_oth_raw ~ normal(0,1);
  thres_diff_raw ~ normal(0,1);  

  // subject loop and trial loop
  for (s in 1:nSubjects) {
    vector[K-1] thres;
    vector[2] v_oth[nTrials+1,4];
    real pe_oth[nTrials,4];
    real penc_oth[nTrials,4];
    real oth_v_mat[4,2];

    myValue[1]    = initV;
    otherValue[1] = initV;

    for (o in 1:4) {
      v_oth[1,o] = initV;
    }

    thres[1] = 0.0;
    thres[2] = thres_diff[s];
    
    for (t in 1:Tsubj[s]) {
      valfun1 = beta[1,s]*myValue[t] + beta[2,s]*otherValue[t];
      choice1[s,t] ~ categorical_logit( valfun1 );
      
      valdiff = valfun1[choice1[s,t]] - valfun1[3-choice1[s,t]];

      betfun1 = beta[6,s] + beta[7,s] * valdiff;
      bet1[s,t] ~ ordered_logistic(betfun1, thres);

      valfun2 = beta[3,s] + beta[4,s]*valdiff + beta[5,s]*wgtAgst_ms[s,t];
      chswtch[s,t] ~ bernoulli_logit(valfun2);

      if ( chswtch[s,t] == 0) {
        betfun2 = beta[8,s] * wgtWith_ms[s,t] + beta[9,s] * wgtAgst_ms[s,t] + betfun1;
      } else if ( chswtch[s,t] == 1) {
        betfun2 = beta[10,s] * wgtWith_ms[s,t] + beta[11,s] * wgtAgst_ms[s,t] + betfun1;
      } 
      bet2[s,t] ~ ordered_logistic(betfun2, thres);
      
      // my prediction error
      pe[t]   =  reward[s,t] - myValue[t,choice2[s,t]];
      penc[t] = -reward[s,t] - myValue[t,3-choice2[s,t]];
      
      // update my value
      myValue[t+1,choice2[s,t]]   = myValue[t,choice2[s,t]]   + lr_my[s] * pe[t];
      myValue[t+1,3-choice2[s,t]] = myValue[t,3-choice2[s,t]] + lr_my[s] * penc[t];
      
      // treat other co-players as a separated reinforcer to update the others' value
      for (o in 1:4) {
        otherChoice2[s,t,o] ~ categorical_logit( tau_oth[s] * v_oth[t,o] );
        pe_oth[t,o]    = otherReward[s,t,o] - v_oth[t,o,otherChoice2[s,t,o]];
        penc_oth[t,o]  = (-otherReward[s,t,o]) - v_oth[t,o,3-otherChoice2[s,t,o]];

        v_oth[t+1,o,otherChoice2[s,t,o]]   = v_oth[t,o,otherChoice2[s,t,o]] + lr_oth[s] * pe_oth[t,o];
        v_oth[t+1,o,3-otherChoice2[s,t,o]] = v_oth[t,o,3-otherChoice2[s,t,o]] + lr_oth[s] * penc_oth[t,o];
      }

      for (o in 1:4) {
        oth_v_mat[o,1] = wOthers[s,t,o] * v_oth[t,o,1];
        oth_v_mat[o,2] = wOthers[s,t,o] * v_oth[t,o,2];
      }

      otherValue[t+1,1] = oth_v_mat[1,1] + oth_v_mat[2,1] + oth_v_mat[3,1] + oth_v_mat[4,1];
      otherValue[t+1,2] = oth_v_mat[1,2] + oth_v_mat[2,2] + oth_v_mat[3,2] + oth_v_mat[4,2];
      otherValue[t+1,1] = inv_logit(otherValue[t+1,1]) * 2 - 1;
      otherValue[t+1,2] = inv_logit(otherValue[t+1,2]) * 2 - 1;
    }  // trial loop
  }    // subject loop
}

generated quantities {
  real<lower=0,upper=1> lr_my_mu;
  real<lower=0,upper=1> lr_oth_mu;
  real<lower=0> thres_diff_mu;
  real<lower=0,upper=5> tau_oth_mu;

  real log_likc1[nSubjects]; 
  real log_likc2[nSubjects]; 
  real log_likb1[nSubjects]; 
  real log_likb2[nSubjects]; 
  
  // recover the mu
  lr_my_mu = Phi_approx(lr_my_mu_pr);
  lr_oth_mu = Phi_approx(lr_oth_mu_pr);
  thres_diff_mu = exp(thres_diff_mu_pr);
  tau_oth_mu  = Phi_approx(tau_oth_mu_pr)*5;
  
  {// compute the log-likelihood 
    for (s in 1:nSubjects) {
      vector[2] myValue[nTrials+1];
      vector[2] otherValue[nTrials+1];
      vector[nTrials] pe;
      vector[nTrials] penc;
      real valdiff;
      vector[2] valfun1;
      real valfun2;
      real betfun1;
      real betfun2;      
      vector[2] v_oth[nTrials+1,4];
      real pe_oth[nTrials,4];
      real penc_oth[nTrials,4];
      real oth_v_mat[4,2];
      vector[K-1] thres;

      myValue[1]    = initV;
      otherValue[1] = initV;
      for (o in 1:4) {
        v_oth[1,o] = initV;
      }

      thres[1] = 0.0;
      thres[2] = thres_diff[s];
      log_likc1[s]   = 0;
      log_likc2[s]   = 0;
      log_likb1[s]   = 0;
      log_likb2[s]   = 0;
      
      for (t in 1:Tsubj[s]) {
        valfun1 = beta[1,s]*myValue[t] + beta[2,s]*otherValue[t];
        log_likc1[s] = log_likc1[s] + categorical_logit_lpmf(choice1[s,t] | valfun1);
        
        valdiff = valfun1[choice1[s,t]] - valfun1[3-choice1[s,t]];

        betfun1 = beta[6,s] + beta[7,s]* valdiff;
        log_likb1[s] = log_likb1[s] + ordered_logistic_lpmf(bet1[s,t] | betfun1, thres);
  
        valfun2 = beta[3,s] + beta[4,s]*valdiff + beta[5,s]*wgtAgst_ms[s,t];
        log_likc2[s] = log_likc2[s] + bernoulli_logit_lpmf(chswtch[s,t] | valfun2);
  
        if ( chswtch[s,t] == 0) {
          betfun2 = beta[8,s] * wgtWith_ms[s,t] + beta[9,s] * wgtAgst_ms[s,t] + betfun1;
        } else if ( chswtch[s,t] == 1) {
          betfun2 = beta[10,s] * wgtWith_ms[s,t] + beta[11,s] * wgtAgst_ms[s,t] + betfun1;
        }
        log_likb2[s] = log_likb2[s] + ordered_logistic_lpmf(bet2[s,t] | betfun2, thres);
        
        // my prediction error
        pe[t]   =  reward[s,t] - myValue[t,choice2[s,t]];
        penc[t] = -reward[s,t] - myValue[t,3-choice2[s,t]];
        
        // update my value
        myValue[t+1,choice2[s,t]]   = myValue[t,choice2[s,t]]   + lr_my[s] * pe[t];
        myValue[t+1,3-choice2[s,t]] = myValue[t,3-choice2[s,t]] + lr_my[s] * penc[t];
        
        // treat other co-players as a separated reinforcer to update the others' value
        for (o in 1:4) {
          pe_oth[t,o]    = otherReward[s,t,o] - v_oth[t,o,otherChoice2[s,t,o]];
          penc_oth[t,o]  = (-otherReward[s,t,o]) - v_oth[t,o,3-otherChoice2[s,t,o]];
          v_oth[t+1,o,otherChoice2[s,t,o]]   = v_oth[t,o,otherChoice2[s,t,o]] + lr_oth[s] * pe_oth[t,o];
          v_oth[t+1,o,3-otherChoice2[s,t,o]] = v_oth[t,o,3-otherChoice2[s,t,o]] + lr_oth[s] * penc_oth[t,o];
        }

        for (o in 1:4) {
          oth_v_mat[o,1] = wOthers[s,t,o] * v_oth[t,o,1];
          oth_v_mat[o,2] = wOthers[s,t,o] * v_oth[t,o,2];
        }

        otherValue[t+1,1] = oth_v_mat[1,1] + oth_v_mat[2,1] + oth_v_mat[3,1] + oth_v_mat[4,1];
        otherValue[t+1,2] = oth_v_mat[1,2] + oth_v_mat[2,2] + oth_v_mat[3,2] + oth_v_mat[4,2];
        otherValue[t+1,1] = inv_logit(otherValue[t+1,1]) * 2 - 1;
        otherValue[t+1,2] = inv_logit(otherValue[t+1,2]) * 2 - 1;
      }  // trial loop
    }    // subject loop
  }
}
