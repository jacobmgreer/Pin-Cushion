#!/bin/sh

#TEMPLATE
cat << EOF
---
added_date: "$(echo $3)"
hash: "$(identify -quiet -format '%#' $1)"
image_filetype: "$(echo $2)"
layout: pin
thumb: "thumb.$(echo $2)"
original_path_image: "$1"

category: "$(echo $1 | cut -d '/' -f 2)"
tag: "$(echo $1 | cut -d '/' -f 3)"
---
EOF