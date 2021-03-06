% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/acl.R
\name{get_acl}
\alias{get_acl}
\alias{put_acl}
\title{Get or put bucket/object ACLs}
\usage{
get_acl(object, bucket, ...)

put_acl(object, bucket, acl = NULL, headers = list(), body = NULL, ...)
}
\arguments{
\item{object}{Character string with the object key, or an object of class \dQuote{s3_object}. In most cases, if \code{object} is specified as the latter, \code{bucket} can be omitted because the bucket name will be extracted from \dQuote{Bucket} slot in \code{object}.}

\item{bucket}{Character string with the name of the bucket, or an object of class \dQuote{s3_bucket}.}

\item{\dots}{Additional arguments passed to \code{\link{s3HTTP}}.}

\item{acl}{A character string indicating a \href{http://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl}{\dQuote{canned} access control list}. By default all bucket contents and objects therein are given the ACL \dQuote{private}. This can later be viewed using \code{\link{get_acl}} and modified using \code{\link{put_acl}}.}

\item{headers}{List of request headers for the REST call}

\item{body}{A character string containing an XML-formatted ACL.}
}
\value{
For \code{get_acl} a character string containing an XML-formatted ACL. For \code{put_acl}: if successful, \code{TRUE}.
}
\description{
Access Control Lists (ACLs) control access to buckets and objects. These functions retrieve and modify ACLs for either objects or buckets.
}
\details{
\code{get_acl} retrieves an XML-formatted ACL for either an object (if specified) or a bucket (if specified).
}
\references{
\href{https://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectGETacl.html}{API Reference: GET Object ACL}
  \href{https://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectPUTacl.html}{API Reference: PUT Object ACL}
}
