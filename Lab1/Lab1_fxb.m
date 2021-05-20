%% ADAM WULFING
%% lab 1
%% EELE 468

fxp_rsqrt(fi(1, 0, 24, 15));
fxp_rsqrt(fi(4, 0, 24, 15));
fxp_rsqrt(fi(9, 0, 24, 15));
fxp_rsqrt(fi(39.119476318359375, 0, 24, 15));
fxp_rsqrt(fi(327.880615234375, 0, 24, 15));
fxp_rsqrt(fi(250.825164794921875, 0, 24, 15));
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