//fizzbuzz.cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
  DataFrame rcpp_fizzbuzz(RObject x){
  Function f("validateINPUT");
  NumericVector  v = f(x);
  CharacterVector FBmark(v.length());
	for (int i = 0; i< v.length(); ++i ){
	  int a = v[i];
		if (a % 15 == 0) {
		FBmark[i] = "FizzBuzz";
		}else if (a % 3 == 0){
		FBmark[i] = "Fizz";
		}else if (a % 5 == 0) {
		FBmark[i] = "Buzz";
		}else{
		FBmark[i] = a;
		  }
	}
	DataFrame FBdf = DataFrame::create( Named("Input") = v, Named("FizzBuzz mark") = FBmark );
  return FBdf;
};
