moveProxiesToSync() {
  proxies=()
  begin=0
  cat $1
  cat $2
  while read -r line; do
    echo $line
    if [[ $begin == 1 ]]; then
      if [[ $line =~ "^[ ]*-.*$" ]]; then
        proxies+=("$line")
      else
        break;
      fi
    fi
    if [[ $line =~ "^proxies:" ]]; then
      echo 123123123123123
      begin=1
    fi
  done < "$1"

  for proxy in "${proxies[@]}"; do
    echo $proxy >> "$2"
  done
}
