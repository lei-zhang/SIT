// M2b + SL (others’ others’ cumulative reward) -- Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]
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
  matrix<lower=0,upper=1>[nTrials,4]  otherReward2[nSubjects];  // dim: [ns, t, 4]
  matrix<lower=0,upper=1>[nTrials,4]  otherWith2[nSubjects];    // same as others' choice2 or not
  matrix<lower=0.25,upper=1>[nTrials,4]  wOthers[nSubjects];    // others' weight
  matrix<lower=1,upper=2>[nTrials,4]  otherChoice2[nSubjects];  // others' choice2
}

transformed data {
  vector[2] initV;    // initial values for V
  vector[3] pwr;      // power for the decay factor
  int<lower=1> K;     // number of levels of confidence rating 
  int<lower=1> B;     // number of beta predictors  
    
  initV  = rep_vector(0.0,2);   
  pwr[1] = 2;
  pwr[2] = 1;
  pwr[3] = 0;
  B      = 11;
  K      = 3;
}

parameters {
  // group-level parameters
  real lr_mu_pr;    // lr_mu before probit
  real<lower=0> lr_sd;
  real disc_mu_pr;  // discounting factor
  real<lower=0> disc_sd;
  vector[B] beta_mu;
  vector<lower=0>[B] beta_sd;
  real thres_diff_mu_pr;
  real<lower=0> thres_diff_sd; 
  
  // subject-level raw parameters, follows norm(0,1), for later Matt Trick
  vector[nSubjects] lr_raw;  
  vector[nSubjects] disc_raw;  
  vector[nSubjects] beta_raw[B];   // dim: [B, nSubjects]  
  vector[nSubjects] thres_diff_raw;
}

transformed parameters {
  // subject-level parameters
  vector<lower=0,upper=1>[nSubjects] lr;
  vector<lower=0,upper=1>[nSubjects] disc;
  vector[nSubjects] beta[B];
  vector<lower=0>[nSubjects] thres_diff;
  
  // Matt Trick
  lr = Phi_approx( lr_mu_pr + lr_sd * lr_raw );   
  disc = Phi_approx( disc_mu_pr + disc_sd * disc_raw );   
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
  vector[3] disc_vec;
  matrix[3,4] disc_mat;
  row_vector[4] othW;
  row_vector[4] otherReward_vec;
  
  // hyperparameters
  lr_mu_pr ~ normal(0,1);
  lr_sd    ~ cauchy(0,2);
  disc_mu_pr ~ normal(0,1);
  disc_sd    ~ cauchy(0,2);
  beta_mu ~ normal(0,1); 
  beta_sd ~ cauchy(0,2);
  thres_diff_mu_pr ~ normal(0,1);
  thres_diff_sd ~ cauchy(0,2);
  
  // Matt Trick
  for (i in 1:B) {
    beta_raw[i] ~ normal(0,1);
  } 
  thres_diff_raw ~ normal(0,1);  
  
  // subject loop and trial loop
  for (s in 1:nSubjects) {
    vector[K-1] thres;

    myValue[1]    = initV;
    otherValue[1] = initV;
    thres[1] = 0.0;
    thres[2] = thres_diff[s];

    for (t in 1:Tsubj[s]) {
      valfun1 = beta[1,s]*myValue[t] + beta[2,s]*otherValue[t];
      choice1[s,t] ~ categorical_logit( valfun1 );

      valdiff = valfun1[choice1[s,t]] - valfun1[3-choice1[s,t]];

      betfun1 = beta[6,s] + beta[7,s] * valdiff;
      bet1[s,t] ~ ordered_logistic(betfun1, thres);
      
      valfun2 = beta[3,s] + beta[4,s] * valdiff + beta[5,s] * wgtAgst_ms[s,t];
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
      myValue[t+1,choice2[s,t]]   = myValue[t,choice2[s,t]]   + lr[s] * pe[t];
      myValue[t+1,3-choice2[s,t]] = myValue[t,3-choice2[s,t]] + lr[s] * penc[t];

      // use weighted discounted outcome to update the others' value
      othW = otherWith2[s,t]; 

      if (t==1) {
        otherReward_vec  = wOthers[s,t] .* otherReward2[s,t];
      } else if (t==2) {
        otherReward_vec  = wOthers[s,t] .* otherReward2[s,t] + wOthers[s,t-1] .* otherReward2[s,t-1] * disc[s];
      } else {
        for ( j in 1:num_elements(pwr)) {
          disc_vec[j] = pow(disc[s], pwr[j]);
        }
        disc_mat = rep_matrix(disc_vec,4); // replicate by 4 columns, element-wise multiplication
        otherReward_vec  = rep_row_vector(1.0, 3) * (disc_mat .* block(wOthers[s], t-2, 1, 3, 4) .* block(otherReward2[s], t-2, 1, 3, 4));
      }

      otherValue[t+1,choice2[s,t]]   = sum( othW     .* otherReward_vec );
      otherValue[t+1,3-choice2[s,t]] = sum( (1-othW) .* otherReward_vec );
      otherValue[t+1,1] = inv_logit(otherValue[t+1,1]) * 2 - 1;
      otherValue[t+1,2] = inv_logit(otherValue[t+1,2]) * 2 - 1;

    }  // trial loop
  }    // subject loop
}

