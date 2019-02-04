% newell_HW4.m
% 
% Test script for envelopeFlange 
%
% Sean Newell
clc; clear;

% Import audio
[in,Fs] = audioread('Funkish_GTR.wav');

thresh = 0.8; % Thresh for env (linear value)

% Create Linear Delay Buffer
maxDelay = 50+1;
buffer = zeros(maxDelay,1);

% Parameters for Flanger effect
rate = 0.2; % Hz (frequency of lfo)
predelay = 6; % Samples (offset of lfo)
wet = 50; % Wet/dry mix


% Initialize output signal
N = length(in);
out = zeros(N,1);

% Create envelope
env = zeros(N,1); % Initialize env
fb = 0;

for n = 1:N
   % EnvelopeFlange function 
    [out(n,1),buffer,fb,env(n,1)] = envelopeFlange(in(n,1),buffer,Fs,n,...
        rate,predelay,wet,thresh,fb,env(n,1));
end

plot(abs(in));
figure;
plot(env);
sound(out,Fs);