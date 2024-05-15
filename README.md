# dotfiles
My dot files managed by chezmoi

## Intial Install and Setup

The first step is to install `chezmoi`. For a Mac, it is possible to
install via `brew`. For Linux machines it's easier to pull the
binary. That will also work with a Mac.

If you want to use an SSH based `git` URL you'll need to have `git`
installed on the system. If you use an HTTP URL `chezmoi` can clone
the repo.

## Encryption

To decrypt files managed by `chezmoi` two things are required. There
must be configuration in the `.config/chezmoi/chezmoi.toml` file. And
you must have the `age` key file created somewhere via the
`age-keygen` file. You can create one via the command:

```
age-keygen -o ${HOME}/age.txt
```

