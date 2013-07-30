_conf_get()
{
    local config_filename="${2}";

    if [[ -z "${config_filename}" ]]; then
        config_filename="${ENVIRONMENT_CONFIG}"
    fi

    echo $(grep "${1}" "${config_filename}" || grep "${1}" "${APPLICATION_CONFIG}") |
        egrep -v '^#' |
        cut -d ' ' -f 2-

    return ${?}
}