beginfig(1);
prologues := 3;
outputformat := "png";
hppp := 0.25;
vppp := 0.25;
outputtemplate := "%j.%o";
u:=50pt;
%lattice
draw (-0.5u,0)--(1.5u,0);
draw (-0.5u,1u)--(1.5u,1u);
draw (0,-0.5u)--(0,1.5u);
draw (1u,-0.5u)--(1u,1.5u);
%markpoints
pair A, B, C, D;
A:=(0,0); B:=(1u,0); C:=(0,1u); D:=(1u,1u);
%draw A withpen pencircle scaled 2bp;
dotlabel.urt("(1,2)", A);
%draw B withpen pencircle scaled 2bp;
dotlabel.urt("(2,2)", B);
%draw C withpen pencircle scaled 2bp;
dotlabel.urt("(1,1)", C);
%draw D withpen pencircle scaled 2bp;
dotlabel.urt("(2,1)", D);
endfig;

end;
