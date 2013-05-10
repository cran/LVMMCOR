\name{LVMMCOR}
\alias{LVMMCOR}
\title{
A Latent Variable Model for Mixed Continuous and Ordinal Responses.
}
\description{
A model for mixed ordinal and continuous responses is presented where the heteroscedasticity of the variance of the continuous response is also modeled. In this model ordinal response can be dependent on the continuous response. The aim is to use an approach similar to that of Heckman (1978) for the joint modelling of the ordinal and continuous responses. With this model, the dependence between responses can be taken into account by the correlation between errors in the models for continuous and ordinal responses.
}
\usage{
LVMMCOR(ini = NA, X, y, z, p, q, ...)
}
\arguments{
\item{ini}{Initial values}
\item{X}{Design matrix}
\item{z}{Continuous responses}
\item{y}{Ordinal responses with three levels}
\item{p}{Order of dimension of continuous responses}
\item{q}{Order of dimension of ordinal responses}
\item{\dots}{Other arguments}}
\details{
Models for LVMMCOR are specified symbolically. A typical model has the form response1 ~ terms and response2 ~ terms  where response1and response2 are the (numeric) ordinal and 
continuous responses vector and  terms is a series of terms which specifies a linear predictor for responses. A terms specification of the form first + second indicates all 
the terms in first together with all the terms in second with duplicates removed. A specification of the form first:second indicates the set of terms obtained 
by taking the interactions of all terms in first with all terms in second. The specification first*second indicates the cross of first and second. This is the same as first + second + first:second. 
}
\value{
 \item{Continuous Response}{Coefficient of continuous response}
 \item{Variance of Continuous Response}{Variance of continuous response}
 \item{Ordinal Response}{Coefficient of ordinal response}
 \item{Cut points}{Cut points for ordinal response}
 \item{Correlation}{Coefficient of continuous response}
 \item{Hessian}{Hessian matrix}
 \item{convergence}{An integer code. 0 indicates successful convergence}
}
\references{
Bahrami Samani, E.,  Ganjali, M. and Khodaddadi, A.  (2008). A Latent Variable Model for Mixed Continuous and Ordinal Responses. Journal of Statistical Theory and Applications. 7(3):337-349. 
}
\author{
Bahrami Samani and Nourallah Tazikeh Miyandarreh 
}
\note{
Supportted by Shahid Beheshti University
}

\seealso{
\code{\link{nlminb}},\code{\link{fdHess}}
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

## The function is currently defined as
structure(function (x, ...) 
UseMethod("LVMMCOR"), class = "LVMMCOR")
}
\keyword{regression}
