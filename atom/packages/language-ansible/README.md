# Ansible Syntax Highligting Package

This extension to enable syntax highlighting for Ansible in the Atom Editor.
It's based on the [original Ansible Sublime-text package](https://github.com/clifford-github/sublime-ansible) with my own fixes.


## Adding ansible yaml file detection

For now both methods doesn't support syntax highlighting based on path see (host_vars/group_vars)
below.

### Using file-types package

After installing _file-types_ package user can define custom syntax associations for proper matching.

#### config.cson

```json
"*":
  "file-types":
    ".*.yml$": "source.ansible"
    ".*/group_vars/.*": "source.ansible"
    ".*/host_vars/.*": "source.ansible"
```

### Atom Custom File Types

Manually defining custom file types.

```json
"*":
  core:
    customFileTypes:
      "source.ansible": [
        "yml"
      ]
```