generated quantities {
  real<lower=0,upper=1> lr_mu;
  real<lower=0,upper=1> disc_mu;
  real<lower=0> thres_diff_mu;
  
  real log_likc1[nSubjects]; 
  real log_likc2[nSubjects]; 
  real log_likb1[nSubjects]; 
  real log_likb2[nSubjects]; 

  // recover the mu
  lr_mu = Phi_approx(lr_mu_pr);
  disc_mu = Phi_approx(disc_mu_pr);
  thres_diff_mu = exp(thres_diff_mu_pr);

  {//local block calculating log-likelihood
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
      vector[3] disc_vec;
      matrix[3,4] disc_mat;
      row_vector[4] othW;
      row_vector[4] otherReward_vec;
      vector[K-1] thres;

      myValue[1]    = initV;
      otherValue[1] = initV;
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

        betfun1 = beta[6,s] + beta[7,s] * valdiff;
        log_likb1[s] = log_likb1[s] + ordered_logistic_lpmf(bet1[s,t] | betfun1, thres);
        
        valfun2 = beta[3,s] + beta[4,s] * valdiff + beta[5,s] * wgtAgst_ms[s,t];
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
        myValue[t+1,choice2[s,t]]   = myValue[t,choice2[s,t]]   + lr[s] * pe[t];
        myValue[t+1,3-choice2[s,t]] = myValue[t,3-choice2[s,t]] + lr[s] * penc[t];

        // use weighted discounted outcome to update the others' value
        othW = otherWith2[s,t]; 
        if (t==1) {
          otherReward_vec  = wOthers[s,t] .* otherReward2[s,t];
        } else if (t==2) {
          otherReward_vec  = wOthers[s,t] .* otherReward2[s,t] + wOthers[s,t-1] .* otherReward2[s,t-1] * disc[s];
        } else {
          for ( j in 1:num_elements(pwr)) {
            disc_vec[j] = pow(disc[s], pwr[j]);
          }
          disc_mat = rep_matrix(disc_vec,4); // replicate by 4 columns 
          otherReward_vec  = rep_row_vector(1.0, 3) * (disc_mat .* block(wOthers[s], t-2, 1, 3, 4) .* block(otherReward2[s], t-2, 1, 3, 4));
        }
        otherValue[t+1,choice2[s,t]]   = sum( othW     .* otherReward_vec );
        otherValue[t+1,3-choice2[s,t]] = sum( (1-othW) .* otherReward_vec );
        otherValue[t+1,1] = inv_logit(otherValue[t+1,1]) * 2 - 1;
        otherValue[t+1,2] = inv_logit(otherValue[t+1,2]) * 2 - 1;

      }  // trial loop
    }    // subject loop
  } // local blockI: end
}
