#!/bin/bash
sudo mkdir -p /media/backup_folder
sudo mount -t cifs //10.1.23.14/Backup /media/backup_folder/ -o vers=2.0,guest

# xml backup
sudo mkdir -p /tmp/wikibackup
sudo php /var/www/html/maintenance/dumpBackup.php --full > /tmp/wikibackup/xml_backup$(date +%s).xml

sudo tar zcvhf /tmp/wikibackup/wikidata$(date +%s).tgz /var/www/html

sed '2i$wgReadOnly = "Dumping Database, Access will be restored shortly";' /var/www/html/LocalSettings.php > temp.txt
sudo mv temp.txt /var/www/html/LocalSettings.php -f
sudo systemctl restart httpd
sudo mysqldump -u wiki_user --password=Mltqtgyze1\! it_wiki | gzip > /tmp/wikibackup/sqldata$(date +%s).sql.gz
sudo sed "2d" /var/www/html/LocalSettings.php > temp.txt
sudo mv temp.txt /var/www/html/LocalSettings.php -f
sudo systemctl restart httpd

sudo cp -R /tmp/wikibackup/ /media/backup_folder/OS_Backup/
sudo mv /media/backup_folder/OS_Backup/wikibackup /media/backup_folder/OS_Backup/wikibackup$(date +%s)
sudo rm /tmp/wikibackup -rf
sudo umount /media/backup_folder
