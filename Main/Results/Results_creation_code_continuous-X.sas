LIBNAME results "C:\Users\michael.webster\Documents\Variable_selection_external_validity\Simulation_results_continuous_X";

%macro resultsrun(name=,num=);

PROC MEANS DATA=results.&name NOPRINT;
	WHERE parameter="X";
	VAR estimate;
	OUTPUT OUT=meanstddev&name. MEAN=mean stddev=stddev;
RUN;

DATA meanstddev&name.;
	SET meanstddev&name.;
	name = "&name";
	num=&num;
	expmean=exp(mean);
RUN;
/*
ods graphics off;
ods exclude all;
ods noresults;

PROC UNIVARIATE DATA=results.&name;
	WHERE parameter="X";
	VAR estimate;
	OUTPUT OUT=pcts pctlpre=P_ pctlpts=2.5 97.5;
RUN;

ods graphics on;
ods exclude none;
ods results;

PROC PRINT DATA=pcts;
RUN;
*/
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

%resultsrun(name=crude,num=13);
%resultsrun(name=ioswZ6Z7,num=14);
%resultsrun(name=ioswZ1Z6Z7,num=15);
%resultsrun(name=ioswZ2Z6Z7,num=16);
%resultsrun(name=ioswZ3Z6Z7,num=17);
%resultsrun(name=ioswZ4Z6Z7,num=18);
%resultsrun(name=ioswZ5Z6Z7,num=19);

DATA allval;
	LENGTH Name $ 10;
	SET meanstddev: ;
	BY num;
RUN;

PROC PRINT DATA=allval;
	VAR name expmean stddev;
RUN;
