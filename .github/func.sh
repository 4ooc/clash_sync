getRemoteFile(){
   repositoryUrl=$1
   branchName=$2
   fileName=$3
   type=${4:-clash}
   repositoryName=${repositoryUrl##*/}
   git remote add "$repositoryName" "$repositoryUrl"
   git fetch $repositoryName --depth=3
   if [[ -z $fileName ]]; then
      fileName=$(git diff --name-only --diff-filter=AMT "$repositoryName"/"$branchName"~2 "$repositoryName"/"$branchName"  | xargs -I{} -- git log -1  --remotes="$repositoryName"  --format="%ci {}" -- {} | sort | tail -1 | cut -d " " -f4)
   fi
   
   git diff --name-only --diff-filter=AMT "$repositoryName"/"$branchName"~1 "$repositoryName"/"$branchName" | tail -1
   if [[ -z $fileName ]]; then
      return
   fi
   echo "file--" $fileName
   git checkout $repositoryName/$branchName "$fileName"
   mv $fileName ${type}_$fileName
   git rm -rf "$fileName"
}

moveProxiesToSync() {
  proxies=()
  begin=0
  while read -r line; do
    if [[ $begin == 1 ]]; then
      if [[ $line =~ "- {" ]]; then
        proxies+=("$line")
      else
        break;
      fi
    fi
    if [[ $line =~ "proxies:" ]]; then
      begin=1
    fi
  done < "$1"

  for proxy in "${proxies[@]}"; do
    echo $proxy >> "$2"
  done
}
