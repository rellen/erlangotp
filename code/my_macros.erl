-module(my_macros).

-compile(export_all).

-define(PI, 3.14).

-define(Mul(X,Y),X*Y).

circ (D) ->
	?Mul(D, ?PI).