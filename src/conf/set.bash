_conf_set()
{
    local name="${1}"
    local value="${2}"
    local filename="${3}"
    if [[ -z "${filename}" ]] || [[ ! -f "${filename}" ]]; then
        filename="${APPLICATION_CONFIG}"
    fi
    echo "${name} ${value}" >> "${filename}"
}