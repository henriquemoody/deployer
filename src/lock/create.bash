_lock_create()
{
    echo ${SCRIPT_PID} | sudo tee "${DEPLOY_LOCK_FILE}" > /dev/null
    sudo chmod 0600 "${DEPLOY_LOCK_FILE}"
}
