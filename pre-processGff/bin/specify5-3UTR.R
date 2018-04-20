library(GenomicRanges) # From Bioconductor
Args<-commandArgs(T)

genes <- read.table(Args[1], sep = '\t', skip = 5, stringsAsFactors = FALSE)
whichCodingTranscripts <- genes[, 3] == "transcript" & grepl("transcript_type protein_coding", genes[, 9], fixed = TRUE)
proteinTranscripts <- genes[whichCodingTranscripts, ]
strands <- proteinTranscripts[, 7]

allFeaturesTranscripts <- gsub("transcript_id ", '', sapply(strsplit(genes[, 9], "; "), '[', 2))
proteinTranscriptsNames <- allFeaturesTranscripts[whichCodingTranscripts]
whichCDS <- genes[, 3] == "CDS" & allFeaturesTranscripts %in% proteinTranscriptsNames
transcriptsCDS <- genes[whichCDS, ]
transcriptsCDS <- split(GRanges(transcriptsCDS[, 1], IRanges(transcriptsCDS[, 4], transcriptsCDS[, 5]), transcriptsCDS[, 7]),
                    factor(allFeaturesTranscripts[whichCDS], levels = proteinTranscriptsNames))
#firstCDS <- mapply(function(CDS, strand) {strand_value=as.list(strand(CDS))[[1]]; if(strand_value == '+') {head(CDS,n=1)} else {tail(CDS,n=1)}}, transcriptsCDS, strand(transcriptsCDS))
firstCDS <- endoapply(transcriptsCDS, function(CDS) {strand_value=as.list(strand(CDS))[[1]]; if(strand_value == '+') {head(CDS,n=1)} else {tail(CDS,n=1)}})

lastCDS <-  endoapply(transcriptsCDS, function(CDS) {strand_value=as.list(strand(CDS))[[1]]; if(strand_value == '+') {head(CDS,n=1)} else {tail(CDS,n=1)}})

whichUTR <- genes[, 3] == "UTR" & allFeaturesTranscripts %in% proteinTranscriptsNames
transcriptsUTR <- genes[whichUTR, ]
transcriptsUTR <- split(GRanges(transcriptsUTR[, 1], IRanges(transcriptsUTR[, 4], transcriptsUTR[, 5]), transcriptsUTR[, 7]),
                    factor(allFeaturesTranscripts[whichUTR], levels = names(firstCDS)))

transcriptsUTR5 <- mendoapply(function(UTR, CDS)
               { strand_value=as.list(strand(CDS))[[1]];       
                 if(strand_value == '+') UTR[UTR < CDS[1]] else UTR[UTR > CDS[length(CDS)]]
               }, transcriptsUTR, firstCDS)

transcriptsUTR3 <- mendoapply(function(UTR, CDS)
               { strand_value=as.list(strand(CDS))[[1]];       
                 if(strand_value == '+') UTR[UTR > CDS[length(CDS)]] else UTR[UTR < CDS[1]]
               }, transcriptsUTR, firstCDS)

Format <- function(UTR){
  data.frame(seqnames=as.vector(seqnames(unlist(UTR))),
  starts=start(unlist(UTR)),
  ends=end(unlist(UTR)),
  names=names(unlist(UTR)),
  strands=as.vector(strand(unlist(UTR))))}

coorsUTR5 <- Format(transcriptsUTR5)
coorsUTR3 <- Format(transcriptsUTR3)
coorsUTR5$type="5UTR"
coorsUTR3$type="3UTR"
#library(rtracklayer)
#coorsUTR5=export(Reduce(c,transcriptsUTR5),format="gff3")
UTR=rbind(coorsUTR5,coorsUTR3)
write.table(UTR,file=Args[2],quote=F, row.names=F, col.names=F,sep="\t")



