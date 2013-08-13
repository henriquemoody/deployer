_conf_get()
{
    local name="${1}";
    local filename="${2}";

    if [[ -z "${filename}" ]]; then
        filename="${ENVIRONMENT_CONFIG}"
    fi

    _conf_read "${filename}" "${name}" ||
        _conf_read "${APPLICATION_CONFIG}" "${name}"
}
