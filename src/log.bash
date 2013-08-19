_log()
{
    local message
    local category
    local filename
    local content

    if [ -t 0 ] || [[ ${#} -eq 3 ]]; then
        message="${1}"
        category="${2}"
        filename="${3}"
    else
        while read line; do
            _log "${line}" "${1}" "${2}"
        done < /dev/stdin
        return 0
    fi

    if [[ -z "${category}" ]]; then
        category='debug'
    fi
    category=$(echo "${category}" | tr [A-Z] [a-z])

    if [[ -z "${DEPLOY_LOG_FILENAME}" ]]; then
        return 1
    fi

    if [[ -z "${filename}" ]]; then
        filename="${DEPLOY_LOG_FILENAME}"
    fi

    if [[ ! -f "${filename}" ]]; then
        touch "${filename}"
    fi

    content="[$(date '+%Y-%m-%d %H:%M:%S')] [${category}] ${message}"
    echo "${content}" >> "${filename}"
}
