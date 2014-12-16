#!/bin/bash

case "${SSH_ORIGINAL_COMMAND}" in
    /usr/sbin/simplesnapwrap*|simplesnapwrap* )
        ${SSH_ORIGINAL_COMMAND}
        ;;
    zfs-list-snapshots )
        /sbin/zfs list -t snap -o name -H
        ;;
    *)
        echo "REJECTED: ${SSH_ORIGINAL_COMMAND}"
        exit 1
    ;;
esac
