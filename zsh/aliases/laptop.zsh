fanMode() {
  local policy_file=/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy

  # Collect governor paths as a fallback if cpupower is missing
  local gov_paths=()
  for g in /sys/devices/system/cpu/cpufreq/policy*/scaling_governor \
           /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [[ -f "$g" ]] && gov_paths+=("$g")
  done

  # 🧐 No argument → show current state
  if [[ -z "$1" ]]; then
    if [[ -r "$policy_file" ]]; then
      local cur mode
      cur=$(cat "$policy_file" 2>/dev/null)
      case "$cur" in
        0) mode="performance" ;;
        1) mode="turbo" ;;
        2) mode="silent" ;;
        *) mode="unknown" ;;
      esac
      echo "ASUS thermal mode: $mode ($cur)"
    else
      echo "ASUS thermal policy file not readable: $policy_file"
    fi

    if (( ${#gov_paths[@]} )); then
      # Just show first one (they should all match)
      local gov
      gov=$(cat "${gov_paths[1]}" 2>/dev/null)
      echo "CPU governor: $gov"
    else
      echo "No governor info found."
    fi
    return 0
  fi

  # 🎛 Map modes → ASUS value + governor
  local val gov_target
  case "$1" in
    turbo)
      val=1
      gov_target="performance"
      ;;
    performance)
      val=0
      gov_target="performance"
      ;;
    silent)
      val=2
      gov_target="powersave"
      ;;
    *)
      echo "Usage: fan {turbo|performance|silent}"
      return 1
      ;;
  esac

  # 🧠 Apply ASUS thermal mode
  echo "$val" | sudo tee "$policy_file" >/dev/null || {
    echo "Failed to write ASUS thermal policy ($policy_file)"
    return 1
  }

  # ⚙️ Set CPU governor: prefer cpupower, fallback to direct writes
  if command -v cpupower >/dev/null 2>&1; then
    sudo cpupower frequency-set -g "$gov_target" >/dev/null 2>&1 \
      && echo "Set CPU governor via cpupower → $gov_target" \
      || echo "cpupower failed to set governor"
  elif (( ${#gov_paths[@]} )); then
    for g in "${gov_paths[@]}"; do
      echo "$gov_target" | sudo tee "$g" >/dev/null 2>&1
    done
    echo "Set CPU governor via sysfs → $gov_target"
  else
    echo "Warning: no way to set CPU governor (cpupower not found, no sysfs paths)"
  fi

  echo "ASUS thermal policy set → $1"
}
