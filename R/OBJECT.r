#' @title Retrieves an object from an S3 bucket
#' 
#' @param bucket Character string with the name of the bucket.
#' @param object Character string of the name of the object you want to get.
#' @param headers List of request headers for the REST call.
#' @param ... Additional arguments passed to \code{\link{s3HTTP}}.
#'
#' @return A raw object.
#' @references \href{http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectGET.html}{API Documentation}
#' @export

getobject <- function(bucket, object, headers = list(), ...) {
    if (inherits(object, "s3_object"))
        object <- object$Key
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name

    r <- s3HTTP(verb = "GET", 
                bucket = bucket,
                path = paste0("/", object),
                headers = c(headers, `x-amz-content-sha256` = ""), 
                parse_response = FALSE,
                ...)
    if (inherits(r, "aws_error")) {
        return(r)
    } else {
        r
    }
}

print.s3_object <- function(x, ...){
    cat("Key:           ", x$Key, "\n")
    cat("Modified:      ", x$LastModified, "\n")
    cat("ETag:          ", x$ETag, "\n")
    cat("Size (kb):     ", x$Size, "\n")
    cat("Owner:         ", x$Owner$DisplayName, "\n")
    cat("Storage class: ", x$StorageClass, "\n")
    invisible(x)
}


get_acl <- function(bucket, object, ...) {
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    if (missing(object)) {
        r <- s3HTTP(verb = "GET", 
                    bucket = bucket,
                    path = "?acl",
                    headers = list(`x-amz-content-sha256` = ""), 
                    ...)
        if (inherits(r, "aws_error")) {
            return(r)
        } else {
            structure(r, class = "s3_bucket")
        }
    } else {
        if (inherits(object, "s3_object"))
            object <- object$Key
        r <- s3HTTP(verb = "GET", 
                    path = "/object?acl",
                    headers = list(`x-amz-content-sha256` = ""), 
                    ...)
        if (inherits(r, "aws_error")) {
            return(r)
        } else {
            structure(r, class = "s3_object")
        }
    }
}

#' @title Retrieves a Bencoded dictionary (BitTorrent) for an object from an S3 bucket.
#' 
#' @param bucket Character string with the name of the bucket.
#' @param object Character string of the name of the object you want to get.
#' @param ... additional arguments passed to \code{\link{s3HTTP}}.
#'
#' @return Something.
#' @references \href{http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectGETtorrent.html}{API Documentation}
#' @export

get_torrent <- function(bucket, object, ...) {
    if (inherits(object, "s3_object"))
        object <- object$Key
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    r <- s3HTTP(verb = "GET", 
                bucket = bucket,
                path = paste0("/", object, "?torrent"),
                headers = list(`x-amz-content-sha256` = ""), 
                ...)
    if (inherits(r, "aws_error")) {
        return(r)
    } else {
        return(r)
    }
}


# HEAD

headobject <- function(bucket, object, ...) {
    if (inherits(object, "s3_object"))
        object <- object$Key
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    r <- s3HTTP(verb = "HEAD", 
                bucket = bucket,
                path = paste0("/", object),
                headers = list(`x-amz-content-sha256` = ""), 
                ...)
    if (inherits(r, "aws_error")) {
        return(r)
    } else {
        structure(r, class = "HEAD")
    }
}


# OPTIONS

optsobject <- function(bucket, object, ...) {
    if (inherits(object, "s3_object"))
        object <- object$Key
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    r <- s3HTTP(verb = "OPTIONS", 
                bucket = bucket,
                path = paste0("/", object),
                headers = list(`x-amz-content-sha256` = ""), 
                ...)
    if (inherits(r, "aws_error")) {
        return(r)
    } else {
        return(r)
    }
}


# POST

postobject <- function(bucket, object, ...) {
    if (inherits(object, "s3_object"))
        object <- object$Key
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    r <- s3HTTP(verb = "POST", 
                bucket = bucket,
                path = paste0("/", object),
                headers = list(`x-amz-content-sha256` = ""), 
                ...)
    if (inherits(r, "aws_error")) {
        return(r)
    } else {
        structure(r, class = "s3_object")
    }
}


# PUT

