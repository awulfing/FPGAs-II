function z = my_fxpt_function2(x,a,rom)
% Input x is assumed to be a fixted-point object
% The function computes the same result as my_component.vhd

W1 = x.WordLength;
F1 = x.FractionLength;
W2 = 28;
F2 = 27;
%--------------------------------
% ROM lookup
%--------------------------------
f = fi(0,0,W2,F2);
for i=1:length(a)
    address = int32(a(i));
    bit_string = rom{address+1}.output_bits;
    f.bin = bit_string;
    v1(i) = f;
end

%--------------------------------
% ROM latency = 2
%--------------------------------
f = fi(0,0,W2,F2);
rom_values = [f f v1];  % align vectors


%--------------------------------
% input latency 
%--------------------------------
f = fi(0,0,W1,F1);
delayed_input = [f f f x];  % align vectors


for i=1:length(x)    
    m1 = delayed_input(i);
    m2 = rom_values(i);
    result = m1 * m2;
    %my_output <= my_result(MY_WORD_W + MY_ROM_Q_F - 1 downto MY_ROM_Q_F);
    result_bit_string = result.bin;
    right_trim_length = F2;
    left_trim_length = W2-F2;
    result_bit_string(1:left_trim_length) = [];
    result_bit_string(end-F2+1:end) = [];
    f.bin = result_bit_string;
    output = f;
    disp(['i = ' num2str(i) '  ---------------------------------'])
    disp(['delayed_input = ' m1.hex ' = ' m1.bin ' = ' num2str(m1)])
    disp(['rom_value     = ' m2.hex ' = ' m2.bin ' = ' num2str(m2)])
    disp(['result        = ' result.hex ' = ' result.bin ' = ' num2str(result)])
    disp(['result        = ' output.hex ' = ' output.bin ' = ' num2str(output)])
    v2(i) = result;
    z(i)  = output;
end



% 
% return
% 
% % set fimath property to perform computations similar to VHDL code
% Fm = fimath('RoundingMethod' ,'Floor',...
%     'OverflowAction'         ,'Wrap',...
%     'ProductMode'            ,'SpecifyPrecision',...
%     'ProductWordLength'      ,W,...
%     'ProductFractionLength'  ,F,...
%     'SumMode'                ,'SpecifyPrecision',...
%     'SumWordLength'          ,W,...
%     'SumFractionLength'      ,F);
% 
% x.fimath = Fm;  % set the fimath properties for x
% 
% z = x + 1; % perform the computation

end

