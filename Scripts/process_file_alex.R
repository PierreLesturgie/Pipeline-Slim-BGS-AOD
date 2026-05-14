#source("computeStats.r")

source("/projects/F202500293CPCAA2/ablanckaert/computeStats.r")



args <- commandArgs(trailingOnly = TRUE)
file=args[1]
output=args[2]

#test_file=c("~/FCUL/overdominance/scripts_slim_deucalion/ms_divdel_A_h0.5_m0.00125_sr0.5_s0.1_r2.5e-8_20000_42_G10100.ms","~/FCUL/overdominance/scripts_slim_deucalion/ms_divdel_A_h0.5_m0.00125_sr0.5_s0.1_r2.5e-8_20000_42_G11000.ms","~/FCUL/overdominance/scripts_slim_deucalion/ms_divdel_A_h0.5_m0.00125_sr0.5_s0.1_r2.5e-8_20000_42_G12000.ms")

#file="~/FCUL/overdominance/scripts_slim_deucalion/ms_divdel_A_h0.5_m0.00125_sr0.5_s0.1_r2.5e-8_20000_42_G10100.ms"
#output="test_Rms_D.txt"


nInd=20
genSize=100000

#for(i in seq(1400)){
#  for(k in c(10100,11000,12000)){
#  file=paste("~/FCUL/overdominance/divdel_A_h0.5_m0.00125_sr0.5_s1_r2.5e-8_12000/ms_divdel_A_h0.5_m0.00125_sr0.5_s1_r2.5e-8_12000_",i,"_G",k,".ms",sep="")
if(file.exists(file)){
  
  param=unlist(strsplit(file, "ms_"))[2]
  param=unlist(strsplit(param,"_"))
  param=c(unlist(strsplit(param[3],"h"))[2],unlist(strsplit(param[4],"m"))[2],unlist(strsplit(param[5],"sr"))[2],unlist(strsplit(param[6],"s"))[2],unlist(strsplit(param[7],"r"))[2],param[8],param[9],unlist(strsplit(unlist(strsplit(param[10],"G"))[2],".ms"))[1])
  param=as.numeric(param)
  
  posP1=read.table(file,skip=2,nrow=1)
  hapP1=read.table(file,skip=3,nrow=nInd,colClasses = "character")
  posP2=read.table(file,skip=(5+nInd),nrow=1)
  hapP2=read.table(file,skip=(6+nInd),nrow=nInd,colClasses = "character")
  
  hapP1=sapply(seq(nInd), function(x) strsplit(hapP1$V1[x],""))
  hapP1=lapply(hapP1, as.numeric)
  hapP1=t(sapply(hapP1,c))
  
  hapP2=sapply(seq(nInd), function(x) strsplit(hapP2$V1[x],""))
  hapP2=lapply(hapP2, as.numeric)
  hapP2=t(sapply(hapP2,c))
  
  posP1=unlist(posP1[,-1])*genSize
  posP2=unlist(posP2[,-1])*genSize
  
  pos=sort(union(posP1,posP2))
  
  mapP1=sapply(posP1, function(x) which(x==pos))
  mapP2=sapply(posP2, function(x) which(x==pos))
  
  merge_hap=matrix(0,nrow=(2*nInd),ncol=length(pos))
  
  merge_hap[1:nInd,mapP1]=hapP1
  merge_hap[nInd+(1:nInd),mapP2]=hapP2
  
  Nfixed=which(colSums(merge_hap)!=(2*nInd))
  
  updated_hap=merge_hap[,Nfixed]
  if(ncol(updated_hap)>0 ){
    
    stat_whole=getMeanFst_Pi_Dxy(t(updated_hap),nInd)
    selPos=which(!(pos[Nfixed]>9999&pos[Nfixed]<90000))
    
    updated_gen=updated_hap[c(T,F),]+updated_hap[c(F,T),]
    dafi=get_dafi(t(updated_gen))
    
    if(length(selPos)>1){
      stat_Sel=getMeanFst_Pi_Dxy(t(updated_hap[,selPos]),nInd)
      stat_neu=getMeanFst_Pi_Dxy(t(updated_hap[,-selPos]),nInd)  
      dafi_sel=get_dafi(t(updated_gen[,selPos]))
      dafi_neu=get_dafi(t(updated_gen[,-selPos]))
    } else{
      stat_Sel=rep(NA,4)
      stat_neu=stat_whole
      dafi_sel=NA
      dafi_neu=dafi
    }
    
    TwoDsfs=getsfs2d(t(updated_hap),c(nInd,nInd))
    vec=c(param,stat_whole,stat_neu, stat_Sel, dafi, mean(dafi),mean(dafi_neu),mean(dafi_sel),as.vector(TwoDsfs))
  } else {
    vec=c(param,rep(NA,476))
  }
  
  
  
  #if(!file.exists(output)){
  #  colNames=c("h","m","sr","s","r","time","rep","genSample","pi_P1_w","pi_P2_w","dxy_w","fst_w","pi_P1_n","pi_P2_n","dxy_n","fst_n","pi_P1_s","pi_P2_s","dxy_s","fst_s",paste(rep("dafi_I",20),seq(20),sep="_"),"dafi_w","dafi_n","dafi_s",paste(rep("sfs",121),rep(seq(11),11),rep(seq(11),each=11),sep="_"))
  #  write.table(matrix(colNames,nrow=1),file = output,append=FALSE,col.names = FALSE,row.names = FALSE)
  #}
  write.table(matrix(vec,nrow=1),file = output,append=TRUE,col.names = FALSE,row.names = FALSE)
}
#  }
#}


#####
#test_up=read.table(output,header  = FALSE)
