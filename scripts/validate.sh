#! /usr/bin/env bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Validation script checks if instances is deployed         -"
# "-                                                       -"
# "---------------------------------------------------------"

# Do not set exit on error, since the rollout status command may fail
set -o nounset
set -o pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# shellcheck source=scripts/common.sh
source "$ROOT/scripts/common.sh"


cd "$ROOT/terraform" || exit; \
    GCE_NAME=$(terraform output gce_name) \
    GCE_ZONE=$(terrform output gce_zone)


REGION=${GCE_ZONE%-*}

function check_command_status() {
    local -r command=$1
    local -r component=$2
    if ! ${command} > /dev/null; then
        echo "FAIL: ${component} does not exist"
        exit 1
    else
        echo "${component} exists"
    fi
}

check_command_status "gcloud compute instances describe ${GCE_NAME} --zone ${GCE_ZONE}" "GCE Instance"


echo "Example is deployed."
