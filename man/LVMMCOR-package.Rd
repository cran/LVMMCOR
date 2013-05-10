\name{LVMMCOR-package}
\alias{LVMMCOR-package}
\docType{package}
\title{
A Latent Variable Model for Mixed Continuous and Ordinal Responses.
}
\description{
A model for mixed ordinal and continuous responses is presented where the heteroscedasticity  of  the variance of  the continuous response is also modeled. 
}
\details{
\tabular{ll}{
Package: \tab LVMMCOR\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2013-05-31\cr
License: \tab GPL (>=2)\cr
}
}
\author{
Bahrami Samani and Nourallah Tazikeh Miyandarreh 

Maintainer: Bahrami Samani <ehsan_bahrami_samani@yahoo.com> 
}
\references{
Bahrami Samani, E.,  Ganjali, M. and Khodaddadi, A.  (2008). A Latent Variable Model for Mixed Continuous and Ordinal Responses. Journal of Statistical Theory and Applications. 7(3):337-349. 
}
\examples{
data("Bahrami")
gender<-Bahrami$ GENDER
age<-Bahrami$AGE
duration <-Bahrami$ DURATION
y<-Bahrami$ STEATOS
z<-Bahrami$  BMI
sbp<-Bahrami$ SBP
X=cbind(gender,age,duration ,sbp)
P<-lm(z~X)[[1]]
names(P)<-paste("Con_",names(P),sep="")
Q<-polr(factor(y)~X)[[1]]
names(Q)<-paste("Ord_",names(Q),sep="")
W=c(cor(y,z),polr(factor(y)~X)[[2]],var(z))
names(W)=c("Corr","cut_point1","cut_point2","Variance of Continous Response")
ini=c(P,Q,W)
p=5;
q=4;
LVMMCOR(ini,X=X,y=y,z=z,p=p,q=q)
}
\keyword{package}