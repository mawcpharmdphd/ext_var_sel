LIBNAME results "C:\Users\michael.webster\Documents\Variable_selection_external_validity\Simulation_results_bigger_target";

%macro resultsrun(name=,num=);

PROC SORT DATA=results.&name NODUPKEY;
	BY replicate;
	WHERE parameter="X";
RUN;

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
%resultsrun(name=ioswZ6,num=2);
%resultsrun(name=ioswZ1Z6,num=3);
%resultsrun(name=ioswZ2Z6,num=4);
%resultsrun(name=ioswZ3Z6,num=5);
%resultsrun(name=ioswZ4Z6,num=6);
%resultsrun(name=ioswZ5Z6,num=7);


%resultsrun(name=ioswZ1,num=8);
%resultsrun(name=ioswZ2,num=9);
%resultsrun(name=ioswZ3,num=10);
%resultsrun(name=ioswZ4,num=11);
%resultsrun(name=ioswZ5,num=12);

DATA combineall;
	LENGTH alpha $20.;
	RETAIN refstddev refstddevcrude;
	SET vals: ;
	BY num;
	IF dataname="ioswZ6" THEN refstddev=stddevval;
	ELSE IF dataname="crude" THEN refstddevcrude=stddevval;
	ELSE IF (num=3 OR num=4 OR num=5 OR num=6 OR num=7) THEN relstddev = stddevval / refstddev;
	ELSE relstddev = stddevval/refstddevcrude;
	LCL = meanval - 1.96*stddevval;
	UCL = meanval + 1.96*stddevval;
	IF num=1 THEN alpha = "None";
	IF num=2 THEN alpha = "Z6 only";
	IF num=3 THEN alpha = "Z6+Z1";
	IF num=4 THEN alpha = "Z6+Z2";
	IF num=5 THEN alpha = "Z6+Z3";
	IF num=6 THEN alpha = "Z6+Z4";
	IF num=7 THEN alpha = "Z6+Z5";
	IF num=8 THEN alpha = "Z1 only";
	IF num=9 THEN alpha = "Z2 only";
	IF num=10 THEN alpha = "Z3 only";
	IF num=11 THEN alpha = "Z4 only";
	IF num=12 THEN alpha = "Z5 only";
RUN;



PROC SORT DATA=combineall;
	BY descending num;
RUN;

PROC PRINT DATA=combineall;
	VAR dataname meanval stddevval relstddev;
RUN;

ODS GRAPHICS ON / width=1200PX height=300PX noborder;

PROC SGPLOT DATA=combineall;
	WHERE num > 1 AND num < 8;
	SCATTER Y=alpha X=meanval / xerrorlower=LCL xerrorupper=UCL markerattrs=(symbol=squarefilled size=18 color=red) errorbarattrs=(color=black);
	YAXIS LABEL="Variables" TYPE=discrete DISCRETEORDER=DATA LABELATTRS=(family=Calibri size=22pt) valueattrs=(family=Calibri size=18pt);
	XAXIS LABEL="Estimated RD and 95% CI" LABELATTRS=(family=Calibri size=22pt) valueattrs=(family=Calibri size=18pt);
	REFLINE 0.230 / axis=X lineattrs=(pattern=dash color=black thickness=8);
	
RUN;

PROC SGPLOT DATA=combineall;
	WHERE num < 2 OR num > 7;
	SCATTER Y=alpha X=meanval / xerrorlower=LCL xerrorupper=UCL markerattrs=(symbol=squarefilled size=18 color=red) errorbarattrs=(color=black);
	YAXIS LABEL="Variables" TYPE=discrete DISCRETEORDER=DATA LABELATTRS=(family=Calibri size=22pt) valueattrs=(family=Calibri size=18pt);
	XAXIS MIN=0.12 MAX=0.25 LABEL="Estimated RD and 95% CI" LABELATTRS=(family=Calibri size=22pt) valueattrs=(family=Calibri size=18pt);
	REFLINE 0.230 / axis=X lineattrs=(pattern=dash color=black thickness=8);
	
RUN;
