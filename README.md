## ssbt (Simple Stupid Backup Tool)

You create a backup on your machine and ssbt will periodically
collect and archive it.

* Simple (no database, just filesystem and a config)
* Secure (using chrooted sftp)
* Archive old backups
* First class FreeBSD support


## But why yet another backup solution?

Backups should be simple and reliable to make sure they are as painless as
possible. I know there are a lot of tools out there with fancy webinterfaces,
agents for whatever service you might run, multiuser, cross platform and much
more. You will not find any of those features here.

What you will find is a simple shellscript which will periodically log into
your machines with sftp(1) and pull tar archives from there which get archived.

You can continue to create your backups with tar(1) and be sure those are
archived on your backup master.


## Quick-Start

### Client

A account is needed which will be used by the master to login and fetch the
backups. It is recommended to create a separate account with a separate
SSH certificate. This account can also be limited to only allow sftp to
reduce the risk.

This example assumes that you backup to `/backup/data` but this can be any
directory.

    # adduser -d "" -D -s nologin -w no
    Username: backup
    Full name: 
    Uid (Leave empty for default): 
    Login group [backup]: 
    Login group is backup. Invite backup into other groups? []: 
    Login class [default]: 
    Shell (sh csh tcsh nologin) [nologin]: 
    Home directory [/backup]: 
    Home directory permissions (Leave empty for default): 
    Use password-based authentication? [no]: 
    Lock out the account after creation? [no]: 
    Username   : backup
    Password   : <disabled>
    Full Name  : 
    Uid        : 1001
    Class      : 
    Groups     : backup 
    Home       : /backup
    Home Mode  : 
    Shell      : /usr/sbin/nologin
    Locked     : no
    OK? (yes/no): yes
    adduser: INFO: Successfully added (backup) to the user database.
    Add another user? (yes/no): no
    Goodbye!

    # mkdir -m 0755 /backup
    # install -d -m 0700 -g backup -o backup /backup/.ssh
    # install -d -m 0700 -g backup -o backup /backup/data

    # install -m 0400 -g backup -o backup /dev/null /backup/.ssh/authorized_keys
    # echo "...your-public-key-here..." > /backup/.ssh/authorized_keys

    # printf "\nMatch User backup\n" >> /etc/ssh/sshd_config
    # printf "\tChrootDirectory %%h\n" >> /etc/ssh/sshd_config
    # printf "\tForceCommand internal-sftp\n" >> /etc/ssh/sshd_config
    # printf "\tX11Forwarding no" >> /etc/ssh/sshd_config

    # /etc/rc.d/sshd reload


### Backup master


## Configuration

A global config file exists in `/backup/.ssbt.conf`:

    staging_dir="/home/backup/staging"
    remote_dir="/data"
    local_user="backup"
    local_group="backup"
    remote_user="backup"
    keep_daily=3
    keep_weekly=2
    maxage=86400

For each host some parameters can be set individuall in `/backup/{host}/.ssbt.conf`:

    type="sftp|manual"
    user="backup"
    remote_dir="/data"
    keep_daily=3
    keep_weekly=3
    maxage=86400


## License

ssbt is released under the 2-clause BSD License. Parts of the code
were copied from github.com/churchers/vm-bhyve under the 2-clause
BSD License. Thanks a lot for this great code!
