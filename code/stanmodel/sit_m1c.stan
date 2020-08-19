// Pearce-Hall model -- Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]
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
}

transformed data {
  vector[2] initV;  // initial values for V
  int<lower=1> B;   // number of beta predictor
  int<lower=1> K;   // number of levels of confidence rating s

  initV = rep_vector(0.0,2);    
  B      = 7;
  K      = 3;
}

parameters {
  // group-level parameters
  real eta_mu_pr;    
  real<lower=0> eta_sd;
  real k_mu_pr;    
  real<lower=0> k_sd;
  real alpha0_mu_pr;    
  real<lower=0> alpha0_sd;
  vector[B] beta_mu;
  vector<lower=0>[B] beta_sd;
  real thres_diff_mu_pr;
  real<lower=0> thres_diff_sd; 
  
  // subject-level raw parameters, follows norm(0,1), for later Matt Trick
  vector[nSubjects] eta_raw; 
  vector[nSubjects] k_raw;  
  vector[nSubjects] alpha0_raw; 
  vector[nSubjects] beta_raw[B];   // dim: [B, nSubjects]  
  vector[nSubjects] thres_diff_raw;
}

transformed parameters {
  // subject-level parameters
  vector<lower=0,upper=1>[nSubjects] eta; // weight between prediction error and associability
  vector<lower=0,upper=1>[nSubjects] k;   // weight of associability
  vector<lower=0,upper=1>[nSubjects] alpha0;   // initial associability
  vector[nSubjects] beta[B];
  vector<lower=0>[nSubjects] thres_diff;
  
  // Matt Trick
  eta = Phi_approx( eta_mu_pr + eta_sd * eta_raw );
  k = Phi_approx( k_mu_pr + k_sd * k_raw );
  alpha0 = Phi_approx( alpha0_mu_pr + alpha0_sd * alpha0_raw );
  for (i in 1:B) {
    beta[i] = beta_mu[i] + beta_sd[i] * beta_raw[i];
  }
  thres_diff = exp(thres_diff_mu_pr + thres_diff_sd * thres_diff_raw);
}

model {
  // define the value and pe vectors
  vector[2] v[nTrials+1];     // values
  vector[nTrials] pe;         // prediction errors  
  vector[nTrials+1] alpha;      // associability
  vector[2] valfun1;
  real valfun2;
  real valdiff;
  real betfun1;
  real betfun2;

  // hyperparameters
  eta_mu_pr ~ normal(0,1);
  eta_sd    ~ cauchy(0,2);
  k_mu_pr   ~ normal(0,1);
  k_sd      ~ cauchy(0,2);
  alpha0_mu_pr ~ normal(0,1);
  alpha0_sd    ~ cauchy(0,2);

  beta_mu ~ normal(0,1); 
  beta_sd ~ cauchy(0,2);

  thres_diff_mu_pr ~ normal(0,1);
  thres_diff_sd ~ cauchy(0,2);

  // Matt Trick
  eta_raw  ~ normal(0,1);
  k_raw  ~ normal(0,1);
  alpha0_raw  ~ normal(0,1);
  for (i in 1:B) {
    beta_raw[i] ~ normal(0,1);
  } 
  thres_diff_raw ~ normal(0,1);  
  
  // subject loop and trial loop
  for (s in 1:nSubjects) {
    vector[K-1] thres;

    v[1] = initV;
    alpha[1] = alpha0[s];
    thres[1] = 0.0;
    thres[2] = thres_diff[s];

    for (t in 1:Tsubj[s]) {
      // compute action probs using built-in softmax function and related to choice data
      valfun1 = beta[1,s] * v[t];
      choice1[s,t] ~ categorical_logit( valfun1 );

      valdiff = valfun1[choice1[s,t]] - valfun1[3-choice1[s,t]];

      betfun1 = beta[4,s] + beta[5,s] * valdiff;
      bet1[s,t] ~ ordered_logistic(betfun1, thres);

      valfun2 = beta[2,s] + beta[3,s] * valdiff;
      chswtch[s,t] ~ bernoulli_logit(valfun2);

      if ( chswtch[s,t] == 0) {
        betfun2 = beta[6,s] + betfun1;
      } else if ( chswtch[s,t] == 1) {
        betfun2 = beta[7,s] + betfun1;        
      } 

      bet2[s,t] ~ ordered_logistic(betfun2, thres);     

      // prediction error
      pe[t] = reward[s,t] - v[t, choice2[s,t]];

      // associability update
      alpha[t+1] = eta[s] * fabs(pe[t]) + (1-eta[s]) * alpha[t];

      // value updating (learning)
      v[t+1] = v[t];
      v[t+1, choice2[s,t]] = v[t, choice2[s,t]] + k[s] * alpha[t] * pe[t];
    }
  }
}

generated quantities {
  real<lower=0,upper=1> eta_mu; 
  real<lower=0,upper=1> k_mu; 
  real<lower=0,upper=1> alpha0_mu; 
  real<lower=0> thres_diff_mu;
  
  real log_likc1[nSubjects]; 
  real log_likc2[nSubjects]; 
  real log_likb1[nSubjects]; 
  real log_likb2[nSubjects]; 

  // recover the mu
  eta_mu   = Phi_approx(eta_mu_pr);
  k_mu     = Phi_approx(k_mu_pr);
  alpha0_mu     = Phi_approx(alpha0_mu_pr);
  thres_diff_mu = exp(thres_diff_mu_pr);
  
  {// compute the log-likelihood
    for (s in 1:nSubjects) {
      vector[2] v[nTrials+1];     // values
      vector[nTrials] pe;         // prediction errors  
      vector[nTrials+1] alpha;
      vector[2] valfun1;
      real valfun2;
      real valdiff;
      real betfun1;
      real betfun2;
      vector[K-1] thres;

      v[1] = initV;
      alpha[1] = alpha0[s];
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

        betfun1 = beta[4,s] + beta[5,s] * valdiff;
        log_likb1[s] = log_likb1[s] + ordered_logistic_lpmf(bet1[s,t] | betfun1, thres);
        
        valfun2 = beta[2,s] + beta[3,s] * valdiff;
        log_likc2[s] = log_likc2[s] + bernoulli_logit_lpmf(chswtch[s,t] | valfun2);
        
        if ( chswtch[s,t] == 0) {
          betfun2 = beta[6,s] + betfun1;
        } else if ( chswtch[s,t] == 1) {
          betfun2 = beta[7,s] + betfun1;        
        } 
        log_likb2[s] = log_likb2[s] + ordered_logistic_lpmf(bet2[s,t] | betfun2, thres);
        
        pe[t] = reward[s,t] - v[t, choice2[s,t]];
        alpha[t+1] = eta[s] * fabs(pe[t]) + (1-eta[s]) * alpha[t];

        v[t+1] = v[t]; // make a copy of current value into t+1
        v[t+1, choice2[s,t]] = v[t, choice2[s,t]] + k[s] * alpha[t] * pe[t]; // overwrite chosen value with pe update
      } // trial
    } // sub
  } // local
}
