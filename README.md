# subversion-formula
This is a salt formula to install subversion, create a subversion repository, and expose the repository via http using apache.

*If you use this in a prod setting you'll want to refactor the way security is handled by default.*

## Dependencies
This formula depends on https://github.com/saltstack-formulas/apache-formula. I've forked a tracking repo here https://github.com/mauricecarey/apache-formula that includes install of apache-utils under Debian based OS.

## TODO
Need to update for OS other than Ubuntu.
Refactor the default user/pass for the SVN realm.
