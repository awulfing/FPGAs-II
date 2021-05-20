clear all
close all

H = 100;
Component_latency = 25;
WIDTH = 24;
FRACT = 15;
SIGN = 0;

%read files
myfile = fopen('input.txt','r');
line_in = fgetl(myfile);
a = fi(0,SIGN,WIDTH,FRACT);
index = 1;
while ischar(line_in)
    a.bin = line_in;
    my_test_vectors(index) = a;
    disp([num2str(index) ' : ' line_in ' = ' num2str(a)])
    index = index + 1;
    line_in = fgetl(myfile);
end
fclose(myfile);
%Find the actual sqrt of the input
for i=1:H
    input = my_test_vectors(i);
    mVect(i) = 1/(sqrt(input));
end

%Read in the zeroth interation output
vVect0 = readoutput('Output0.txt',SIGN,WIDTH,FRACT);
vVect1 = readoutput('Output1.txt',SIGN,WIDTH,FRACT);
vVect2 = readoutput('Output2.txt',SIGN,WIDTH,FRACT);
vVect3 = readoutput('Output3.txt',SIGN,WIDTH,FRACT);
vVect4 = readoutput('Output4.txt',SIGN,WIDTH,FRACT);
vVect5 = readoutput('Output5.txt',SIGN,WIDTH,FRACT);

disp('Error perctange')
%Find error between matlab vs vhdl zero iterations
error = error_function(mVect,vVect0,H);
error1 = error_function(mVect,vVect1,H);
error2 = error_function(mVect,vVect2,H);
error3 = error_function(mVect,vVect3,H);
error4 = error_function(mVect,vVect4,H);
error5 = error_function(mVect,vVect5,H);


%------------------------------------------------------------------------
disp('Matlab actual data')
mVect.data

disp('-----------------------------------------------------------------')
disp('Y0')
vVect0.data
disp('Possible Error')
error.data


disp('-----------------------------------------------------------------')
disp('Iteration 1')
vVect1.data
disp('Error Percantage')
error1.data


disp('-----------------------------------------------------------------')
disp('Iteration 2')
vVect2.data
disp('Possible Error')
error2.data

disp('-----------------------------------------------------------------')
disp('Iteration 3')
vVect3.data
disp('Possible Error')
error3.data

disp('-----------------------------------------------------------------')
disp('Iteration 4')
vVect4.data
disp('Possible Error')
error4.data


disp('-----------------------------------------------------------------')
disp('Iteration 5')
vVect5.data
disp('Possible Error')
error5.data

plot(0,error.double,'o');
title('Percent error per Iteration')
xlabel('N iteration')
ylabel('Error')
hold on
plot(1,error1.double,'o');
plot(2,error2.double,'o');
plot(3,error3.double,'o');
plot(4,error4.double,'o');
plot(5,error5.double,'o');
hold off