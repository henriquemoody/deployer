_conf_get()
{
    echo $(grep "${1}" "${DEFAULT_CONFIG}" || grep "${1}" "${ENVIRONMENT_CONFIG}") |
        egrep -v '^#' |
        cut -d ' ' -f 2-

    return ${?}
}