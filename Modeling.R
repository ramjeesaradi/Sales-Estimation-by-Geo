################################# Linear Regression Modeling ################################
# lr.models <- lapply(unique(cora.aggr$PRODUCTGROUP.Level1),
#                     function (x) {
#                       lm(Sales..Rs.~.,as.data.frame(dta.model[[x]]))
#                     })
# names(lr.models) <- unique(cora.aggr$PRODUCTGROUP.Level1)
lr.model <- lm(Sales..Rs.~.,as.data.frame(ForModel))
attach(lr.model)
coefficients
residuals
################################ DeepLearning Modeling #####################################
h2oklocal <- h2o.init()
h2odata <- as.h2o(ForModel,destination_frame = "dat")
dplmod <- h2o.deeplearning(1:(ncol(ForModel)-1),ncol(ForModel),h2odata,regression_stop = 1e-9)
dplmod
################################ Testing the fits ##########################################
preds.lm <- predict(lr.model, as.data.frame(ForModel[,-ncol(ForModel)]), type = "raw")
RMSE(preds.lm,ForModel[,ncol(ForModel)])
