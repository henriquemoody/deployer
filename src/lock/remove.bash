_lock_remove()
{
    local code="${1:-0}"

    sudo rm -f "${DEPLOY_LOCK_FILE}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${DEPLOY_USER}: removing "${DEPLOY_LOCK_FILE}" (code ${code})" |
        sudo tee -a "${DEPLOY_LOG_FILENAME_GLOBAL}" > /dev/null
}
