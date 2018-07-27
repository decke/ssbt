## ssbt (Simple Stupid Backup Tool)

You create a backup on your machine and ssbt will periodically
collect and archive it.

* Simple setup and maintenance
* Automatic cleanup of old backups
* sftp support (including chrooted sftp)
* rsync support over ssh
* zfs snapshot support
* 1st class FreeBSD support (Linux support planned)


## But why yet another backup solution?

Backups should be simple and reliable to make sure they are as painless as
possible. I know there are a lot of tools out there with fancy webinterfaces,
agents for whatever service you might run, multiuser, cross platform and much
more. You will not find any of those features here.

What you will find is a simple shellscript which will periodically log into
your machines with ssh(1) and pull tar archives from there which get archived.

You can continue to create your backups with tar(1) and be sure those are
archived on your backup master.


## Quick-Start

### Backup Master

Either download the release tarball and run `make install` or clone the git
repository and run `make install`.

    # git clone https://code.bluelife.at/decke/ssbt.git
    # make install

The only mandatory setup is to set the backup directory for ssbt and make
sure that it exists. If you want to run ssbt as non root (which is recommended!)
then make sure the directory has proper owner/group and permissions.

    # sysrc ssbt_dir="/backup"
    # mkdir /backup

    # adduser backup
    # sysrc ssbt_user="backup"
    # chown backup:backup /backup

It is recommended to use SSH certificates instead of passwords and create a
dedicated ssh key that you can copy to all clients for fetching backups.

    # ssh-keygen

You are good to go now.
In this example we now add our first client `first.example.com`.

    # mkdir /backup/first.example.com

If ssh(1) setup was done properly a `pull` will transfer the backups.

    # ssbt pull first.example.com

#### Cronjob

To automate periodic pulls add this command to your crontab(5):

    # ssbt cron

#### ZFS

If you are using ZFS and have bigger amounts of slowly changing data then
the type rsync+zfs will be relevant for you. It allows to transfer changed
data with rsync and use ZFS snapshots for keeping multiple backups of that
data.

    # zfs create zroot/backup/second.example.com

If you run ssbt with non root user it will need permissions to run `zfs snapshot`
and `zfs destroy` on that filesystem (mount is a requirement of destroy).

    # zfs allow -u backup snapshot,mount,destroy zroot/backup/second.example.com


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


## Configuration

A global config file exists in `/backup/.ssbt.conf` and all parameters can be
overwritten in a host configuration in `/backup/{host}/.ssbt.conf`:

    type="sftp|manual|rsync|rsync+zfs"
    frequ=86400
    staging_dir="/home/backup/staging"
    remote_user="backup"
    remote_dir="/data"
    local_user="backup"
    local_group="backup"
    keep_daily=3
    keep_weekly=2
    rsync_flags="-av --delete"
    prepull_cmd=""
    postpull_cmd=""

## License

ssbt is released under the 2-clause BSD License. Parts of the code
were copied from github.com/churchers/vm-bhyve under the 2-clause
BSD License. Thanks a lot for this great code!
