_lock_create()
{
    echo ${SCRIPT_PID} |
        sudo tee "${DEPLOY_LOCK_FILE}" > /dev/null

    sudo chmod 0600 "${DEPLOY_LOCK_FILE}"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${DEPLOY_USER}: ${DEPLOY_TYPE} of ${GIT_TREE_ISH} on ${ENVIRONMENT}" |
        sudo tee -a "${DEPLOYER_LOG}" > /dev/null
}
