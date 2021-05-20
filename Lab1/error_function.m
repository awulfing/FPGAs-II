function y = error_function(matlab_vectors,vhdl_vectors,Nv)
for i=1:Nv-34
    error(i) = ((matlab_vectors(i) - vhdl_vectors(i))/ matlab_vectors(i))*100;
     
end
y = error;