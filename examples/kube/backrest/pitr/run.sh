#!/bin/bash
# Copyright 2017 - 2019 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source ${CCPROOT}/examples/common.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -z ${CCP_BACKREST_TIMESTAMP} ]]
then
    echo_err "Please provide a valid timestamp for the PITR using varibale CCP_BACKREST_TIMESTAMP."
    exit 1
fi

${CCP_CLI?} exec --namespace=${CCP_NAMESPACE?} -ti backrest date >/dev/null
if [[ $? -ne 0 ]]
then
    echo_err "The backup example must be running prior to using this example."
    exit 1
fi

${DIR}/cleanup.sh

expenv -f $DIR/pitr-restore.json | ${CCP_CLI?} create --namespace=${CCP_NAMESPACE?} -f -
