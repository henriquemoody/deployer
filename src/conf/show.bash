_conf_show()
{
    local name=$(_conf_get Name)
    local directory=$(_conf_get Directory)
    local repository=$(_conf_get Repository)
    local file_system_owner=$(_conf_get FileSystemOwner)
    local file_system_group=$(_conf_get FileSystemGroup)
    local ssh_connection_timeout=$(_conf_get SshConnectionTimeout)
    local ssh_user=$(_conf_get SshUser)
    local ssh_port=$(_conf_get SshPort)
    local ssh_private_key_file=$(_conf_get SshPrivateKeyFile || echo "<35>None<0>")
    local new_relic_notification=$(_conf_get NewRelicNotification)
    local new_relic_api_key=$(_conf_get NewRelicApiKey || echo "<35>None<0>")
    local new_relic_application_id=$(_conf_get NewRelicApplicationId || echo "<35>None<0>")
    local settings_directory="${SETTINGS_DIRECTORY}"

    _echo "<32>Global settings<0>"
    _echo
    _echo "* <33>Settings directory<0>: ${settings_directory}"
    _echo
    _echo "<32>Environment settings for \"<32;1>${ENVIRONMENT}<0><32>\"<0>"
    _echo
    _echo "* <33>Name<0>: ${name}"
    _echo "* <33>Directory<0>: ${directory}"
    _echo "* <33>Repository<0>: ${repository}"
    _echo "* <33>File system owner<0>: ${file_system_owner}"
    _echo "* <33>File system group<0>: ${file_system_group}"
    _echo "* <33>SSH connection timeout<0>: ${ssh_connection_timeout}"
    _echo "* <33>SSH user<0>: ${ssh_user}"
    _echo "* <33>SSH port<0>: ${ssh_port}"
    _echo "* <33>SSH private key file<0>: ${ssh_private_key_file}"
    _echo "* <33>New Relic notification<0>: ${new_relic_notification}"
    _echo "* <33>New Relic API key<0>: ${new_relic_api_key}"
    _echo "* <33>New Relic application ID<0>: ${new_relic_application_id}"
    _echo
}
