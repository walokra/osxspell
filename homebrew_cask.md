# Update VoikkoSpellService Homebrew Cask

See more Contributing: `https://github.com/caskroom/homebrew-cask/blob/master/CONTRIBUTING.md`

Fork the *homebrew-cask* repository and add it as a remote for your homebrew-cask Tap:

```
$ github_user='<my-github-username>'
$ cd "$(brew --repository)"/Library/Taps/homebrew/homebrew-cask
$ git remote add "${github_user}" "https://github.com/${github_user}/homebrew-cask"
```

## Editing a Cask

```
$ cd "$(brew --repository)"/Library/Taps/caskroom/homebrew-cask
$ git checkout -b update-voikkospellservice
$ brew edit voikkospellservice
$ git add Casks/voikkospellservice.rb 
$ git diff --cached
$ git commit -v
```

### Testing Your New Cask

```
$ export HOMEBREW_NO_AUTO_UPDATE=1
$ brew install voikkospellservice
$ brew audit --new-cask voikkospellservice
$ brew style --fix voikkospellservice
$ brew uninstall voikkospellservice
```

### Submitting Your Changes

```
$ cd "$(brew --repository)"/Library/Taps/caskroom/homebrew-cask
$ git status
```

Make a feature branch that you'll use in your pull request:

```
$ git checkout -b voikkospellservice
```

Stage your Cask with 

```
$ git add Casks/voikkospellservice.rb 
```

View the changes that are to be committed with 

```
$ git diff --cached
```

Commit your changes with 

```
$ git commit -v
```

Push your changes to your GitHub account:

```
$ github_user='<my-github-username>'
$ git push "$github_user" voikkospellservice
```

### Filing a Pull Request on GitHub

Now go to your GitHub repository at <https://github.com/<user>/homebrew-cask>, 
switch branch to your topic branch and click the 'Pull Request' button. 
You can then add further comments to your pull request.

### Cleaning up

After your Pull Request is away, you might want to get yourself back onto master, so that brew update will pull down new Casks properly.

```
$ cd "$(brew --repository)"/Library/Taps/caskroom/homebrew-cask
$ git checkout master
$ unset HOMEBREW_NO_AUTO_UPDATE
```
