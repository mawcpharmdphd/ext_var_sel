LIBNAME results "C:\Users\michael.webster\Documents\Variable_selection_external_validity\G_form_results";

%macro simulate(repstart=,repend=,seed=);

%DO icon=&repstart %TO &repend;

DATA fulldata;
	replicate = &icon;
	CALL streaminit(&icon+&seed);
	DO i=1 to 10000;
		intrial = 1;

		Z1=RAND('BERNOULLI',0.5);
		Z2=RAND('BERNOULLI',0.5);
		Z3=RAND('BERNOULLI',0.5);
		Z4=RAND('BERNOULLI',0.2);
		Z5=RAND('BERNOULLI',0.2);
		Z6=RAND('BERNOULLI',0.2);

		X=RAND('BERNOULLI',0.5);

		PY=0.1 + 0.1*X + 0.1*Z2 + 0.1*Z3 + 0.1*Z5 + 0.1*Z6 + 0.1*X*Z3 + 0.1*X*Z6;
		Y=RAND('BERNOULLI',PY);
	
		OUTPUT;
	END;
	DO i=1 to 10000;
		intrial = 0;

		X=RAND('BERNOULLI',0.5);

		Z1=RAND('BERNOULLI',0.5);
		Z2=RAND('BERNOULLI',0.5);
		Z3=RAND('BERNOULLI',0.5);
		Z4=RAND('BERNOULLI',0.8);
		Z5=RAND('BERNOULLI',0.8);
		Z6=RAND('BERNOULLI',0.8);

		PY=0.1 + 0.1*X + 0.1*Z2 + 0.1*Z3 + 0.1*Z5 + 0.1*Z6 + 0.1*X*Z3 + 0.1*X*Z6;
		Y=RAND('BERNOULLI',PY);
	
		OUTPUT;
	END;
RUN;

ods graphics off;
ods exclude all;
ods noresults;

DATA fulldataX;
	SET fulldata;
	IF intrial = 1 THEN OUTPUT;
	ELSE IF intrial = 0 THEN DO;
		Y=.;
		X=1;
		OUTPUT;
		OUTPUT;
		OUTPUT;
		OUTPUT;
		OUTPUT;
		X=0;
		OUTPUT;
		OUTPUT;
		OUTPUT;
		OUTPUT;
		OUTPUT;
	END;
RUN;

PROC SORT DATA=fulldataX;
	BY replicate X;
RUN;

PROC GENMOD DATA=fulldataX DESCENDING;
	BY replicate X;
	MODEL Y= / link=identity dist=binomial;
	OUTPUT OUT=predvals pred=predcrude;
RUN;
/*
PROC GENMOD DATA=fulldataX DESCENDING;
	BY replicate X;
	MODEL Y=Z6 / link=identity dist=binomial;
	OUTPUT OUT=predvals pred=predZ6;
RUN;

PROC GENMOD DATA=predvals DESCENDING;
	BY replicate X;
	MODEL Y=Z1 Z6 / link=identity dist=binomial;
	OUTPUT OUT=predvals2 pred=predZ1Z6;
RUN;

PROC GENMOD DATA=predvals2 DESCENDING;
	BY replicate X;
	MODEL Y=Z2 Z6 / link=identity dist=binomial;
	OUTPUT OUT=predvals3 pred=predZ2Z6;
RUN;

PROC GENMOD DATA=predvals3 DESCENDING;
	BY replicate X;
	MODEL Y=Z3 Z6 / link=identity dist=binomial;
	OUTPUT OUT=predvals4 pred=predZ3Z6;
RUN;


PROC GENMOD DATA=predvals4 DESCENDING;
	BY replicate X;
	MODEL Y=Z4 Z6 / link=identity dist=binomial;
	OUTPUT OUT=predvals5 pred=predZ4Z6;
RUN;

PROC GENMOD DATA=predvals5 DESCENDING;
	BY replicate X;
	MODEL Y=Z5 Z6 / link=identity dist=binomial;
	OUTPUT OUT=predvals6 pred=predZ5Z6;
RUN;

PROC GENMOD DATA=predvals6 DESCENDING;
	BY replicate X;
	MODEL Y=Z1 / link=identity dist=binomial;
	OUTPUT OUT=predvals7 pred=predZ1;
RUN;

PROC GENMOD DATA=predvals7 DESCENDING;
	BY replicate X;
	MODEL Y=Z2 / link=identity dist=binomial;
	OUTPUT OUT=predvals8 pred=predZ2;
RUN;

PROC GENMOD DATA=predvals8 DESCENDING;
	BY replicate X;
	MODEL Y=Z3 / link=identity dist=binomial;
	OUTPUT OUT=predvals9 pred=predZ3;
RUN;

PROC GENMOD DATA=predvals9 DESCENDING;
	BY replicate X;
	MODEL Y=Z4 / link=identity dist=binomial;
	OUTPUT OUT=predvals11 pred=predZ4;
RUN;

PROC GENMOD DATA=predvals11 DESCENDING;
	BY replicate X;
	MODEL Y=Z5 / link=identity dist=binomial;
	OUTPUT OUT=predvals12 pred=predZ5;
RUN;
*/
DATA makeouts;
	SET predvals;
	WHERE intrial=0;
	Ycrude=RAND('BERNOULLI',predcrude);
RUN;

%macro analyzeG(model=);

PROC GENMOD DATA=makeouts DESCENDING;
	BY replicate;
	WHERE intrial=0;
	MODEL Y&model = X / link=identity dist=binomial;
	ODS OUTPUT parameterestimates=g&model.;
RUN;

PROC DATASETS library = results nolist;
	append base=results.g&model. data=work.g&model.;
QUIT;


%mend;

%analyzeG(model=crude);
%END;

ods graphics on;
ods exclude none;
ods results;

%mend;

OPTIONS NONOTES NOSOURCE;


%simulate(repstart=11,repend=20000,seed=12233);
