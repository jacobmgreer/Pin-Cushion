#!/bin/sh

#TEMPLATE
cat << EOF
---
category: "$(echo $1 | cut -d '/' -f 2)"
tag: "$(echo $1 | cut -d '/' -f 3)"
layout: board
---
EOF
