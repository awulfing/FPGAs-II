

Nvectors = 100;  % number of test vectors to create
Component_latency = 7;  % Add zeros to flush component pipeline
W = 24;  % wordlength
F = 0;   % number of fractional bits
S = 0;   % signedness

%--------------------------------------------------------
% Open file input.txt
%--------------------------------------------------------
fid = fopen('input.txt','w');

%---------------------------------------------------------
% Input coverage is a random selection over input range
% Don't forget edge cases in random coverage
%---------------------------------------------------------
rng('shuffle','twister');  % 'shuffle' seeds the random number generator with the current time so each randi call is different;  'twister' uses the Mersenne Twister algorithm 
r = randi([0 2^W-1],1,Nvectors);  % select from a uniform distribution

%--------------------------------------------------------
% Write the binary strings to file
%--------------------------------------------------------
for i=1:Nvectors
    f = fi(r(i),S,W,F);
    fprintf(fid,'%s\n',f.bin);
end

%--------------------------------------------------------
% Write enough zeros to flush component pipeline
%--------------------------------------------------------
for i=1:Component_latency + 5
    f = fi(0,S,W,F);
    fprintf(fid,'%s\n',f.bin);
end

%------------------------------------
% Close File
%------------------------------------
fclose(fid);

