# dotfiles

My dot files managed by [chezmoi](https://www.chezmoi.io).

These are my "dot files", the files I want on a machine I'm going to use. It can be a new Mac laptop
or a Linux server. These files include my shell initialization files (like `.bashrc`) as well as
other configuration files (like `~/.ssh/authorized_keys`).

The [chezmoi installation](https://www.chezmoi.io/install/) has comprehensive installation
instructions. The simplest and easiest way is a one-liner:

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $(id -un)
```

This works if your dotfiles repository is a public repository on `github.com`. If your repository is
not public you can provide the full URL.

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply "https://github.com/$(id -un)/dotfiles"
```

## Encryption

To encrypt files managed by `chezmoi` two things are required. There
must be configuration in the `.config/chezmoi/chezmoi.toml` file. And
you must have the `age` key file created somewhere via the
`age-keygen` file. You can create one via the command:

```
age-keygen -o ${HOME}/age.txt

```

It isn't required to have age installed on all systems where your dot files are deployed. It only
needs to be install on one system so you can use the `age-keygen` command.


