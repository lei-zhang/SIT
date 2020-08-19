// Fictitious RL model + social influence -- Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]
data {
  int<lower=1> nSubjects;                              // number of subjects
  int<lower=1> nTrials;                                // number of trials 
  int<lower=1, upper=nTrials> Tsubj[nSubjects];        // number of valid trials per participant
  int<lower=1,upper=2> choice1[nSubjects,nTrials];     // 1st choices, 1 or 2
  int<lower=1,upper=2> choice2[nSubjects,nTrials];     // 2nd choices, 1 or 2
  int<lower=0,upper=1> chswtch[nSubjects,nTrials];     // choice switch, 0 or 1
  int<lower=1,upper=3> bet1[nSubjects,nTrials];        // 1st bet, 1,2 or 3   
  int<lower=1,upper=3> bet2[nSubjects,nTrials];        // 2nd bet, 1,2 or 3
  real<lower=-1,upper=1> reward[nSubjects,nTrials];    // outcome, 1 or -1
  real<lower=0,upper=1>  wgtWith_ms[nSubjects,nTrials];       
  real<lower=0,upper=1>  wgtAgst_ms[nSubjects,nTrials];   
}

transformed data {
  vector[2] initV;  // initial values for V
  int<lower=1> B;   // number of beta predictor
  int<lower=1> K;   // number of levels of confidence rating s

  initV = rep_vector(0.0,2);    
  B      = 10;
  K      = 3;
}

parameters {
  // group-level parameters
  real lr_mu_pr;    // lr_mu before probit
  real<lower=0> lr_sd;
  vector[B] beta_mu;
  vector<lower=0>[B] beta_sd;
  real thres_diff_mu_pr;
  real<lower=0> thres_diff_sd; 
  
  // subject-level raw parameters, follows norm(0,1), for later Matt Trick
  vector[nSubjects] lr_raw;  
  vector[nSubjects] beta_raw[B];   // dim: [B, nSubjects]  
  vector[nSubjects] thres_diff_raw;
}

transformed parameters {
  // subject-level parameters
  vector<lower=0,upper=1>[nSubjects] lr;  
  vector[nSubjects] beta[B];
  vector<lower=0>[nSubjects] thres_diff;
  
  // Matt Trick, note that the input of Phi_approx must be 'real' rather than 'vector'
  lr = Phi_approx( lr_mu_pr + lr_sd * lr_raw );
  for (i in 1:B) {
    beta[i] = beta_mu[i] + beta_sd[i] * beta_raw[i];
  }
  thres_diff = exp(thres_diff_mu_pr + thres_diff_sd * thres_diff_raw);
}

model {
  // define the value and pe vectors
  vector[2] v[nTrials+1];     // values
  vector[nTrials] pe;         // prediction errors  
  vector[nTrials] penc; 
  vector[2] valfun1;
  real valfun2;
  real valdiff;
  real betfun1;
  real betfun2;

  // hyperparameters
  lr_mu_pr  ~ normal(0,1);
  lr_sd     ~ cauchy(0,2);

  beta_mu ~ normal(0,1); 
  beta_sd ~ cauchy(0,2);

  thres_diff_mu_pr ~ normal(0,1);
  thres_diff_sd ~ cauchy(0,2);
  
  // Matt Trick
  lr_raw  ~ normal(0,1);  
  for (i in 1:B) {
    beta_raw[i] ~ normal(0,1);
  } 
  thres_diff_raw ~ normal(0,1);  
  
  // subject loop and trial loop
  for (s in 1:nSubjects) {
    vector[K-1] thres;

    v[1] = initV;  
    thres[1] = 0.0;
    thres[2] = thres_diff[s];

    for (t in 1:Tsubj[s]) {
      // compute action probs using built-in softmax function and related to choice data
      valfun1 = beta[1,s] * v[t];
      choice1[s,t] ~ categorical_logit( valfun1 );

      valdiff = valfun1[choice1[s,t]] - valfun1[3-choice1[s,t]];

      betfun1 = beta[5,s] + beta[6,s] * valdiff;
      bet1[s,t] ~ ordered_logistic(betfun1, thres);

      valfun2 = beta[2,s] + beta[3,s] * valdiff + beta[4,s] * wgtAgst_ms[s,t];
      chswtch[s,t] ~ bernoulli_logit(valfun2);

      if ( chswtch[s,t] == 0) {
        betfun2 = beta[7,s] * wgtWith_ms[s,t] + beta[8,s] * wgtAgst_ms[s,t] + betfun1;
      } else if ( chswtch[s,t] == 1) {
        betfun2 = beta[9,s] * wgtWith_ms[s,t] + beta[10,s] * wgtAgst_ms[s,t] + betfun1;        
      } 

      bet2[s,t] ~ ordered_logistic(betfun2, thres);     

      // prediction error
      pe[t]   =  reward[s,t] - v[t][choice2[s,t]];
      penc[t] = -reward[s,t] - v[t][3-choice2[s,t]];

      // value updating (learning)
      v[t+1][choice2[s,t]]   = v[t][choice2[s,t]]   + lr[s] * pe[t];
      v[t+1][3-choice2[s,t]] = v[t][3-choice2[s,t]] + lr[s] * penc[t];       
    }
  }
}

