% envelopeFlange.m
%
% This script creates a flanger effect with an lfo that has
% a depth parameter modulated by the input signal's envelope.
% 
% A threshold is used to exaggerate the the values of the
% envelope.
%
% Sean Newell 

function [out,buffer,fb,env] = envelopeFlange(in,buffer,Fs,n,...
        rate,predelay,wet,thresh,fb,env)
    
alpha = 0.9997; % Feedback gain
%fb = 0; % Initialized value for feedback
  if abs(in) < thresh
      % Smooth the envelope to a very low value
      env = (1-alpha) * 0.5 * abs(in) + alpha * fb;
      fb = env;
  else 
      env = (1-alpha) * abs(in) + alpha * fb;
      fb = env;  
  end
  
% Make-up gain
env = 80*env;

depth = env; % Samples (amplitude of lfo)

t = (n-1)/Fs;
lfo = depth * sin(2*pi*rate*t) + predelay;

% Wet/dry mix
mixPercent = wet;
mix = mixPercent/100;
   
% Interpolation
fracDelay = lfo;
intDelay = floor(fracDelay);
frac = fracDelay - intDelay;
   
% Store dry and wet signals
drySig = in;
wetSig = (1-frac)*buffer(intDelay,1)+(frac)*buffer(intDelay+1,1);

% Blend parallel paths
out = (1-mix)*drySig+mix*wetSig;
   
% Update buffer
buffer = [in ; buffer(1:end-1,1)];
