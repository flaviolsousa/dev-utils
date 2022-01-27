#!/bin/bash

##
# Script list commands to remove remote and old git branches
#
# Examples:
#   ./remove-old-branches.sh timeAgo="1 week"
#   ./remove-old-branches.sh timeAgo="3 months"
#   ./remove-old-branches.sh timeAgo="3 months" showAllBranchs=true
#   ./remove-old-branches.sh timeAgo="1000 days" showAllBranchs=true
##

echo \#=======================================================\#

# == BEGIN : CONFIG ==
defaultTimeAgo="3 month"
declare -a branchesInBlackList=("origin/master" "origin/HEAD" "origin/develop")
cd ..
# == END : CONFIG ==


# READ PARAMETERS
for argument in "$@"
do
  key=$(echo $argument | cut -f1 -d=)

  keyLength=${#key}
  value="${argument:$keyLength+1}"

  export "$key"="$value"
done

# LOCAL REPOSITORY UPDATE
git fetch --all
git pull


# PREPARE FUNCTION AND INITAL VARIABLES
echo \#=======================================================\#
echo 
timeAgo="${timeAgo:-$defaultTimeAgo}"
showAllBranchs="${showAllBranchs:-false}"
echo \# timeAgo=$timeAgo
echo \# showAllBranchs=$showAllBranchs
echo 
echo \#=======================================================\#

function checkBlackList # ( value ) 
{
  local e
  for e in "${branchesInBlackList[@]}"; do 
    [[ "$e" == "$1" ]] && return 1;
  done
  return 0          # Zero enter on 'if'
}


function checkLastCommit # ( value ) 
{
  cmdCheckTime="git log -1 --since='$timeAgo ago' -s $1 | less -F"
  # echo $cmdCheckTime
  # echo $(eval $cmdCheckTime)
  if [ $(eval $cmdCheckTime | wc -l) == 0 ] ; then
    return 0          # Zero enter on 'if'
  fi
  return 1
}

# echo ==$showAllBranchs
# BEGIN: LIST ALL BRANCHS WITH DATE
if [ $showAllBranchs = "true" ]; then
  echo 
  echo ALL BRANCHES
  echo 
  for branch in `git branch -r | grep -v HEAD`;do 
    echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; 
  done | sort -r
  echo 
fi
# END: LIST ALL BRANCHS WITH DATE

echo \#=======================================================\#
echo 
for k in $(git branch -r | sed /\*/d | sed 's/^.* -> \(.*\)$/\1/'); do 
  if [ -n "$k" ]; then
    shortName=${k/origin\//}
    if [ -n "$(git ls-remote origin $shortName)" ]; then
      if checkBlackList "$k" ; then
        # echo "branch = $k"
        if checkLastCommit "$k" ; then
          lastCommitDate=$(git log -1 --format=%cd $k)
          
          echo
          echo \# $lastCommitDate
          echo git push origin --delete $shortName
          echo

        fi
      fi
    fi
  fi
done

echo \#=======================================================\#
