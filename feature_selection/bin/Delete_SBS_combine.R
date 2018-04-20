#Args <-commandArgs(TRUE);
#inputF1= Args[1];#input example.train.mx ; first column is bin second is label, seperated by tab, with header;
#inputF2= Args[2];#input the cv.idx, no header;
#inputF3= Args[3];#input CV fold;
#inputF4= Args[4];#the base feature file; no header;one column; contains only features name
#inputF5= Args[5];#the deleting feature file; no header;tow columns; first is feature names; second is the rank. features with the same rank will be delete together


delta=-0.01;
my_qsub<-function(inputF1,inputF2,inputF3,inputF4,outputF,qsubF,logF){
str=paste("#$ -S /bin/bash\n#$ -cwd\n#$ -j y\n#$ -q q1.* \n#$ -N SBS_c\nRscript","/home/hulong/module/feature_selection/bin/cv.test.R",inputF1,inputF2,inputF3,inputF4,outputF)
write(str,file=qsubF);
system(paste("rm",outputF));
system(paste("rm",logF));
system(paste("qsub -V -o",logF,qsubF));
}
my_check<-function(file_path,FileList){
        while(1==1){
                filelist_all=list.files(path=file_path,full.names=T);
		tmp=is.element(FileList,filelist_all);
                if(all(tmp)){break;}
		Sys.sleep(30);
        }
}
########	calculate the base feature set performance.
ROLL=0;
featF=inputF4;
qsubF=paste("./qsub/qsub_del",ROLL,sep=".");
logF= paste("./log/log_del",ROLL,sep=".");
perfF=paste("./perf/perf_del",ROLL,sep=".");
my_qsub(inputF1,inputF2,inputF3,featF,perfF,qsubF,logF);
file_path="./perf";
my_check(file_path,perfF);
Sys.sleep(2);
tmp=as.vector(as.matrix(read.table(perfF,sep="\t",head=F)))
all.acc=tmp[1];
print(paste("base feature set's performance is: ",all.acc));
print("start deleting features............................");
best_performance=	all.acc;
baseFeat	=	as.vector(as.matrix(read.table(inputF4,sep="\t",head=F)));


RANK            =       read.table(inputF5,head=F,sep="\t");
RANK_groups     =       RANK[,2];
RANK_group      =       as.vector(unique(RANK_groups));
deleFeat	=       as.vector(RANK[,1]);
RANK_group_0	=	RANK_group;

for (ROLL in 1:length(RANK_group_0)){
	bad_rank	=	c();
	bad_feature	=	c();
	BP		=	c();
	FileList	=	c();
	for (j in sort(RANK_group,decreasing=T)){
		DeleFeat	=	deleFeat[which(RANK_groups==j)];
		remain_features_tmp	=	setdiff(baseFeat,DeleFeat);
		print(paste("deleting this feature now: ",paste(DeleFeat,collapse="  "),sep=""));
		featF		=	paste("./feat/baseF",ROLL,j,sep=".");
		qsubF		=	paste("./qsub/qsub_del",ROLL,j,sep=".");
		logF		=	paste("./log/log_del",ROLL,j,sep=".");
		perfF		=	paste("./perf/perf_del",ROLL,j,sep=".");
		write.table(remain_features_tmp,file=featF,quote=F,sep="\t",col.name=F,row.name=F);
		my_qsub(inputF1,inputF2,inputF3,featF,perfF,qsubF,logF);
		FileList	=	c(FileList,perfF);
	}
	my_check(file_path,FileList);Sys.sleep(2);
	for (j in sort(RANK_group,decreasing=T)){
		perfF		=	paste("./perf/perf_del",ROLL,j,sep=".");
		Perf		=	as.vector(as.matrix(read.table(perfF,head=F,sep="\t")));
		MYPERFORMANCE	=	c(Perf[1]);
		names(MYPERFORMANCE)	=	j;
		print(paste("performance summary of three trial is: ",MYPERFORMANCE,sep=""));
                BP		=	c(BP,MYPERFORMANCE);
	}
        BPB	=	max(BP,na.rm=T);
        if(best_performance<(BPB-delta)){
		best_performance	=	BPB;
                bad_rank		=	sort(RANK_group,decreasing=T)[(which(BP==BPB)[1])];
		bad_feature		=	deleFeat[which(RANK_groups==bad_rank)];
        }
        if (length(bad_feature)==0){
                print("no bad feature can be deleted, break here");break;
        }else if(length(baseFeat)<=5){
                print("less than five features");break;
        }else{
                print(paste("find the bad feature: ",paste(bad_feature,collapse="  "),sep=""));
                print(paste("the best performance is now: ",best_performance,sep=""));
                baseFeat		=	setdiff(baseFeat,bad_feature);
		ID			=	which(!(is.element(RANK[,2],bad_rank)));
		RANK			=	RANK[ID,];
		RANK_groups		=	RANK[,2];
		RANK_group		=	as.vector(unique(RANK_groups));
		deleFeat		=	as.vector(RANK[,1]);
                print(paste("now the good features are:  ",paste(baseFeat,collapse="  "),sep=""));
        }
}
write.table(baseFeat,file=paste("./summary/bestFeat",sep="."),quote=F,col.name=F,row.name=F,sep="\t");
write.table(best_performance,file=paste("./summary/bestPerf",sep="."),quote=F,col.name=F,row.name=F,sep="\t")

rm(list=ls());

