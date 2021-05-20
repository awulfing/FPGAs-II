clear all  % clear all workspace variables
close all  % close all figure windows

%-----------------------------------------------------------------------
% These parameters need to match the settings in my_test_vectors.m
% The Component_latency needs to match the latency in my_component.vhd
%-----------------------------------------------------------------------
Nvectors = 10;  % number of test vectors created
Component_latency = 5;  % the latency of the component being tested
W1 = 52;  % wordlength
F1 = 26;   % number of fractional bits
S1 = 0;   % signedness
W2 = 28;  % wordlength
F2 = 27;   % number of fractional bits
S2 = 0;   % signedness


%--------------------------------------------------------
% Read in the file input1.txt
%--------------------------------------------------------
disp('------------------------------------------')
disp('Reading in values from file input1.txt')
fid1 = fopen('input1.txt','r');
line_in = fgetl(fid1);
a = fi(0,S1,W1,F1);
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
% Read in the file input2.txt
%--------------------------------------------------------
disp('------------------------------------------')
disp('Reading in values from file input2.txt')
fid2 = fopen('input2.txt','r');
line_in = fgetl(fid2);
a = fi(0,0,W2,0);
index = 1;
while ischar(line_in)
    a.bin = line_in;  % convert binary string to fixed-point
    address_vectors(index) = a;
    disp([num2str(index) ' : ' line_in ' = ' num2str(a)])
    index = index + 1;
    line_in = fgetl(fid2);
end
fclose(fid2);

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
% Read in the file output1.txt
%--------------------------------------------------------
disp('------------------------------------------')
disp('Reading in values from file output1.txt')
fid3 = fopen('output1.txt','r');
line_in = fgetl(fid3);
a = fi(0,S1,W1,F1);
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
    line_in = fgetl(fid3);
end
fclose(fid3);

%--------------------------------------------------------
% Read in the file output2.txt
%--------------------------------------------------------
disp('------------------------------------------')
disp('Reading in values from file output2.txt')
fid4 = fopen('output2.txt','r');
line_in = fgetl(fid4);
a = fi(0,S2,W2,F2);
index = 1;
while ischar(line_in)
    % check if string contains any std_logic characters other than binary
    s = 0;
    for i=1:7
        s = s + contains(line_in,stdchar(i));  % check in line_in contains non binary std_logic values
    end
    if s == 0  % input string contains only 0 or 1s
        a.bin = line_in;  % convert binary string to fixed-point
        rom_vhdl(index) = a;        
        disp([num2str(index) ' : ' line_in ' = ' num2str(a)])
        index = index + 1;
    else
        disp([num2str(index) ' : ' line_in ' ~~ Ignoring line since it contains non-binary std_logic characters'])
    end
    line_in = fgetl(fid4);
end
fclose(fid4);


%--------------------------------------------------------------------------
% Verification 1: Check the ROM component using input2 (address_vectors)
%                 and output2 (rom_vectors)
%--------------------------------------------------------------------------
load ROM.mat;  % get the saved ROM table that is in x_beta_table
rom_lookup = x_beta_table;
for i=1:Nvectors
    address = int32(address_vectors(i));
    x = x_beta_table{address+1};
    rom_matlab{i}.bits = x.output_bits;
end

rom_latency = 2;

%--------------------------------------------------------
% Compare matlab ROM to vhdl ROM
%--------------------------------------------------------
disp('------------------------------------------')
disp('Performing ROM Verification')
error_flag = 0;
for i=1:Nvectors
    x = rom_matlab{i}.bits;
    y=rom_vhdl(i+rom_latency);
    if strcmp(x,y.bin) == 0
        a = x;
        disp(['    -------------------------------------------'])
        disp(['    Verification Error Occurred for address case = ' num2str(i) ])
        disp(['    Matlab result = ' x])
        disp(['    VHDL result   = ' y.bin ' = ' num2str(y)])
        error_flag = 1;
    end
end

disp(' ')
if error_flag == 0
    disp('   ROM Verification Succeeded!')
else
    disp('   ******* ROM Verification Failed *******')
    return
end


%--------------------------------------------------------------------------
% Verification 2: Check my_component2 using input1 (test_vectors), 
%                 input2 (address_vectors), and output1 (vhdl_vectors)
%--------------------------------------------------------------------------

%--------------------------------------------------------
% Run test vectors through my_fxpt_function2
%--------------------------------------------------------

matlab_vectors = my_fxpt_function2(test_vectors, address_vectors,rom_lookup);


matlab_vectors.hex
vhdl_vectors.hex


%--------------------------------------------------------
% Compare matlab_vectors to vhdl_vectors
%--------------------------------------------------------
disp('------------------------------------------')
disp('Performing Verification for my_component2.vhd')
index_offset = 0;  % set the alignment offset if needed (initial output.txt values might be valid and not ignored if they contain only binary characters)
error_flag = 0;
for i=1:Nvectors
    x = matlab_vectors(i+ index_offset);
    y = vhdl_vectors(i);
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
    disp('   Verification Succeeded for my_component2.vhd !')
else
    disp('   ******* Verification Failed *******')
end







