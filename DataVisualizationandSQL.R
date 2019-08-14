rm(list=ls())

###Data Wrangling in R###
library("ggplot2")
data("USPersonalExpenditure")

#creating new dataframe
uspe = USPersonalExpenditure
amount = rep(t(uspe),1)
year = rep(colnames(uspe), nrow(uspe))
category = as.vector(sapply(rownames(uspe), rep, ncol(uspe)))
USPersonalExpenditure_Long = data.frame(category, year, amount)

#stacked bar chart
ggplot(USPersonalExpenditure_Long, aes(x = year, y = amount, fill=category)) +
  geom_bar(stat='identity')

#adding column for running total
USPersonalExpenditure_Long$csum = ave(USPersonalExpenditure_Long$amount, USPersonalExpenditure_Long$category, FUN=cumsum)

#5x2 table
totalExp = data.frame(apply(uspe, 1, sum))
totalExp = cbind(rownames(totalExp), data.frame(totalExp, row.names=NULL))
colnames(totalExp) = c("Category", "TotalExpenditures")

###SQL queries###
library("sqldf")
library("RSQLite")

date0 = c("2017-01-01","2017-04-03","2017-04-04","2017-05-01","2017-05-01")
name0 = c("Asghar", "Bethany", "Judith", "Gary", "Silverio")
amount0 = c(10,5,30,15,1.5)
unsubscribed0 = c(TRUE,FALSE,FALSE,TRUE,FALSE)
ex = data.frame(cbind(date0,name0,amount0,unsubscribed0))

#number of contributions
sqldf("SELECT COUNT(*) FROM ex;")

#total amount raised
sqldf("SELECT SUM(amount0) FROM ex;")

#net subscriptions by month
sqldf("SELECT count(*) AS Monthly_Net_Subscriptions FROM ex WHERE date0 LIKE '2017-01%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-02%'
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-03%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-04%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-05%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-06%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-07%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-08%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-09%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-10%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-11%' 
      UNION ALL SELECT count(*) FROM ex WHERE date0 LIKE '2017-12%';")

#cumulative net subscriptions to-date

sqldf("SELECT d1.date0 As Date, SUM(d2.unsubscribed0 = 'FALSE') AS SubToDate
      FROM ex d1
      JOIN ex d2 on d1.date0 >= d2.date0
      GROUP BY d1.date0, d1.unsubscribed0
      ORDER BY d1.date0")


