# dotfiles
My dot files managed by chezmoi

## Initial Install and Setup

The first step is to install `chezmoi`. For a Mac, it is possible to
install via `brew`. For Linux machines it's easier to pull the
binary. That will also work with a Mac.

After installation the git repository has to be cloned locally and then the command `chezmoi init`
must be run, followed by `chezmoi apply`. All this can be combined into one command:

```
CHEZMOI_REPO="https://github.com/$(id -un)/initfiles"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply "${CHEZMOI_REPO}"
```

The value of `CHEZMOI_REPO` should be set to the correct URL of the repository for your init files.
If the repository is a public repository on `github.com` `CHEZMOI_REPO` can be set as the user name.
If you want to use an SSH based `git` URL you'll need to have `git`
installed on the system. If you use an HTTP URL `chezmoi` can clone
the repository with its built-in `git` client.

## Encryption

To decrypt files managed by `chezmoi` two things are required. There
must be configuration in the `.config/chezmoi/chezmoi.toml` file. And
you must have the `age` key file created somewhere via the
`age-keygen` file. You can create one via the command:

```
age-keygen -o ${HOME}/age.txt
```

