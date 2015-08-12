export PATH=/opt/texbin:$PATH
export INFOPATH=/usr/local/texlive/2015/texmf-dist/doc/info:$INFOPATH
export MANPATH=/usr/local/texlive/2015/texmf-dist/doc/man:$MANPATH
if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi
rm ~/.lastdir
if [ -r ~/.local_profile ]; then . ~/.local_profile; fi

