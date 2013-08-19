_lock_remove()
{
    if [[ -z "${DEPLOY_LOCK_FILE}" ]]; then
        return 1
    fi

    if [[ ! -f "${DEPLOY_LOCK_FILE}" ]]; then
        return 2
    fi

    sudo rm -f "${DEPLOY_LOCK_FILE}"
}
