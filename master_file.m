%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% PINCH VS INDEX / THUMB FLEXION %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The goal of this analysis is to look into the spatial representation
% of thumb flexion and finger flexion separately and compare with pinching.
%
% This is the master file of the analysis. 
% Each step of the analysis is under its own section.
%
% Panos Kerezoudis, CaMP lab, 12/2023

%% CD TO THE DATA FOLDER 


%% ADD TOOLBOX TO YOUR PATH
% Recommend placing the folder inside the master data folder

% Add path
addpath(genpath('/functions'))

%% DEFINE SUBJECTS

subjects = ['bp'; 'cc'; 'wm'];

% subject = 'wm';
% subject = 'cc';
subject = 'bp'; 

%% CHOOSE TASK TO ANALYZE

% task = 'fingerflex';
task = 'pinch';

%% CHECKLIST FOR EACH DATASET
% Bad channels have already been rejected

%% CYCLE THROUGH SUBJECTS 

for q = 1:size(subjects, 1)
    patient = subjects(q, :);
    disp(['ANALYZING PATIENT ' upper(patient)])
   
%% GENERATE TRIAL COUNT OF THUMB AND INDEX FINGER FLEXION 

calc_trial(subject, task);

%% CALCULATE STATIC POWER SPECTRA

calc_spectra(subject, task);

%% POWER SPECTRUM DECOUPLING DECOUPLING

decoupling(subject, task);

%% GET BROADBAND TIMESERIES

bb_ts(subject, task)

%% RHYTHM EXTRACTION, TRIAL-TRIAL RHYTHM AMPLITUDE, BROADBAND AMPLITUDE, ZMOD CORRECTED

bands = [[4 8] ; [8 12] ; [12 20]];
rhythm_extract(subject, bands, task)

%% EXTRACT TRIAL BLOCKS FOR BROADBAND AND FOR EACH FREQUENCY BAND

calc_blocks(subject, task);

%% GENERATE BASIC STATS OF BB AND RHYTHMS

blocks_stats(subject, task);

%% CALCULATE SPATIAL OVERLAP STATS

bonfen = 'n';
spat_overlap(subject, bonfen);

end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% PLOTTING FIGURES %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% BRAIN RENDERING WITH ELECTRODES

plot_sdg_locs(subject, task);

%% BROADBAND SHIFT TOPOLOGY

bonfen = 'y';
plot_sdg_bb(subject, task, bonfen)

%% CANONICAL BAND TOPOLOGY

bonfen = 'y';
plot_sdg_rhythm(subject, task, bonfen)

%% GENERATE DIFFERENT WAVEFORM TIMESERIES

gen_waveforms(subject, task)

%%  PLOT CHANNEL WITH HIGHEST BB RSA VALUE 

% chan2plot = ** ;
gen_psd(subject, task)

%% WAVELET TIME-FREQUENCY ANALYSIS AND DYNAMIC SPECTRUM

% chan2plot = ** ;
gen_tf_plot(subject, task)

%% BRAIN TOPOLOGY WEIGHTS OF DIFFERENT METRICS

plot_spat_overlap(subject)

%% BAR GRAPH OF SPATIAL OVERLAP

bar_spat_overlap(subject)

%% GENERATE BB TRACES TO COMPARE PINCH WITH FINGER FLEXION

open s1_traces.m


















