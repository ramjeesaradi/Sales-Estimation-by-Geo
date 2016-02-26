library(h2o)
h2o.shutdown()
h2oklocal <- h2o.init(max_mem_size = "4g",min_mem_size = "2g")

spl <- createDataPartition(ForModel[,ncol(ForModel)],p = 0.8, list = F )
h2odata <- as.h2o(ForModel[spl,],destination_frame = "dat")
h2odatest <- as.h2o(ForModel[-spl,])
################################# Linear Regression Modeling ################################
# lr.models <- lapply(unique(cora.aggr$PRODUCTGROUP.Level1),
#                     function (x) {
#                       lm(Sales..Rs.~.,as.data.frame(dta.model[[x]]))
#                     })
# names(lr.models) <- unique(cora.aggr$PRODUCTGROUP.Level1)

lr.model <- lm(Sales..Rs.~.,as.data.frame(ForModel[spl,]))
attach(lr.model)
coefficients
residuals
################################ DeepLearning Modeling #####################################
dplmod <- h2o.deeplearning(1:(ncol(ForModel)-1),ncol(ForModel),h2odata,
                           #hidden = c(800,150,150),
                           epochs = 10e+100,
                           #activation = "Tanh",
                           stopping_metric = "MSE", 
                           stopping_tolerance = 10e-11)
dplmod
################################ h20 gbm ##################################################
gbmod <- h2o.gbm(1:(ncol(ForModel)-1),ncol(ForModel),h2odata)
gbmod
################################ Testing the fits ##########################################
preds.lm <- predict(lr.model, as.data.frame(ForModel[-spl,]))
preds.dpl <- h2o.predict(dplmod,h2odatest)
RMSE(preds.dpl,ForModel[-spl,ncol(ForModel)])
