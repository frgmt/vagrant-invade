# vagrant-invade

![Invade Logo](https://github.com/frgmt/vagrant-invade/blob/develop/images/invade-logo-256.png?raw=true)

[![Code Climate](https://codeclimate.com/github/frgmt/vagrant-invade/badges/gpa.svg)](https://codeclimate.com/github/frgmt/vagrant-invade)

**vagrant-invade** is a plugin for Vagrant, the tool for creating and maintain virtual machines.  
It uses a simple **YAML** configuration file to automatically build a **Vagrantfile** for your projects.

## How to install
Simply run `vagrant plugin install vagrant-invade`  
To install a certain version use the `-v 'VERSION'` option.

## Commands
There are new commands you can use to init, validate and build a Vagrantfile.

### Init
`vagrant invade init` creates the default **invade.yml** configuration file for you.

### Check
`vagrant invade check` will check the checksum of Vagrantfile and invade.yml data. Helpful to check the files without using the build command.

### Validate
`vagrant invade validate` will validate the **invade.yml** file and gives you a **detailed output of missing values, wrong parameters and defaults** for each option.

### Build
`vagrant invade build` will **build a Vagrantfile** based on what you configured in the 'invade.yml' file and place it to the directory you did run the command. The old Vagrantfile will be saved as backup. 

## Feature Support
* Box
* Network
* Provider
	* VirtualBox
	* VMWare
* Provision
	* ansible
	* ansible_local
	* puppet-agent
	* puppet-apply
	* salt
	* shell
* Synced Folder
	* VB
	* NFS (use *vagrant-winnfsd* plugin to support Windows)

**Not all features are supported yet. See source code for available options.**

With command `vagrant invade init` you can create an example invade.yml with all available options you can pick from.

### 3rd party plugins
* [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
* [vagrant-r10k](https://github.com/jantman/vagrant-r10k)
* [vagrant-winnfsd](https://github.com/winnfsd/vagrant-winnfsd)


## Development
You are able to collaborate to make this plugin even better. You just need a simple setup of ruby software to make it work. You could also use RVM to keep your ruby environment clean.

### Requirements
1. Vagrant v1.7+
2. Ruby >= 2.0.0
3. RubyGems
4. Bundler

### Setup with RVM
1. `rvm gemset create vagrant-invade`
2. `rvm gemset use vagrant-invade`
1. `gem install bundler`
2. `bundle install`

### Execute vagrant while developing a plugin
1. `bundle exec vagrant [command]`
