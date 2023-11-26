show_keys_enabled() {
  local index=$1
  local icon="$(get_tmux_option "@catppuccin_keys_enabled_icon" "#([ \$(tmux show-option -qv key-table) = 'off' ] && echo '󰌐' || echo '󰌌')")"
  local color="$(get_tmux_option "@catppuccin_keys_enabled_color" "#([ \$(tmux show-option -qv key-table) = 'off' ] && echo \"#ed8796\" || echo \"#f5a97f\")")"
  local text="$(get_tmux_option "@catppuccin_keys_enabled_text" "#([ \$(tmux show-option -qv key-table) = 'off' ] && echo 'OFF' || echo 'ON')")"

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
