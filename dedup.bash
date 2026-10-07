#!/bin/bash

gUsageString="
Removes duplicate files by walking through all files in a directory

Usage: dedup [Arguments]
Arguments: All optional
    -h              - displays this help message & exits (discards other args)
    -d              - Shows preview of deletions without removing files
                      Default - Deletes duplicates
    /path/to/folder - If specified, use user-given path to de-duplicate.
                      Default - PWD
"
_usage ()
{
	printf "$gUsageString\n\n"
	exit $1
}

dry_run=false
target_dir="${PWD}"

# Parse the options
while [[ $# -gt 0 ]]; do
	case "$1" in
		-h) _usage 0 ;;
		-d) dry_run=true ; shift 1 ;;
		*) [ ! -d "$1" ] && echo "Invalid argument: $1" && _usage -1
			target_dir="$1" ; shift 1
			;;
	esac
done

tmp_md5="/tmp/md5sums_$(basename $(realpath $target_dir)).txt"
rm -rf "$tmp_md5"

# Generate MD5 + size list for all files recursively
find "$target_dir" -type f -print0 | while IFS= read -r -d '' file; do
	size=$(stat -c%s "$file" 2>/dev/null || echo "0")
	md5=$(md5sum "$file" 2>/dev/null | cut -d' ' -f1)
	rel_path="${file#$target_dir/}"
	echo -ne "$md5 $size $rel_path\r"
	echo "$md5 $size $rel_path" >> "$tmp_md5"
done
echo -ne "\033[K"

[ ! -s "$tmp_md5" ] && echo "$target_dir: No files found!" && exit 0

# Remove duplicates based on MD5 hash
declare -A seen
declare -A fseen
dup_bytes=0
dup_cnt=0
while IFS=' ' read -r md5 size path; do
	# skip empty md5 strings and md5s for empty files
	# empty files give d41d8cd98f00b204e9800998ecf8427e
	([ -z "$md5" ] || [ "$md5" == "d41d8cd98f00b204e9800998ecf8427e" ]) && continue
	[[ -z "${seen[$md5]}" ]] && seen[$md5]=1 && fseen[$md5]="$path" && continue
	full_path="$target_dir/$path"
	echo -ne "\nDuplicate: $full_path ||| Original: $target_dir/${fseen[$md5]}"
	! $dry_run && rm -f "$full_path"
	((dup_cnt++))
	dup_bytes=$((dup_bytes+$size))
done < "$tmp_md5"

rm -f "$tmp_md5"

[ $dup_cnt -eq 0 ] && echo "$target_dir: No duplicates found!" && exit 0

[ $dup_bytes -gt 1024 ] && dup_bytes=$((dup_bytes/1024)) && dup_sz="$dup_bytes KB"
[ $dup_bytes -gt 1024 ] && dup_bytes=$((dup_bytes/1024)) && dup_sz="$dup_bytes MB"
[ $dup_bytes -gt 1024 ] && dup_bytes=$((dup_bytes/1024)) && dup_sz="$dup_bytes GB"

echo -e "\n\n----------------------------------------"
echo "Summary: Duplicates count = $dup_cnt, size = $dup_sz"
$dry_run && echo "Duplicates not deleted as this is a dry run" || echo "Duplicates deleted"
echo -e "----------------------------------------"

exit 0
