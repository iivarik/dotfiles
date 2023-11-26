show_temp() {
  local index=$1
  local icon="$(get_tmux_option "@catppuccin_temp_icon" "")"
  local color="$(get_tmux_option "@catppuccin_temp_color" "$thm_red")"
  local text="$(get_tmux_option "@catppuccin_temp_text" "#( echo \$(sensors | grep 'Package' | awk '{ print \$4 }' | tr -d '+') )")"

  if [ ! -z "$(sensors | grep 'Package')" ]; then
    local module=$( build_status_module "$index" "$icon" "$color" "$text" )

    echo "$module"
  fi
}
