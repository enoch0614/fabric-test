#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0

# Execute barebones test on Kubernetes or on local network
#     kubernetes network: if environment varible KUBECONFIG is set to the kubernetes configuration file
#     local network: if the environment varibale KUBECONFIG is not set.
# The test output is in $FabricTestDir/regression/barebones/barebones-pteReport.log

CurrentDirectory=$(cd `dirname $0` && pwd)
FabricTestDir="$(echo $CurrentDirectory | awk -F'/fabric-test/' '{print $1}')/fabric-test"
BAREBONESDIR="$FabricTestDir/regression/barebones"

echo "======== Barebones Test Suite installing npm ========"
cd $FabricTestDir/tools/PTE
if [ ! -d "node_modules" ];then
    npm config set prefix ~/npm
    npm install
    if [ $? != 0 ]; then
        echo "FAILED: Failed to install npm. Cannot run pte test suite."
        # Don't exit.. Continue with tests, to show the PTE failure results
    else
        echo "Successfully installed npm."
    fi
fi

echo "======== Barebones Test Suite using ginkgo and operator tools ========"
cd $BAREBONESDIR && ginkgo -v
StatusOperator=$?

if [ $StatusOperator == 0 ] && [ $StatusPteNL == 0 ]; then
    echo "------> Barebones tests completed"
    echo "------> Test output: $FabricTestDir/regression/barebones/barebones-pteReport.log"
else
    echo "------> Barebones tests failed with above errors"
    exit 1
fi
