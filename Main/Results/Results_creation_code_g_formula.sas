LIBNAME results "C:\Users\michael.webster\Documents\Variable_selection_external_validity\g_form_results";

%macro resultsrun(name=,num=);

PROC MEANS DATA=results.&name NOPRINT;
	WHERE parameter="X";
	VAR estimate;
	OUTPUT OUT=vals&name. mean=meanval stddev=stddevval;
RUN;

DATA vals&name.;
	LENGTH Dataname $ 10.;
	SET vals&name.;
	num=&num;
	Dataname="&name";
RUN;


%mend;

%resultsrun(name=crude,num=1);
%resultsrun(name=gZ6,num=2);
%resultsrun(name=gZ1Z6,num=3);
%resultsrun(name=gZ2Z6,num=4);
%resultsrun(name=gZ3Z6,num=5);
%resultsrun(name=gZ4Z6,num=6);
%resultsrun(name=gZ5Z6,num=7);


%resultsrun(name=gZ1,num=8);
%resultsrun(name=gZ2,num=9);
%resultsrun(name=gZ3,num=10);
%resultsrun(name=gZ4,num=11);
%resultsrun(name=gZ5,num=12);

DATA combineall;
	RETAIN refstddev refstddevcrude;
	SET vals: ;
	BY num;
	IF dataname="gZ6" THEN refstddev=stddevval;
	ELSE IF dataname="crude" THEN refstddevcrude=stddevval;
	ELSE IF (num=3 OR num=4 OR num=5 OR num=6 OR num=7) THEN relstddev = stddevval / refstddev;
	ELSE relstddev = stddevval/refstddevcrude;
RUN;




PROC PRINT DATA=combineall;
	VAR dataname meanval stddevval relstddev;
RUN;
