require(dummies)

toBool <- function(df,skips = NULL){
  if(is.null(skips)){
  dfout <- data.frame(id = 1:nrow(df))
  }else {
    dfout <- data.frame(df[,skips])
    names(dfout) <- skips}

  for(name in names(df)[!(names(df) %in% skips)]){
    if (is.factor(df[, name])){
      dfout <- data.frame(dfout,dummy(name,df))
    }else {
      dfout[,name] <- df[, name]
    }
  }
  return(dfout)
}

rmclmn<- function(df, clmns){
  return(df[,!(names(df) %in% clmns)])
}

prepData <- function(input, cora.aggr) {
  TrnData <- merge(input, cora.aggr, by.x = "CoraDist", by.y = "District")
  ForModel <- as.matrix(rmclmn(TrnData, c("CoraDist", "PRODUCTGROUP.Level1")))
  row.names(ForModel) <- TrnData$CoraDist
  ForModel[is.nan(ForModel)]<-0
  ForModel[is.na(ForModel)]<-0
  return(ForModel)
}

equalFreqBin <- function(col,nbins){
  ordCol <- col[order(col)]
  chunkSize <- floor(length(col)/nbins)
  intervals <- cut(col,c(0,ordCol[(1:(nbins-1)-1)*chunkSize],ifelse(length(col)%%nbins != 0,max(col),ordCol[nbins*chunkSize])))
  return(intervals)
}
equalFreqBin(ForModel[,"Sales..Rs."],7)
