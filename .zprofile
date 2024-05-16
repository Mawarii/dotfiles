if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
  export XDG_CONFIG_HOME="$HOME/.config"
  export SDL_VIDEODRIVER=wayland
  export _JAVA_AWT_WM_NONREPARENTING=1
  export QT_QPA_PLATFORM=wayland
  export XDG_CURRENT_DESKTOP=sway
  export XDG_SESSION_DESKTOP=sway

  exec /usr/bin/sway
fi

# Created by `pipx` on 2023-12-01 15:18:50
export PATH="$PATH:/home/dmarkovic/.local/bin"
