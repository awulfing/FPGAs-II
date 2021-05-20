%% ADAM WULFING
%% Homework 2
%% EELE 368
fxp_rsqrt(fi(124, 0, 12, 4));
fxp_rsqrt(fi(5.5, 0, 16, 8));
fxp_rsqrt(fi(12, 0, 16, 8));
fxp_rsqrt(fi(0.368, 0, 16, 8));
fxp_rsqrt(fi(0.25, 0, 16, 8));
fxp_rsqrt(fi(0.420, 0, 16,8));

function y = fxp_rsqrt(x)
    w=x.WordLength;
    f=x.FractionLength;
    Fm = fimath('RoundingMethod','Floor','OverflowAction','Wrap','ProductMode','SpecifyPrecision','ProductWordLength',w,'ProductFractionLength',f,'SumMode','SpecifyPrecision','SumWordLength',w,'SumFractionLength',f);
    x = fi(x.data,0,w,f,Fm)
    z=0;
    i=1;
    x.dec
    x.bin
    x.hex
    while x.bin(i) ~= '1'
        z=z+1;
        i=i+1;
    end

    %%
    fprintf("#1 \n")
    z
    
    %%
    fprintf("#2 \n")
    b = fi((w-f-z-1), 1, w, f, Fm)
    j = mod(b.data,2);
    b.dec
    b.bin
    b.hex
    
    %%
    
    if j~=0
        fprintf("odd\n")
        fprintf("# 3\n")
        a = -bitsll(b,1) + bitsra(b,1) + 0.5
    else
        fprintf("even\n")
        fprintf("#3 \n")
        a = -bitsll(b,1) + bitsra(b,1)
    end
    
    a.dec
    a.bin
    a.hex
    %%
    fprintf("#4 \n")
    
    if a.data < 0
        xa = bitsra(x,-a);
    else
        xa = bitsll(x,a);
    end
    
    xa.dec
    xa.bin
    xa.hex
    
    %%
    fprintf("#5 \n")
    
    if a.data < 0
        xb = bitsra(x,b);
    else
        xb = bitsll(x,-b);
    end
    xb.dec
    xb.bin
    xb.hex
    
    %%
    fprintf("#6 \n")
    x_b_d = double(xb)^(-3/2)
    xb = fi(x_b_d, 0, w, f, Fm)
    xb.dec
    xb.bin
    xb.hex
    
    %%
    fprintf("#7 \n")
    y = xa*(xb)*2^(-1/2)
    ydb = 1/sqrt(double(x.data))
    %%yeaaaaaaaaaaaaaaaaaaaaa
end