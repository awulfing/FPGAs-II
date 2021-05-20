function y = readoutput(x,S,W,F)

%Read in file output.txt Iteration 
stdchar = 'UXZWLH-';   % create a list of non-binary std_logic characters
disp('------------------------------------------')
disp('Reading in values from file output.txt')
myfile = fopen(x,'r');
line_in = fgetl(myfile);
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
    line_in = fgetl(myfile);
end
fclose(myfile);


y = vhdl_vectors;