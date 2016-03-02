library(FSelector)


################################# Feature Selection #########################################

featCor <- cor(ForModel[,-ncol(ForModel)],ForModel[,ncol(ForModel)])
featCor.sorted <- as.matrix(featCor[order(-featCor),])
featurePlot(ForModel[,row.names(featCor.sorted)[1:5]],ForModel[,ncol(ForModel)])
