\name{setNumericRounding}
\alias{setNumericRounding}
\alias{getNumericRounding}
\title{ Change or turn off numeric rounding }
\description{
  Change rounding to 0, 1 or 2 bytes when joining, grouping or ordering numeric (i.e. double, POSIXct) columns.
}
\usage{
setNumericRounding(x)
getNumericRounding()
}
\arguments{
  \item{x}{ integer or numeric vector: 2 (default), 1 or 0 byte rounding }
}
\details{
  Computers cannot represent some floating point numbers (such as 0.6) precisely, using base 2. This leads to unexpected behaviour when
  joining or grouping columns of type 'numeric'; i.e. 'double', see example below.  To deal with this automatically for convenience, 
  when joining or grouping, data.table rounds such data to apx 11 s.f. which is plenty of digits for many cases. This is achieved by
  rounding the last 2 bytes off the significand.  Where this is not enough, \code{setNumericRounding} can be used to reduce to 1 byte
  rounding, or no rounding (0 bytes rounded) for full precision.
  
  It's bytes rather than bits because it's tied in with the radix sort algorithm for sorting numerics which sorts byte by byte. With the
  default rounding of 2 bytes, at most 6 passes are needed. With no rounding, at most 8 passes are needed and hence may be slower. The
  choice of default is not for speed however, but to avoid surprising results such as in the example below.

  For large numbers (integers > 2^31), we recommend using \code{bit64::integer64} rather than setting rounding to \code{0}.
  
  If you're using \code{POSIXct} type column with \emph{millisecond} (or lower) resolution, you might want to consider setting \code{setNumericRounding(1)} . This'll become the default for \code{POSIXct} types in the future, instead of the default \code{2}.
}
\value{
    \code{setNumericRounding} returns no value; the new value is applied. \code{getNumericRounding} returns the current value: 0, 1 or 2.
}
\seealso{
\code{\link{datatable-optimize}}\cr
\url{http://en.wikipedia.org/wiki/Double-precision_floating-point_format}\cr
\url{http://en.wikipedia.org/wiki/Floating_point}\cr
\url{http://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html}
}
\examples{
DT = data.table(a=seq(0,1,by=0.2),b=1:2, key="a")
DT
setNumericRounding(0)   # turn off rounding
DT[.(0.4)]   # works
DT[.(0.6)]   # no match, confusing since 0.6 is clearly there in DT

setNumericRounding(2)   # restore default
DT[.(0.6)]   # works as expected

# using type 'numeric' for integers > 2^31 (typically ids)
DT = data.table(id = c(1234567890123, 1234567890124, 1234567890125), val=1:3)
print(DT, digits=15)
DT[,.N,by=id]   # 1 row
setNumericRounding(0)
DT[,.N,by=id]   # 3 rows
# better to use bit64::integer64 for such ids
setNumericRounding(2)
}
\keyword{ data }


