#!/bin/bash

PROJECT_DIR=$(cd `dirname $0` && pwd -P)
PAGES_DIR=${PROJECT_DIR}/pages/
PARTIALS_DIR=${PROJECT_DIR}/partials/
STATIC_DIR=${PROJECT_DIR}/static/

OUTPUT_DIR=${PROJECT_DIR}/public/
echo "Cleaning output folder..."
if [ -d "${OUTPUT_DIR}" ]; then
  rm -rf ${OUTPUT_DIR}/*
fi
mkdir -p ${OUTPUT_DIR}

VERSION_INFO="$(git rev-parse --short=8 HEAD), $(date --iso=minutes)"

echo "Generating pages..."
cd ${PAGES_DIR}
for PAGE in `cd ${PAGES_DIR} && find . -name '*.html'`; do
  echo " $PAGE"
  mkdir -p ${OUTPUT_DIR}/$(dirname ${PAGE})

  if [ ! -L "${PAGE}" ]; then
    for f in ${PARTIALS_DIR}/top.html ${PAGE} ${PARTIALS_DIR}/bottom.html; do
      cat $f | sed -E "s/__VERSION_INFO__/${VERSION_INFO}/g" >> ${OUTPUT_DIR}/${PAGE}
    done
  else
    cp -P ${PAGE} ${OUTPUT_DIR}/$(dirname ${PAGE})
  fi
done

echo "Copying static files..."
cp -R ${STATIC_DIR}/* ${OUTPUT_DIR}

echo "Adding .nojekyll marker file..."
touch ${OUTPUT_DIR}/.nojekyll

echo "Done."
