_exit()
{
    local code=${1:-255}

    if [[ ${SUDO_PRIVILEGES} -eq 1 ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${DEPLOY_USER}: Finished script with code: ${code}" |
            sudo tee -a "${DEPLOYER_LOG}" > /dev/null
        _lock_remove
    fi

    _log "Finished script with code ${code}"
    exit ${code}
}
