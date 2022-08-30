#!/bin/bash

# this will force script to exit if any commands in a script fail
# -x to show what commands are being run - during the script execution
set -ex

if [[ $BRANCH_NAME == feature-* ]]
then
    current_stage=dev
    
    elif [[ $BRANCH_NAME == master ]]
then
    current_stage=staging
elif [[ $BRANCH_NAME == production/deploy ]]
then
    current_stage=prod
fi

# this will happen only in dev and staging stages
if [[ $current_stage == dev ]] || [[ $current_stage == staging ]]
then
    cd backend/
    make build stage=$current_stage
    make push stage=$current_stage
    cd ..
    cd frontend/
    make build stage=$current_stage
    make push stage=$current_stage
    cd ..
fi

# this will happen regardless of the stage
cd frontend/
#make context stage=$current_stage
make deploy stage=$current_stage
cd ..
cd backend/
#make context stage=$current_stage
make deploy stage=$current_stage
cd ..