generated quantities {
  real<lower=0,upper=1> lr_mu; 
  real<lower=0> thres_diff_mu;
  
  real log_likc1[nSubjects]; 
  real log_likc2[nSubjects]; 
  real log_likb1[nSubjects]; 
  real log_likb2[nSubjects]; 

  // recover the mu
  lr_mu   = Phi_approx(lr_mu_pr);
  thres_diff_mu = exp(thres_diff_mu_pr);
  
  {// compute the log-likelihood
    for (s in 1:nSubjects) {
      vector[2] v[nTrials+1];     // values
      vector[nTrials] pe;         // prediction errors  
      vector[nTrials] penc; 
      vector[2] valfun1;
      real valfun2;
      real valdiff;
      real betfun1;
      real betfun2;
      vector[K-1] thres;

      v[1] = initV;
      thres[1] = 0.0;
      thres[2] = thres_diff[s];

      log_likc1[s] = 0;
      log_likc2[s] = 0;
      log_likb1[s] = 0;
      log_likb2[s] = 0;
     
      for (t in 1:Tsubj[s]) {
        valfun1 = beta[1,s] * v[t];
        log_likc1[s] = log_likc1[s] + categorical_logit_lpmf(choice1[s,t] | valfun1);
        
        valdiff = valfun1[choice1[s,t]] - valfun1[3-choice1[s,t]];

        betfun1 = beta[5,s] + beta[6,s] * valdiff;
        log_likb1[s] = log_likb1[s] + ordered_logistic_lpmf(bet1[s,t] | betfun1, thres);
        
        valfun2 = beta[2,s] + beta[3,s] * valdiff + beta[4,s] * wgtAgst_ms[s,t];
        log_likc2[s] = log_likc2[s] + bernoulli_logit_lpmf(chswtch[s,t] | valfun2);
        
        if ( chswtch[s,t] == 0) {
          betfun2 = beta[7,s] * wgtWith_ms[s,t] + beta[8,s] * wgtAgst_ms[s,t] + betfun1;
        } else if ( chswtch[s,t] == 1) {
          betfun2 = beta[9,s] * wgtWith_ms[s,t] + beta[10,s] * wgtAgst_ms[s,t] + betfun1;
        }
        log_likb2[s] = log_likb2[s] + ordered_logistic_lpmf(bet2[s,t] | betfun2, thres);
                
        pe[t]   =  reward[s,t] - v[t][choice2[s,t]];
        penc[t] = -reward[s,t] - v[t][3-choice2[s,t]];

        v[t+1][choice2[s,t]]   = v[t][choice2[s,t]]   + lr[s] * pe[t];
        v[t+1][3-choice2[s,t]] = v[t][3-choice2[s,t]] + lr[s] * penc[t];       
      } // trial
    } // sub
  } // local
}
