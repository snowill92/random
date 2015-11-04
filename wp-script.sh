#!/bin/bash
clear
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root if you want to install the "
	echo "required stuff and set all correct permissions etc etc"
	echo "OK to continue Y/n"
	read -s -n 1 ans
	if [ "$ans" = "" ]; then
		ans=y
	fi
	if [ "$ans" != "y" ]; then
		echo "Quitting"
		exit 1
	fi 
fi
spacer="---------------------------------------------------------------"
echo $spacer
echo "OK, go grab the latest wordpress install"
echo "from the web and then set it up - Y/n: "
echo $spacer

read -s -n 1 resp
if [ "$resp" = "" ]; then
	resp=y
fi
if [ "$resp" = "y" ]; then

	cd /var/www/
	wget http://wordpress.org/latest.tar.gz
	tar xzvf latest.tar.gz
	rm latest.tar.gz

	clear
	echo $spacer
	echo "Give me the SiteName/ SitePath"
	echo "eg /var/www/????wordpress/www"
	echo -n "Enter Name and hit [ENTER]:"
	read path1
	echo $spacer
	echo -n "give me the site domain and [ENTER]:"
	read domain
	echo $spacer

	path=$path1'wordpress'

	mv wordpress ./$path
	chown -R root:www-data $path
	apt-get update
	apt-get install php5-gd
	apt-get install libssh2-php
	cd $path
	mkdir www
	mv ./* www
	mkdir etc
	cd etc

	echo "<VirtualHost *:80>

		ServerName $domain
		ServerAlias www.$domain
		ServerAdmin webmaster@localhost
		DocumentRoot /var/www/$path/www

		ErrorLog /var/www/$path/error.log
		CustomLog /var/www/$path/access.log combined

	</VirtualHost>"	> ./$path.conf

	ln $path.conf /etc/apache2/sites-available/
	cd ..
	cd www

	clear
	echo $spacer
	echo -n "give me the DataBase Name and [ENTER]:"
	read databasename
	echo $spacer
	echo -n "give me the DataBase User Name [ENTER]:"
	read databaseusername
	echo $spacer
	echo -n "give me the DataBase Password [ENTER]:"
	read databasepassword
	clear
	echo "<?php
	/**
	 * The base configuration for WordPress
	 *
	 * The wp-config.php creation script uses this file during the
	 * installation. You don't have to use the web site, you can
	 * copy this file to wp-config.php and fill in the values.
	 *
	 * This file contains the following configurations:
	 *
	 * * MySQL settings
	 * * Secret keys
	 * * Database table prefix
	 * * ABSPATH
	 *
	 * @link https://codex.wordpress.org/Editing_wp-config.php
	 *
	 * @package WordPress
	 */

	// ** MySQL settings - You can get this info from your web host ** //
	/** The name of the database for WordPress */
	define('DB_NAME', '$databasename');

	/** MySQL database username */
	define('DB_USER', '$databaseusername');

	/** MySQL database password */
	define('DB_PASSWORD', '$databasepassword');

	/** MySQL hostname */
	define('DB_HOST', 'localhost');

	/** Database Charset to use in creating database tables. */
	define('DB_CHARSET', 'utf8');

	/** The Database Collate type. Don't change this if in doubt. */
	define('DB_COLLATE', '');

	/**#@+
	 * Authentication Unique Keys and Salts.
	 *
	 * Change these to different unique phrases!
	 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
	 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
	 *
	 * @since 2.6.0
	 */
	define('AUTH_KEY',         'put your unique phrase here');
	define('SECURE_AUTH_KEY',  'put your unique phrase here');
	define('LOGGED_IN_KEY',    'put your unique phrase here');
	define('NONCE_KEY',        'put your unique phrase here');
	define('AUTH_SALT',        'put your unique phrase here');
	define('SECURE_AUTH_SALT', 'put your unique phrase here');
	define('LOGGED_IN_SALT',   'put your unique phrase here');
	define('NONCE_SALT',       'put your unique phrase here');

	/**#@-*/

	/**
	 * WordPress Database Table prefix.
	 *
	 * You can have multiple installations in one database if you give each
	 * a unique prefix. Only numbers, letters, and underscores please!
	 */
	\$table_prefix  = 'wp_';

	/**
	 * For developers: WordPress debugging mode.
	 *
	 * Change this to true to enable the display of notices during development.
	 * It is strongly recommended that plugin and theme developers use WP_DEBUG
	 * in their development environments.
	 *
	 * For information on other constants that can be used for debugging,
	 * visit the Codex.
	 *
	 * @link https://codex.wordpress.org/Debugging_in_WordPress
	 */
	define('WP_DEBUG', false);

	/* That's all, stop editing! Happy blogging. */

	/** Absolute path to the WordPress directory. */
	if ( !defined('ABSPATH') )
		define('ABSPATH', dirname(__FILE__) . '/');

	/** Sets up WordPress vars and included files. */
	require_once(ABSPATH . 'wp-settings.php');" > ./wp-config.php

	mkdir wp-content/uploads
	chown -R root:www-data *
	a2ensite $path.conf
	service apache2 restart
	clear
	echo $spacer
	echo "Site installed to:/vaw/www/$path/"
	echo $spacer
	echo "Site URL:$domain | www.$domain"
	echo $spacer
	echo "All Done!"
else
	echo "Quitting, Bye"
fi

exit 1
