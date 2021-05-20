

Nvectors = 10;  % number of test vectors to create
Component_latency = 5;  % Add zeros to flush component pipeline
W1 = 52;  % wordlength
F1 = 28;   % number of fractional bits (not used to create vectors)
S1 = 0;   % signedness
W2 = 6;  % wordlength
F2 = 7;   % number of fractional bits  (not used to create vectors)
S2 = 0;   % signedness

%--------------------------------------------------------
% Open file input.txt
%--------------------------------------------------------
fid1 = fopen('input1.txt','w');  % input signal
fid2 = fopen('input2.txt','w');  % ROM 

%---------------------------------------------------------
% Input coverage is a random selection over input range
% Don't forget edge cases in random coverage
%---------------------------------------------------------
rng('shuffle','twister');  % 'shuffle' seeds the random number generator with the current time so each randi call is different;  'twister' uses the Mersenne Twister algorithm 
r1 = randi([0 2^W1-1],1,Nvectors);  % select from a uniform distribution
r2 = randi([0 2^W2-1],1,Nvectors);  % select from a uniform distribution

simulation_time = 0;
%--------------------------------------------------------
% Write the binary strings to file
%--------------------------------------------------------
index = 1;
for i=1:Nvectors
    f1 = fi(r1(i),S1,W1,0);
    f2 = fi(r2(i),S2,W2,0);
    fprintf(fid1,'%s\n',f1.bin);
    fprintf(fid2,'%s\n',f2.bin);
    simulation_time = simulation_time + 20;
end

%--------------------------------------------------------
% Write enough zeros to flush component pipeline
%--------------------------------------------------------
for i=1:Component_latency + 5
    z1 = fi(0,S1,W1,0);
    z2 = fi(0,S2,W2,0);
    fprintf(fid1,'%s\n',z1.bin);
    fprintf(fid2,'%s\n',z2.bin);
    simulation_time = simulation_time + 20;
end

%------------------------------------
% Close File
%------------------------------------
fclose(fid1);
fclose(fid2);

disp(['Note: Set ModelSim Simulation time to at least ' num2str(simulation_time) ' ns'])

