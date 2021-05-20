%%%Adam Wulfing
x = fi(.03125, 0, 16, 8)
w = x.WordLength
f =x.FractionLength;
z = 0;
i =1;
x.bin

%%
while x.bin(i) ~= '1'
    z=z+1;
    i=i+1;
end
fprintf("#1\n")
z

%%
fprintf("#2\n")
beta = fi((w-f-z-1),1,w, f);
beta.data

%%
%shifting
fprintf("#3\n")
alpha = (-bitsll(beta,1))+ bitsra(beta,1) +.5

%%
fprintf("#4\n")
xa = bitsll(x,alpha)
xa.bin

%%
fprintf("#5\n")
xb = bitsll(x,-beta)
xb.bin

%%
fprintf("#6\n")
xb = xb.data^(-3/2)

%%
fprintf("#7\n")
y = (xa)*(xb)*2^(-1/2)
c = double(y.data)

