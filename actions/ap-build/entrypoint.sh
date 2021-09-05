#!/bin/sh -l
echo "print all env ==>"
printenv

echo "show all env ==>"
env

# work
echo "My Name is : $MY_NAME "
# not work
echo "My Full Name is : $MY_FULL_NAME "

echo "Current path: $(pwd)"
echo "Show list content ==>"
ls -la
ehco "<==\n"

# show file content
echo "show content of index.html ==>"
cat index.html
echo "\n\n"

# terraform
echo "Terraform information ==>"
terraform version

# Packer
echo "Packer information ==>"
packer version
packer validate /example.json

echo "Hello $0 $1 \n"
time=$(date)
echo "::set-output name=time::$time "

live_target='green'
echo "::set-output name=live_target_group::$live_target"

TEST_VAR='Hello from entrypoint'
# follow line not work
export $TEST_VAR
# follow line works
echo "::set-output name=test_var_output::$TEST_VAR "

# env example
echo "test_var_env=$TEST_VAR" >> $GITHUB_ENV
