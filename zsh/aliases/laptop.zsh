fanMode() {
  local file=/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy

  # If no argument → show current value
  if [[ -z "$1" ]]; then
    local val
    val=$(cat "$file" 2>/dev/null) || { echo "Cannot read policy file"; return 1; }

    case "$val" in
      0) mode="performance" ;;
      1) mode="turbo" ;;
      2) mode="silent" ;;
      *) mode="unknown" ;;
    esac

    echo "Current mode: $mode ($val)"
    return 0
  fi

  # If argument provided → set value
  case "$1" in
    turbo) val=1 ;;
    performance) val=0 ;;
    silent) val=2 ;;
    0|1|2) val="$1" ;;   # allow raw numeric too
    *)
      echo "Usage: fan {turbo|performance|silent|0|1|2}"
      return 1
      ;;
  esac

  echo $val | sudo tee "$file" >/dev/null
}
