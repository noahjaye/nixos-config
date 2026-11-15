show_all=0
root=.

if [ "${1:-}" = -a ]; then
  show_all=1
fi
c_unstaged=$'\033[31m'
c_staged=$'\033[32m'
c_clean=$'\033[38;5;33m'
c_reset=$'\033[0m'

results=()

while IFS= read -r -d '' g; do
  d=$(dirname "$g")
  s=$(git -C "$d" status --porcelain 2>/dev/null) || continue

  flag=clean rank=2
  if [ -n "$s" ]; then
    flag=staged rank=1
    if grep -q '^.[^ ]' <<<"$s"; then
      flag=unstaged rank=0
    fi
  fi

  if [ "$flag" = clean ] && [ "$show_all" -eq 0 ]; then
    continue
  fi

  results+=("$rank"$'\t'"$d"$'\t'"$flag")
done < <(fd -H -I -0 '^\.git$' "$root")

[ "${#results[@]}" -eq 0 ] && exit 0

printf '%s\n' "${results[@]}" | sort -t $'\t' -k1,1n -k2,2 |
  while IFS=$'\t' read -r _ d flag; do
    case $flag in
      unstaged) color=$c_unstaged ;;
      staged)   color=$c_staged ;;
      *)        color=$c_clean ;;
    esac
    printf '%s %s[%s]%s\n' "$d" "$color" "$flag" "$c_reset"
  done