#' @title Puts an object into an S3 bucket
#'
#' @param file A character string containing the filename (or full path) of 
#' the file you want to upload to S3.
#' @param bucket A character string containing the name of the bucket you want 
#' to put an object into.
#' @param object A character string containing the name the object should 
#' have in S3 (i.e., its "object key"). If missing, the filename is used.
#' @param headers List of request headers for the REST call.   
#' @param ... additional arguments passed to \code{\link{s3HTTP}}
#'
#' @return If successful, \code{TRUE}, otherwise an aws_error object.
#' @references \href{http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectPUT.html}{API Documentation}
#' @export

putobject <- function(file, bucket, object, headers = list(), ...) {
    if (!missing(object) && inherits(object, "s3_object"))
        object <- object$Key
    if (missing(object)) {
        object <- basename(file)
    }

    r <- s3HTTP(verb = "PUT", 
                bucket = bucket,
                path = paste0("/", object),
                headers = c(headers, list(`Content-Length` = file.size(file), 
                                          `x-amz-content-sha256` = "")), 
                request_body = file,
                ...)
    if (inherits(r, "aws_error")) {
        return(r)
    } else {
        TRUE
    }
}

putobject_acl <- function(bucket, object, ...) {
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    if (missing(object)) {
        r <- s3HTTP(verb = "PUT", 
                    bucket = bucket,
                    #url = paste0("https://", bucket, ".s3.amazonaws.com"),
                    path = "?acl",
                    headers = list(`x-amz-content-sha256` = ""), 
                    ...)
        if (inherits(r, "aws_error")) {
            return(r)
        } else {
            structure(r, class = "s3_bucket")
        }
    } else {
        if (inherits(object, "s3_object"))
            object <- object$Key
        r <- s3HTTP(verb = "PUT", 
                    bucket = bucket,
                    path = paste0("/", object),
                    headers = list(`x-amz-content-sha256` = ""), 
                    ...)
        if (inherits(r, "aws_error")) {
            return(r)
        } else {
            structure(r, class = "s3_object")
        }
    }
}

copyobject <- function(from_object, to_object, from_bucket, to_bucket, ...) {
    if (inherits(object, "s3_object"))
        object <- object$Key
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    r <- s3HTTP(verb = "PUT", 
                bucket = bucket,
                path = paste0("/", object),
                headers = list(`x-amz-content-sha256` = ""), 
                ...)
    if (inherits(r, "aws_error")) {
        return(r)
    } else {
        return(r, class = "s3_object")
    }
}


# DELETE

#' @title Deletes an object from an S3 bucket.
#'
#' @param bucket A character string containing the name of the bucket you want 
#' to delete an object from.
#' @param object A character string containing the name of the object.
#' @param ... Additional arguments passed to \code{\link{s3HTTP}}
#'
#' @return TRUE if successful, aws_error details if not.
#' @references \href{http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectDELETE.html}{API Documentation}
#' @export
deleteobject <- function(bucket, object, ...) {
    if (inherits(object, "s3_object"))
        object <- object$Key
    if (inherits(bucket, "s3bucket"))
        bucket <- bucket$Name
    if (length(object) == 1) {
        r <- s3HTTP(verb = "DELETE", 
                    bucket = bucket,
                    path = paste0("/", object),
                    ...)
        if (inherits(r, "aws_error")) {
            return(r)
        } else {
            TRUE
        }
    } else {
        b1 <- 
'<?xml version="1.0" encoding="UTF-8"?>
<Delete>
    <Quiet>true</Quiet>
    <Object>'
#         <Key>Key</Key>
# version not implemented yet:
#         <VersionId>VersionId</VersionId>
        b2 <- 
'    </Object>
    <Object>
         <Key>Key</Key>
    </Object>
    ...
</Delete>'
        tmpfile <- tempfile()
        on.exit(unlink(tmpfile))
        b <- writeLines(paste0(b1, paste0("<Key>",object,"</Key>"), b2), tmpfile)
        md <- base64enc::base64encode(digest::digest(file = tmpfile, raw = TRUE))
        r <- s3HTTP(verb = "POST", 
                    bucket = bucket,
                    path = "?delete",
                    body = tmpfile,
                    headers = list(`Content-Length` = file.size(tmpfile), 
                                   `Content-MD5` = md,
                                   `x-amz-content-sha256` = ""), 
                    ...)
        if (inherits(r, "aws_error")) {
            return(r)
        } else {
            return(structure(r, class = "s3_object"))
        }
    }
    return(r)
}
