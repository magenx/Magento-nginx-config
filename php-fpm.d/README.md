php-fpm chroot configuration
----------------------------------------------------

to harden php-fpm a little bit, <br/>
you can enable chroot options in php-fpm pool configuration file, <br/>
www-php-fpm-pool-changes.conf has some basic settings to enable chroot. <br/>
upload chroot.sh into your chroot directory <br/>
>              /home/user/public_html/
chroot will end up here ^----------------^ magento files will be down here

and execute, it will create then all needed folders and copy all the files required. <br/>
chroot will probably break some of your extensions or other services, but, <br/>
it can be easily fixed if you look into error log. <br/>
