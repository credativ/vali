#!/bin/bash

set -eu

SRC_PATH=/src/vali

# If we run make directly, any files created on the bind mount
# will have awkward ownership.  So we switch to a user with the
# same user and group IDs as source directory.  We have to set a
# few things up so that sudo works without complaining later on.
uid=$(stat --format="%u" $SRC_PATH)
gid=$(stat --format="%g" $SRC_PATH)
echo "plutono:x:$uid:$gid::$SRC_PATH:/bin/bash" >>/etc/passwd
echo "plutono:*:::::::" >>/etc/shadow
echo "plutono	ALL=(ALL)	NOPASSWD: ALL" >>/etc/sudoers

su plutono -c "PATH=$PATH make -C $SRC_PATH BUILD_IN_CONTAINER=false $*"
