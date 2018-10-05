#!/bin/sh -e

# tile-generator
#
# Copyright (c) 2015-Present Pivotal Software, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SOURCE_DIR=$1
HISTORY_DIR=$2
TARGET_DIR=$3
DOCKER_DIR=$4
VERSION_DIR=$5

MY_DIR="$( cd "$( dirname "$0" )" && pwd )"
REPO_DIR="$( cd "${MY_DIR}/../.." && pwd )"
BASE_DIR="$( cd "${REPO_DIR}/.." && pwd )"

TILE="tile"

cd ${BASE_DIR}

HISTORY="${HISTORY_DIR}/tile-history-*.yml"
if [ -e "${HISTORY}" ]; then
	cp ${HISTORY} ${SOURCE_DIR}/tile-history.yml
fi

if [ -n "${DOCKER_DIR}" ]; then
	DOCKER_DIR="--cache $BASE_DIR/$DOCKER_DIR"
fi

VERSION=""
if [ -n "${VERSION_DIR}" ]; then
	VERSION=`cat ${VERSION_DIR}/version`
fi

(cd ${SOURCE_DIR}; $TILE build $DOCKER_DIR $VERSION)

VERSION=`grep '^version:' ${SOURCE_DIR}/tile-history.yml | sed 's/^version: //'`
HISTORY="tile-history-${VERSION}.yml"

cp ${SOURCE_DIR}/product/*.pivotal ${TARGET_DIR}
cp ${SOURCE_DIR}/tile-history.yml ${TARGET_DIR}/${HISTORY}
