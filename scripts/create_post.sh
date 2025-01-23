
TAG=$1
NAME=$2
TITLE=$3
cat << EOF > docs/_posts/zh/$TAG/$(date +%Y-%m-%d)-$NAME.md
---
layout:     post
title:      "$TITLE"
subtitle:   "$TITLE"
date:       $(date +%Y-%m-%d)
author:     "vxiaozhi"
catalog: true
tags:
    - $TAG
---
EOF
