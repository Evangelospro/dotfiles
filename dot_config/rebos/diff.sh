#!/usr/bin/env bash
set -euo pipefail

rebos_output=$(rebos gen info 2>/dev/null || true)

# Function to extract packages/items for a specific manager from rebos output
extract_rebos_items() {
	local manager="$1"
	printf '%s\n' "$rebos_output" \
		| awk '/^\[Info\] : '"$manager"':/{flag=1; next} /^\[Info\] :/{flag=0} flag && /^\s*: /{sub(/^\s*:\s*/,"",$0); print $0}' \
		| sed 's/^\s*//;s/\s*$//' \
		| grep -v '^$' || true
}

# Function to get explicitly installed items (not dependencies) for a specific manager
get_installed_items() {
	local manager="$1"
	case "$manager" in
		system)
			if command -v pacman >/dev/null 2>&1; then
				pacman -Qqe 2>/dev/null || pacman -Qq 2>/dev/null || true
			elif command -v apt >/dev/null 2>&1; then
				apt-mark showmanual 2>/dev/null || dpkg-query -f '${binary:Package}\n' -W 2>/dev/null || true
			elif command -v dnf >/dev/null 2>&1; then
				dnf repoquery --installed --userinstalled --qf '%{name}\n' 2>/dev/null || rpm -qa --qf '%{NAME}\n' 2>/dev/null || true
			elif command -v zypper >/dev/null 2>&1; then
				zypper se -i --userinstalled 2>/dev/null | awk 'NR>4 {print $3}' || zypper se -i 2>/dev/null | awk 'NR>4 {print $3}' || true
			elif command -v apk >/dev/null 2>&1; then
				apk list -i 2>/dev/null | awk -F' ' '{print $1}' || true
			elif command -v yum >/dev/null 2>&1; then
				yum list installed 2>/dev/null | awk '{print $1}' | sed 's/\..*$//' || true
			elif command -v brew >/dev/null 2>&1; then
				brew list 2>/dev/null || true
			elif command -v rpm >/dev/null 2>&1; then
				rpm -qa --qf '%{NAME}\n' 2>/dev/null || true
			else
				true
			fi
			;;
		gem)
			if command -v gem >/dev/null 2>&1; then
				gem list --local 2>/dev/null | awk '{print $1}' || true
			else
				true
			fi
			;;
		pip)
			if command -v pip >/dev/null 2>&1; then
				pip list 2>/dev/null | awk 'NR>2 {print $1}' || true
			else
				true
			fi
			;;
		pip3)
			if command -v pip3 >/dev/null 2>&1; then
				pip3 list 2>/dev/null | awk 'NR>2 {print $1}' || true
			else
				true
			fi
			;;
		pypy)
			if command -v pypy3 >/dev/null 2>&1; then
				pypy3 -m pip list 2>/dev/null | awk 'NR>2 {print $1}' || true
			else
				true
			fi
			;;
		uvx)
			if command -v uvx >/dev/null 2>&1; then
				uvx 2>/dev/null| grep -E '^- ' | sed 's/^- //;s/ v[0-9].*$//' || true
			else
				true
			fi
			;;
		groups)
			getent group 2>/dev/null | awk -F':' '{print $1}' || true
			;;
		systemd-system)
			if command -v systemctl >/dev/null 2>&1; then
				systemctl list-unit-files --type=service --all 2>/dev/null | awk '{print $1}' | sed 's/\.service$//' | grep -v '^UNIT' | grep -v '^$' || true
			else
				true
			fi
			;;
		systemd-user)
			if command -v systemctl >/dev/null 2>&1; then
				systemctl --user list-unit-files --type=service --all 2>/dev/null | awk '{print $1}' | sed 's/\.service$//' | grep -v '^UNIT' | grep -v '^$' || true
			else
				true
			fi
			;;
		*)
			true
			;;
	esac
}

