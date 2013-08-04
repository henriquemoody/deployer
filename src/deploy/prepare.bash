_deploy_prepare()
{
    local server_name="${1}"
    local server_address="${2}"
    local server_log_filename="${DEPLOY_LOG_BASE}-${server_name}.log"

    case "${DEPLOY_TYPE}" in
        rollback )
            _deploy_prepare_rollback "${server_address}" >> "${server_log_filename}" 2>&1
        ;;
        upgrade )
            _deploy_prepare_upgrade "${server_address}" >> "${server_log_filename}" 2>&1
        ;;
        *)
            _echo "<31>Inválid deploy type<0>" 1>&2
            exit 1
        ;;
    esac

    code=${?}

    if [[ ${code} -gt 0 ]]; then
        _echo "<31>Failure when syncing server ${server_name} (${server_address})<0>" 1>&2
    else
        _echo "<32>Success on syncing server ${server_name} (${server_address})<0>"
    fi

    return ${code}
}