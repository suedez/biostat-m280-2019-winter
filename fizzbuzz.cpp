//fizzbuzz.cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::exprot]]
RObject rcpp_fizzbuzz(RObject v){
	CharacterVector FBmark = CharacterVector::create();
	for ( i = 1; i <= v.length(), ++i ){
		if (v[i] % 15 == 0) FBmark[i] = 'FizzBuzz';
		else if (v[i] % 3 == 0) FBmark[i] = 'Fizz';
		else if (v[i] % 5 == 0) FBmark[i] = 'Buzz';
		else FBmark[i] = v[i];
}
	return FBmark;
};