# Function to get dependencies of a package for a specific manager
get_dependencies() {
	local manager="$1"
	local package="$2"
	case "$manager" in
		system)
			if command -v pacman >/dev/null 2>&1; then
				pacman -Qi "$package" 2>/dev/null | grep 'Depends On' | sed 's/Depends On.*: //' | tr ' ' '\n' | sed 's/[<>=].*$//' || true
			elif command -v apt >/dev/null 2>&1; then
				apt-cache depends "$package" 2>/dev/null | grep 'Depends:' | awk '{print $2}' || true
			elif command -v dnf >/dev/null 2>&1; then
				dnf repoquery --requires "$package" 2>/dev/null | grep -v "^$package" || true
			elif command -v brew >/dev/null 2>&1; then
				brew deps "$package" 2>/dev/null || true
			else
				true
			fi
			;;
		gem)
			if command -v gem >/dev/null 2>&1; then
				gem dependency "$package" 2>/dev/null | grep '(' | awk '{print $1}' || true
			else
				true
			fi
			;;
		pip|pip3)
			if command -v pip >/dev/null 2>&1; then
				pip show "$package" 2>/dev/null | grep 'Requires:' | sed 's/Requires: //' | tr ',' '\n' | sed 's/^\s*//;s/\s*$//' | sed 's/[<>=;].*$//' || true
			else
				true
			fi
			;;
		pypy)
			if command -v pypy3 >/dev/null 2>&1; then
				pypy3 -m pip show "$package" 2>/dev/null | grep 'Requires:' | sed 's/Requires: //' | tr ',' '\n' | sed 's/^\s*//;s/\s*$//' | sed 's/[<>=;].*$//' || true
			else
				true
			fi
			;;
		*)
			true
			;;
	esac
}

# Function to filter out dependencies of packages in a list
filter_dependencies() {
	local manager="$1"
	local keep_packages_file="$2"

	# Create a set of all dependencies of packages we want to keep
	local tmp_deps=$(mktemp)
	tmp_files+=("$tmp_deps")

	while read -r package; do
		[ -z "$package" ] && continue
		get_dependencies "$manager" "$package" >> "$tmp_deps" || true
	done < "$keep_packages_file"

	# Read from stdin and filter out packages that are dependencies
	while read -r package; do
		[ -z "$package" ] && continue
		if ! grep -q "^${package}$" "$tmp_deps" 2>/dev/null; then
			echo "$package"
		fi
	done
}

# Extract all manager sections from rebos output
managers=$(printf '%s\n' "$rebos_output" | awk '/^\[Info\] : /{match($0, /\[Info\] : ([^:]+):/, arr); if(arr[1]) print arr[1]}' | sort -u)

# Temporary files
tmp_files=()
trap 'rm -f "${tmp_files[@]}"' EXIT

# Process each manager
for manager in $managers; do
	rebos_items=$(extract_rebos_items "$manager")
	installed_items=$(get_installed_items "$manager")

	# Create temp files for this manager
	tmp_rebos=$(mktemp)
	tmp_sys=$(mktemp)
	tmp_files+=("$tmp_rebos" "$tmp_sys")

	printf '%s\n' "$rebos_items" | sort -u > "$tmp_rebos"
	printf '%s\n' "$installed_items" | sed '/^$/d' | sort -u > "$tmp_sys"

	# Filter out packages that are dependencies of packages in rebos
	tmp_sys_filtered=$(mktemp)
	tmp_files+=("$tmp_sys_filtered")
	cat "$tmp_sys" | filter_dependencies "$manager" "$tmp_rebos" > "$tmp_sys_filtered"

	# Only output if there are differences
	only_system=$(comm -23 "$tmp_sys_filtered" "$tmp_rebos" 2>/dev/null | wc -l)
	only_rebos=$(comm -13 "$tmp_sys" "$tmp_rebos" 2>/dev/null | wc -l)

	if [ "$only_system" -gt 0 ] || [ "$only_rebos" -gt 0 ]; then
		echo
		echo "=== $manager ==="
		if [ "$only_system" -gt 0 ]; then
			echo
			echo "Installed but not in rebos:"
			comm -23 "$tmp_sys_filtered" "$tmp_rebos" || true
		fi
		if [ "$only_rebos" -gt 0 ]; then
			echo
			echo "In rebos but not installed:"
			comm -13 "$tmp_sys" "$tmp_rebos" || true
		fi
	fi
done

exit 0
