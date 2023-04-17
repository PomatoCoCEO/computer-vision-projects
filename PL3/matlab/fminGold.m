function f = fminGold(p, xy, XYZ)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

sq_error = sqError(xy, XYZ, P);


%compute cost function value
f = sq_error;
end