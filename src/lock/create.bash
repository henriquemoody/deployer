_lock_create()
{
    echo ${$} | sudo tee "${DEPLOY_LOCK_FILE}" > /dev/null
    sudo chmod 0600 "${DEPLOY_LOCK_FILE}"
}