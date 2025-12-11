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

## Setup for New Mac

There are a couple of "chicken and egg" problems. To install `chezmoi` and apply the dotfiles repository you have to have the PAT so you can log in. And since the `Brewfile` is in this repository you can't do `brew bundle install` to get Bitwarden installed to get the token. So you have to use the web vault. And that requires the Yubikey be setup.

### Install Homebrew

On EG Macs you can't install `brew` via the official method. Instead, you have to use a script provided by eIT. The KB article [BeyondTrust Privilege Management: Homebrew Install & Dev notes](https://expedia.service-now.com/askeg?id=kb_article&sys_id=8ea0523747df56d8b50b19fab46d435c&table=kb_knowledge&searchTerm=install%20brew) contains the script (installBrew.sh)[https://expedia.service-now.com/sys_attachment.do?sys_id=c2a0de7747df56d8b50b19fab46d43a9]


## References

Here is a partial list of github repositories I have looked at that have helped me learn `chezmoi`
or that I have used as "inspiration" for how I manage my dot files.

* [treid/dotfiles](https://github.expedia.biz/treid/dotfiles)
* [age](https://github.com/FiloSottile/age) for encryption and decryption
* [Bootstrap Repositories](http://dotfiles.github.io/bootstrap/)
* [Inspiration](https://dotfiles.github.io/inspiration)
* [Take back your dotfiles with
Chezmoi](https://fedoramagazine.org/take-back-your-dotfiles-with-chezmoi/)
* [twpayne/dotfiles](https://github.com/twpayne/dotfiles)
* [webpro/awesom-dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Brew Bundle Brewfile Tips](https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f#brew-bundle-brewfile-tips)