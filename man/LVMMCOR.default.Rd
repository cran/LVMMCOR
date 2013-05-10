\name{LVMMCOR.default}
\alias{LVMMCOR.default}
\title{
A Latent Variable Model for Mixed Continuous and Ordinal Responses.
}
\description{
A model for mixed ordinal and continuous responses is presented where the heteroscedasticity of the variance of the continuous response is also modeled. In this model ordinal response can be dependent on the continuous response. The aim is to use an approach similar to that of Heckman (1978) for the joint modelling of the ordinal and continuous responses. With this model, the dependence between responses can be taken into account by the correlation between errors in the models for continuous and ordinal responses.
}
\usage{
\method{LVMMCOR}{default}(ini = NA, X, y, z, p, q, ...)
}
\arguments{
  \item{ini}{Initial values}
  \item{X}{Design matrix}
  \item{z}{Continuous responses}
  \item{y}{Ordinal responses with three Levels}
  \item{p}{Order of dimension of continuous responses}
  \item{q}{Order of dimension of ordinal responses}
  \item{\dots}{Other arguments}
}
\details{
Models for LVMMCOR are specified symbolically. A typical model has the form response1 ~ terms and response2 ~ terms  where response1and response2 are the (numeric) ordinal and 
continuous responses vector and  terms is a series of terms which specifies a linear predictor for responses. A terms specification of the form first + second indicates all the terms in first together with all the terms in second with duplicates removed. A specification of the form first:second indicates the set of terms obtained by taking the interactions of all terms in first with all terms in second. The specification first*second indicates the cross of first and second. This is the same as first + second + first:second.
}
\value{
\item{Continuous Response}{Coefficient of continuous response}
 \item{Variance of Continuous Response}{Variance of continuous response}
 \item{Ordinal response}{Coefficient of ordinal response}
 \item{Cut points}{Cut points for ordinal response}
 \item{Correlation}{Coefficient of continuous response}
 \item{Hessian}{Hessian matrix}
 \item{convergence}{An integer code. 0 indicates successful convergence.}
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
function (ini = NA, X, y, z, p, q, ...) 
{
    options(warn = -1)
    f <- function(ini, X, y, z, p, q) {
        X = cbind(1, X)
        y <- as.vector(y)
        z <- as.vector(z)
        ini <- as.vector(ini)
        X <- as.matrix(X)
        n = nrow(X)
        muz = muy = muygivenzx = q2 = q1 = l1 = l2 = l3 = muygivenzx = as.vector(0)
        sez <- exp(ini[p + q + 4])
        seygivenzx <- (1 - (ini[p + q + 1])^2)
        for (i in 1:n) {
            muz[i] <- as.numeric(t(ini[1:p]) \%*\% X[i, ])
            muy[i] <- as.numeric(t(ini[(p + 1):(p + q)]) \%*\% 
                X[i, -1])
            muygivenzx[i] <- muy[i] + (ini[p + q + 1] * (z[i] - 
                muz[i]))/sez
            q1[i] <- (ini[p + q + 2] - muygivenzx[i])/sqrt(seygivenzx)
            q2[i] <- (ini[p + q + 3] - muygivenzx[i])/sqrt(seygivenzx)
            l1[i] <- log(pnorm(q1[i])) + log(dnorm(z[i], muz[i], 
                sez))
            l2[i] <- log(pnorm(q2[i]) - pnorm(q1[i])) + log(dnorm(z[i], 
                muz[i], sez))
            l3[i] <- log(1 - pnorm(q2[i])) + log(dnorm(z[i], 
                muz[i], sez))
        }
        data0 <- cbind(y, l1)
        data1 <- cbind(y, l2)
        data2 <- cbind(y, l3)
        data0[data0[, 1] == 1, 2] <- 0
        data0[data0[, 1] == 2, 2] <- 0
        data1[data1[, 1] == 0, 2] <- 0
        data1[data1[, 1] == 2, 2] <- 0
        data2[data2[, 1] == 0, 2] <- 0
        data2[data2[, 1] == 1, 2] <- 0
        t0 <- sum(data0[, 2])
        t1 <- sum(data1[, 2])
        t2 <- sum(data2[, 2])
        t <- (c(t0, t1, t2))
        Tfinal <- sum(t)
        return(-Tfinal)
    }
    n = nlminb(ini, f, X = X, y = y, z = z, p = p, q = q, lower = c(rep(-Inf, 
        length(ini)), -0.999, -Inf, -Inf, 0), upper = c(rep(Inf, 
        length(ini)), 0.999, Inf, Inf, Inf), hessian = T)
    h = fdHess(n$par, f, z = z, y = y, X, p, q)
    h1 = h$Hessian
    ih = ginv(h1)
    se = sqrt(abs(diag(ih)))
    n$Hessian <- h1
    n$p <- p
    n$q <- q
    n$se <- as.vector(se)
    n$call <- match.call()
    class(n) <- "LVMMCOR"
    object = n
    Co.Re <- data.frame(Parameter = object$par[1:p], S.E = object$se[1:p], 
        `Confidence Interval` = paste("(", round(object$par[1:p] - 
            2 * object$se[1:p], 3), ",", round(object$par[1:p] + 
            2 * object$se[1:p], 3), ")", sep = ""))
    Or.Re <- data.frame(Parameter = object$par[(p + 1):(p + q)], 
        S.E = object$se[(p + 1):(p + q)], `Confidence Interval` = paste("(", 
            round(object$par[(p + 1):(p + q)] - 2 * object$se[(p + 
                1):(p + q)], 3), ",", round(object$par[(p + 1):(p + 
                q)] + 2 * object$se[(p + 1):(p + q)], 3), ")", 
            sep = ""))
    Cut.P <- data.frame(Parameter = object$par[(p + q + 2):(p + 
        q + 3)], S.E = object$se[(p + q + 2):(p + q + 3)], `Confidence Interval` = paste("(", 
        round(object$par[(p + q + 2):(p + q + 3)] - 2 * object$se[(p + 
            q + 2):(p + q + 3)], 3), ",", round(object$par[(p + 
            q + 2):(p + q + 3)] + 2 * object$se[(p + q + 2):(p + 
            q + 3)], 3), ")", sep = ""))
    Cor <- data.frame(Parameter = object$par[p + q + 1], S.E = object$se[p + 
        q + 1], `Confidence Interval` = paste("(", round(object$par[p + 
        q + 1] - 2 * object$se[p + q + 1], 3), ",", round(object$par[p + 
        q + 1] + 2 * object$se[p + q + 1], 3), ")", sep = ""))
    Var <- data.frame(Parameter = object$par[p + q + 4], S.E = object$se[p + 
        q + 4], `Confidence Interval` = paste("(", round(object$par[p + 
        q + 4] - 2 * object$se[p + q + 4], 3), ",", round(object$par[p + 
        q + 4] + 2 * object$se[p + q + 4], 3), ")", sep = ""))
    row.names(Cut.P) <- c("cut point1", "cut point2")
    res <- list(call = object$call, `Continuos Response` = Co.Re, 
        `Variance Of Countinous Response` = Var, `Ordinal Response` = Or.Re, 
        `Cut points` = Cut.P, Correlation = Cor)
    res$Hessian <- h1
    res$convergence <- n$convergence
    res$call <- match.call()
    class(res) <- "LVMMCOR"
    res
  }
}
\keyword{regression}

