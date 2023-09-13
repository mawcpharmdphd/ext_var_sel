LIBNAME results "C:\Users\michael.webster\Documents\Variable_selection_external_validity\Simulation_results_continuous_Z";

%macro simulate(repstart=,repend=,seed=);

%DO icon=&repstart %TO &repend;

DATA fulldata;
	replicate = &icon;
	CALL streaminit(&icon+&seed);
	DO i=1 to 10000;
		intrial = 1;

		Z1=RAND('NORMAL',0,0.25);
		Z2=RAND('NORMAL',0,0.25);
		Z3=RAND('NORMAL',0,0.25);

		Z4=RAND('NORMAL',-0.25,0.25);
		Z5=RAND('NORMAL',-0.25,0.25);
		Z6=RAND('NORMAL',-0.25,0.25);

		X=RAND('BERNOULLI',0.5);

		PY=0.25 + 0.05*X + 0.05*Z2 + 0.05*Z3 + 0.05*Z5 + 0.05*Z6 + 0.05*X*Z3 + 0.05*X*Z6;
		Y=RAND('BERNOULLI',PY);
	
		OUTPUT;
	END;
	DO i=1 to 10000;
		intrial = 0;

		X=RAND('BERNOULLI',0.5);

		Z1=RAND('NORMAL',0,0.25);
		Z2=RAND('NORMAL',0,0.25);
		Z3=RAND('NORMAL',0,0.25);

		Z4=RAND('NORMAL',0,0.25);
		Z5=RAND('NORMAL',0,0.25);
		Z6=RAND('NORMAL',0,0.25);

		PY=0.25 + 0.05*X + 0.05*Z2 + 0.05*Z3 + 0.05*Z5 + 0.05*Z6 + 0.05*X*Z3 + 0.05*X*Z6;
		Y=RAND('BERNOULLI',PY);
	
		OUTPUT;
	END;
RUN;

ods graphics off;
ods exclude all;
ods noresults;

PROC GENMOD DATA=fulldata DESCENDING;
	BY replicate;
	MODEL intrial = Z6 / link=logit dist=binomial;
	OUTPUT OUT=predvals pred=predZ6;
RUN;

PROC GENMOD DATA=predvals DESCENDING;
	BY replicate;
	MODEL intrial = Z1 Z6 Z1*Z6 / link=logit dist=binomial;
	OUTPUT OUT=predvals2 pred=predZ1Z6;
RUN;

PROC GENMOD DATA=predvals2 DESCENDING;
	BY replicate;
	MODEL intrial = Z2 Z6 Z2*Z6 / link=logit dist=binomial;
	OUTPUT OUT=predvals3 pred=predZ2Z6;
RUN;

PROC GENMOD DATA=predvals3 DESCENDING;
	BY replicate;
	MODEL intrial = Z3 Z6 Z3*Z6 / link=logit dist=binomial;
	OUTPUT OUT=predvals4 pred=predZ3Z6;
RUN;

PROC GENMOD DATA=predvals4 DESCENDING;
	BY replicate;
	MODEL intrial = Z4 Z6 Z4*Z6 / link=logit dist=binomial;
	OUTPUT OUT=predvals5 pred=predZ4Z6;
RUN;

PROC GENMOD DATA=predvals5 DESCENDING;
	BY replicate;
	MODEL intrial = Z5 Z6 Z5*Z6 / link=logit dist=binomial;
	OUTPUT OUT=predvals6 pred=predZ5Z6;
RUN;


PROC GENMOD DATA=predvals6 DESCENDING;
	BY replicate;
	MODEL intrial = Z1 / link=logit dist=binomial;
	OUTPUT OUT=predvals8 pred=predZ1;
RUN;

PROC GENMOD DATA=predvals8 DESCENDING;
	BY replicate;
	MODEL intrial = Z2 / link=logit dist=binomial;
	OUTPUT OUT=predvals9 pred=predZ2;
RUN;

PROC GENMOD DATA=predvals9 DESCENDING;
	BY replicate;
	MODEL intrial = Z3 / link=logit dist=binomial;
	OUTPUT OUT=predvals10 pred=predZ3;
RUN;

PROC GENMOD DATA=predvals10 DESCENDING;
	BY replicate;
	MODEL intrial = Z4 / link=logit dist=binomial;
	OUTPUT OUT=predvals11 pred=predZ4;
RUN;

PROC GENMOD DATA=predvals11 DESCENDING;
	BY replicate;
	MODEL intrial = Z5 / link=logit dist=binomial;
	OUTPUT OUT=predvals12 pred=predZ5;
RUN;


DATA makeweights;
	SET predvals12;
	WHERE intrial=1;
	IOSWZ1=1/(predZ1/(1-predZ1));
	IOSWZ2=1/(predZ2/(1-predZ2));
	IOSWZ3=1/(predZ3/(1-predZ3));
	IOSWZ4=1/(predZ4/(1-predZ4));
	IOSWZ5=1/(predZ5/(1-predZ5));
	IOSWZ6=1/(predZ6/(1-predZ6));
	IOSWZ1Z6=1/(predZ1Z6/(1-predZ1Z6));
	IOSWZ2Z6=1/(predZ2Z6/(1-predZ2Z6));
	IOSWZ3Z6=1/(predZ3Z6/(1-predZ3Z6));
	IOSWZ4Z6=1/(predZ4Z6/(1-predZ4Z6));
	IOSWZ5Z6=1/(predZ5Z6/(1-predZ5Z6));
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	ODS OUTPUT parameterestimates=crude;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ1;
	ODS OUTPUT parameterestimates=ioswZ1;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ2;
	ODS OUTPUT parameterestimates=ioswZ2;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ3;
	ODS OUTPUT parameterestimates=ioswZ3;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ4;
	ODS OUTPUT parameterestimates=ioswZ4;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ5;
	ODS OUTPUT parameterestimates=ioswZ5;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ6;
	ODS OUTPUT parameterestimates=ioswZ6;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ1Z6;
	ODS OUTPUT parameterestimates=ioswZ1Z6;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ2Z6;
	ODS OUTPUT parameterestimates=ioswZ2Z6;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ3Z6;
	ODS OUTPUT parameterestimates=ioswZ3Z6;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ4Z6;
	ODS OUTPUT parameterestimates=ioswZ4Z6;
RUN;

PROC GENMOD DATA=makeweights DESCENDING;
	BY replicate;
	MODEL Y=X / link=identity dist=binomial;
	WEIGHT IOSWZ5Z6;
	ODS OUTPUT parameterestimates=ioswZ5Z6;
RUN;

PROC DATASETS library = results nolist;
	append base=results.crude data=work.crude;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ1 data=work.ioswZ1;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ2 data=work.ioswZ2;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ3 data=work.ioswZ3;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ4 data=work.ioswZ4;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ5 data=work.ioswZ5;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ6 data=work.ioswZ6;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ1Z6 data=work.ioswZ1Z6;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ2Z6 data=work.ioswZ2Z6;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ3Z6 data=work.ioswZ3Z6;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ4Z6 data=work.ioswZ4Z6;
QUIT;

PROC DATASETS library = results nolist;
	append base=results.ioswZ5Z6 data=work.ioswZ5Z6;
QUIT;

%END;

ods graphics on;
ods exclude none;
ods results;

%mend;

OPTIONS NONOTES NOSOURCE;


%simulate(repstart=11,repend=20000,seed=10);
