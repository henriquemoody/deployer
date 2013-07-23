_lock_create()
{
    echo ${!} > "${DEPLOY_LOCK_FILE}"
    chmod 0600 "${DEPLOY_LOCK_FILE}"

    return ${?}
}