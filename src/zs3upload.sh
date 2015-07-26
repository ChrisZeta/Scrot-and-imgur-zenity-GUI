#!/bin/bash

# s3 public uploader script
# version 0
# I release this into the public domain. Do with it what you will. it's a piece of hacky bs anyway

# Required: s3cmd
#
# Make sure you have run s3cmd --configure and put in your s3 credentials as needed.
# In the case that you run an error such as `ERROR: S3 error: The specified location-constraint is not valid`
# you should run `s3cmd --configure` again and when asked about default region, use 'us' without quotes

# # Instructions:
# Put it somewhere in your path and maybe rename it:
# mv s3-pub-upload ~/bin/s3-pub-upload
# Make it executable:
# chmod +x ~/bin/s3-pub-upload
# Upload an image:
# s3-pub-upload images/hilarious/manfallingover.jpg


ZSCREEN_S3_BUCKET=${ZSCREEN_S3_BUCKET:-'zscreen-bucket'}

function usage {
  print "Usage: $(basename $0) <filename> [<filename> [...]]
Upload images to your s3 bucket and output their new URLs to stdout. Each one's delete page is output to stderr between the view URLs.  If xsel or xclip is available, the URLs are put on the X selection for easy pasting. ">&2
}

# check arguments
if [ "$1" = "-h" -o "$1" = "--help" ]; then
  usage
  exit 0
elif [ $# == 0 ]; then
  echo "No file specified" >&2
  usage
  exit 1
fi

# check s3cmd is available. Since s3cmd stores our credentials, no need to store credentials in this file.
type s3cmd >/dev/null 2>/dev/null || {
  echo "Couln't find s3cmd. Please install s3cmd and then run s3cmd --configure" >&2
  exit 1
}

#create a bucket if necessary
s3cmd ls s3://$ZSCREEN_S3_BUCKET >/dev/null 2>/dev/null || {
  s3cmd mb s3://$ZSCREEN_S3_BUCKET
}

# one hit wonder
result_url=$(s3cmd --acl-public put $1 s3://$ZSCREEN_S3_BUCKET 2>/dev/null | grep http | sed -r 's/.*(http:\/\/.+\.s3\.amazonaws\.com\/.+)/\1/')
xdg-open $result_url >/dev/null 2>/dev/null

echo $result_url | xclip >/dev/null 2>/dev/null
exit 0
