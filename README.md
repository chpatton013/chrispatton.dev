# chrispatton.dev

Public configuration for chrispatton.dev.

## Organization

* `/`
  * `production.sh`
    * Convenience shell script to deploy to production
    * Requires path to inventory file as first argument
  * `Vagrantfile`
    * Testing environment for configuration
* `ansible/`
  * Configuration for all machines and services
* `vagrant/`
  * Bootstrapping and variable data for testing environment

## Usage

### Production

```
./production.sh <path/to/inventory.file> [<optional-ansible-args>]
```

### Testing/development

Modify the `MACHINES` list in `Vagrantfile` to uncomment the machines you want
to test, then:

```
vagrant up --no-provision # Repeat whenever the MACHINES list changes
vagrant provision # Repeat whenever configuration files change
```

## Requirements

### Applications

* `python3`
* `pip3`

### Python Packages

See `requirements.txt`.
