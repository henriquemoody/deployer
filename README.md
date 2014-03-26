# Deployer

Bash script to perform distributed deployments using Git.

Currently *deployer* has only have multi-environment support, but there are plans
to support multi-applications.

## Installing

You just have to clone the repository into some directory, like:

```bash
git clone git@github.com:henriquemoody/deployer.git /usr/local/deployer
```

To create a global link of the `deploy` script just run `make install`, like:

```bash
cd /usr/local/deployer
make install
```

## Available options

```bash
Usage: deploy OPTIONS

  --help, -h          Displays this help
  --upgrade, -u       Upgrade deploy script
  --version, -V       Displays the script version

Required options

  --env, -e           Environment to deploy
  --tree-ish, -i      Tree-Ish (branch or tag name, default "master")
  --type, -t          Type of deploy ("upgrade" or "rollback")

Other options

  --config, -c        Displays configuration information
  --repository, -r    Git repository URL
  --verbose, -v       Enable verbose mode
  --yes, -y           Performs the deployment without asking
```
