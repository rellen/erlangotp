-module(my_module). % module name
% module attributes
-export([add/2, square/1, square_add/2, print_square/1]). % functions (with arity) to be exported

% function declarations

add(X,Y) ->
	X + Y.

square(X) ->
	X * X.

square_add(X,Y) ->
	Z = add(X,Y),
	square(Z).

print_square(X) ->
	io:format("The square of ~p is: ~p\n", [X, square(X)]).