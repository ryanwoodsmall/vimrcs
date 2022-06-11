#!/usr/bin/env sh
#
# timestamp and copy new vim configs in place
#

set -eu

function gettimestamp() {
  sleep 1
  local TS="$(env TZ=Etc/UTC date +%Y%m%d%H%M%S)"
  echo "${TS}"
} 

# ensure timestamp is unique...
export TS="$(gettimestamp)"
export td="$(dirname $(realpath "${BASH_SOURCE[0]}"))"

for i in dotvim{,rc} ; do
  sourcefile="$(basename ${td}/${i})"
  targetfile="${sourcefile/dot/.}"
  source="$(realpath ${td}/${sourcefile})"
  target="$(realpath ${HOME}/${targetfile})"
  # XXX loop until something doesnt exist, then create?
  if [ -e "${target}" ] ; then
    while true ; do
      test -e "${target}.PRE-${TS}" || break
      TS="$(gettimestamp)"
    done
    echo mv "${target}" "${target}.PRE-${TS}"
  fi
  echo cp -pr "${source}" "${target}" # cpio/tar/...
done | eval
