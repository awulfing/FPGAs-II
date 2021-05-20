clear all  % clear all workspace variables
close all  % close all figure windows

%-----------------------------------------------------------------------
% These parameters need to match the settings in my_test_vectors.m
% The Component_latency needs to match the latency in my_component.vhd
%-----------------------------------------------------------------------
Nvectors = 10;  % number of test vectors created
Component_latency = 3;  % the latency of the component being tested
W = 34;  % wordlength
F = 0;   % number of fractional bits
S = 0;   % signedness


%--------------------------------------------------------
% Read in the file input.txt
%--------------------------------------------------------
disp('------------------------------------------')
disp('Reading in values from file input.txt')
fid1 = fopen('input.txt','r');
line_in = fgetl(fid1);
a = fi(0,S,W,F);
index = 1;
while ischar(line_in)
    a.bin = line_in;  % convert binary string to fixed-point
    test_vectors(index) = a;
    disp([num2str(index) ' : ' line_in ' = ' num2str(a)])
    index = index + 1;
    line_in = fgetl(fid1);
end
fclose(fid1);

%--------------------------------------------------------
% std_logic possible values
%--------------------------------------------------------
% 'U': uninitialized. This signal hasn't been set yet.
% 'X': unknown. Impossible to determine this value/result.
% '0': logic 0
% '1': logic 1
% 'Z': High Impedance
% 'W': Weak signal, can't tell if it should be 0 or 1.
% 'L': Weak signal that should probably go to 0
% 'H': Weak signal that should probably go to 1
% '-': Don't care.
stdchar = 'UXZWLH-';   % create a list of non-binary std_logic characters

%--------------------------------------------------------
% Read in the file output.txt
%--------------------------------------------------------
disp('------------------------------------------')
disp('Reading in values from file output.txt')
fid2 = fopen('output.txt','r');
line_in = fgetl(fid2);
a = fi(0,S,W,F);
index = 1;
while ischar(line_in)
    % check if string contains any std_logic characters other than binary
    s = 0;
    for i=1:7
        s = s + contains(line_in,stdchar(i));  % check in line_in contains non binary std_logic values
    end
    if s == 0  % input string contains only 0 or 1s
        a.bin = line_in;  % convert binary string to fixed-point
        vhdl_vectors(index) = a;        
        disp([num2str(index) ' : ' line_in ' = ' num2str(a)])
        index = index + 1;
    else
        disp([num2str(index) ' : ' line_in ' ~~ Ignoring line since it contains non-binary std_logic characters'])
    end
    line_in = fgetl(fid2);
end
fclose(fid2);

%--------------------------------------------------------
% Run test vectors through my_fxpt_function
%--------------------------------------------------------
matlab_vectors = my_fxpt_function(test_vectors);

%--------------------------------------------------------
% Compare matlab_vectors to vhdl_vectors
%--------------------------------------------------------
disp('------------------------------------------')
disp('Performing Verification')
index_offset = 0;  % set the alignment offset if needed (initial output.txt values might be valid and not ignored if they contain only binary characters)
error_flag = 0;
for i=1:Nvectors
    x = matlab_vectors(i);
    y = vhdl_vectors(i + index_offset);
    if strcmp(x.bin,y.bin) == 0
        a = test_vectors(i);
        disp(['    -------------------------------------------'])
        disp(['    Verification Error Occurred for test vector ' num2str(a) ' = ' a.bin '(index = ' num2str(i) ')'])
        disp(['    Matlab result = ' x.bin ' = ' num2str(x)])
        disp(['    VHDL result   = ' y.bin ' = ' num2str(y)])
        error_flag = 1;
    end
end

disp(' ')
if error_flag == 0
    disp('   Verification Succeeded!')
else
    disp('   ******* Verification Failed *******')
end







