#!/usr/bin/env bash

# creates a backup of the docker volume

while [ $# -gt 0 ]; do
  case "$1" in
    -v|-volume|--volume)
      volume="$2"
      ;;
    -p|-prefix|--prefix)
      prefix="$2"
      ;;
    -h|-help|--help)
      printf "--volume the name of the volume\n"
      printf "--mount the mount point of the volume\n"
      exit 1
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
  shift
done

uuid=$(cat /proc/sys/kernel/random/uuid)
if [ ! -d $prefix/$volume ]; then
  mkdir -p $prefix/$volume
fi

IMAGE=alpine:latest
docker run \
--mount "type=volume,src=${volume},dst=/data" \
--name $uuid \
$IMAGE

mkdir -p ~/tmp2

timestamp=$(date +%Y-%m-%d_%H%M%S)
docker cp -a $uuid:/data ~/tmp2/$uuid
tar -C ~/tmp2/$uuid -czf $prefix/$volume/${timestamp}_${volume}.tar.gz .
rm -rf ~/tmp2/$uuid
docker rm $uuid
