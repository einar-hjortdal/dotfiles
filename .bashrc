# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# >>> elio shell integration >>>
elio() {
    case "${1-}" in
        shell|portal|-*)
            command elio "$@"
            return $?
            ;;
    esac

    local arg tmp cwd status_code
    for arg in "$@"; do
        case "$arg" in
            --chooser-file|--chooser-file=*)
                command elio "$@"
                return $?
                ;;
        esac
    done

    tmp="$(mktemp -t "elio-cwd.XXXXXX")" || return
    command elio --cwd-file "$tmp" "$@"
    status_code=$?

    if [ -s "$tmp" ]; then
        cwd="$(cat -- "$tmp")"
        rm -f -- "$tmp"
        if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ]; then
            cd -- "$cwd" || return $?
        fi
    else
        rm -f -- "$tmp"
    fi

    return "$status_code"
}
# <<< elio shell integration <<<
