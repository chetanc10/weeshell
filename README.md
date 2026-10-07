# weeshell

This is a WEE enabled shell environment enhancements for bash, zsh, fish and powershell.

Using a collection of mise-tomls and scripts, users can enhance their shells using generic but widely helping shortcuts and environment controls.

## Prerequisites
Must have - System must have already installed https://github.com/jdx/mise tool which is the basis of using weeshell

Good to have - Users can pre-install wee tool from https://github.com/chetanc10/wee that works along with mise to help users setup and maintain many wee enabled repos.

# Installation
## With mise
The repo can be cloned or it can downloaded or a set of files can be downloaded and copied to relevant bin path that is already added to PATH.

## With wee
For systems already having wee installed:
1. Install weeshell using wee: ```wee install https://github.com/chetanc10/weeshell```
2. ```cd ~/.config/mise/ ; wee add chetanc10/weeshell ; cd -``` => installs the toml and OS specific scripts globally
3. ```cd ~/.config/mise/ ; wee remove chetanc10/weeshell ; cd -``` => removes the toml and OS specific scripts globally

## ✨ Features for bash
- base.toml can be added to global mise conf.d to setup shell specific environment defaults
  - Customized History file limits
  - Simplified prompt with just current base directory name
  - other bash generic stuff to be added soon
- Background History de-duplicator

## ✨ Features for zsh, fish and powershell shall be added in future

### Commands
Following commands are added to PATH.
- naping - Network address pinger that can go to background and notify user on a ping success
- procwait - Process waiter that waits for a process in background and notifies user on process completion
- dedup - De-duplicator to remove duplicate files from a directory recursively
