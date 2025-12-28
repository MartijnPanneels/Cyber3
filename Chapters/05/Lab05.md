# Lab05

## Setup

1. First I made a folder and downloaded the files using curl. (on web)
2. I created a folder for the backups. (on database)
3. Installing epel repository (on web). Now I can install `borgbackup` (on both vm's)µ
4. Create a ssh-keypair for web-db communication

    `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""`
    `ssh-copy-id -i ~/.ssh/id_ed25519.pub vagrant@172.30.0.15`

5. Initialize the repo `[vagrant@web ~]$ borg init --encryption=repokey ssh://vagrant@172.30.0.15/home/vagrant/backups`
6. Set a passphrase (I just hit enter)
7. Add backups to it: `[vagrant@web ~]$ borg create ssh://vagrant@172.30.0.15/home/vagrant/backups::first ./important-files`
8. Verify the backup: `[vagrant@web ~]$ borg list ssh://vagrant@172.30.0.15/home/vagrant/backups`
9. See the info: `[vagrant@web ~]$ borg info vagrant@172.30.0.15:~/backups`
10. Create a second file and backup:
    1. `[vagrant@web ~]$ echo "Hello world" > ./important-files/test.txt`
    2. `[vagrant@web ~]$ borg create ssh://vagrant@172.30.0.15/home/vagrant/backups::second ./important-files`
    3. `[vagrant@web ~]$ borg list ssh://vagrant@172.30.0.15/home/vagrant/backups`

## Q's

1. Folder size:

-   `du -sh ./important-files`: IEC (power-of-1024) units: KiB, MiB, GiB -> 1.7M
-   `du -sh --si ./important-files`: SI (power-of-1000) units: kB, MB, GB -> 1.8M

-   `borg info ssh://vagrant@172.30.0.15/home/vagrant/backups::first` -> 1.74 MB

On database is it the same.

2. Different sizes

-   Original size: sum of input file sizes before compression and deduplication;
-   Compressed size: size of the unique data after compression (plus metadata).
-   Deduplicated size: net new data stored in the repo for that archive after deduplication. For the first backup it ≈ Compressed; for subsequent backups it’s only the delta.

3. What are chunks?

Borg splits files into chunks so identical data across backups is stored once, enabling deduplication. Each chunk gets a cryptographic ID (hash); if a chunk with the same ID already exists, Borg reuses it rather than storing it again.

4. What does the borg compact command do?

It reclaims repository space by rewriting segment files to drop orphaned chunks and shrink indexes. Run it when the repo has a lot of freed chunks (after many deletes/prunes) and you want to clean up.storage

5. Can I use tools like borg to backup an active database?

Not safely: borg just copies whatever is on disk; active databases change files mid-write, so you can end up with a crash-consistent or corrupted copy.

6. What does Borgmatic do and is it useful?

Borgmatic is an automation wrapper aruound Borg. It useses one config file instead of ad-hoc systemd-run lines. But you need to install it extra.

## Setup continued

11. To delete the original files: `[vagrant@web ~]$ rm --recursive --verbose important-files/`
12. To restore the files from the first backup: `[vagrant@web ~]$ borg extract --progress ssh://vagrant@172.30.0.15/home/vagrant/backups::first ` (borg uses absolute paths to change the path: --strip-components 2 -> removes the first 2 elements of the path)
13. Verify: `[vagrant@web ~]$ ls important-files/`

## Create a systemd timer to automate it

```bash
systemd-run --user --unit=borg-backup --on-calendar='*:0/5' --timer-property=Persistent=true \
/bin/sh -lc 'borg create --compression lz4 ssh://vagrant@172.30.0.15/home/vagrant/backups::$(hostname -s)-$(date +%F_%T) /home/vagrant/important-files && borg prune -v ssh://vagrant@172.30.0.15/home/vagrant/backups --prefix "$(hostname -s)-" --keep-within 2h --keep-hourly 24 --keep-daily 7 --keep-weekly 4 --keep-monthly 12'
```

-   Every 5 minutes: borg create archive named <host>-YYYY-MM-DD_HH:MM:SS from /home/vagrant/important-files into the repo on 172.30.0.15.
-   Grandfather-Father-Son style retention: keep everything within 2h, 24 hourly, 7 daily, 4 weekly, 12 monthly.

Remove/reset if needed:

-   systemctl --user stop borg-backup.timer borg-backup.service
-   systemctl --user disable borg-backup.timer
-   systemctl --user reset-failed borg-backup.service
