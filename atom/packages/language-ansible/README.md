# Ansible Syntax Highligting Package

This extension is trying to make syntax highliting for Ansible better on Atom Editor.
It's based on [original Ansible Sublime-text package](https://github.com/clifford-github/sublime-ansible) with my own fixes.


## Adding ansible yaml file detection

For now both methods doesn't support syntax highliting based on path see (host_vars/group_vars)
below.

### Using file-types package

After intalling _file-types_ package user can define custom syntax associations for proper matching.

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

