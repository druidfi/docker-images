<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// Handle HTTPS
if (getenv('HTTPS') !== 'on' && getenv('HTTP_X_FORWARDED_PROTO') === 'https') {
  $_SERVER['HTTPS'] = 'on';
  $_SERVER["SERVER_PORT"] = getenv('HTTP_X_FORWARDED_PORT') ?: 443;
}

if (getenv('WP_SITEURL')) {
  define('WP_HOME', getenv('WP_SITEURL'));
  define('WP_SITEURL', getenv('WP_SITEURL'));
}

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', getenv('DB_NAME') );

/** MySQL database username */
define( 'DB_USER', getenv('DB_USER') );

/** MySQL database password */
define( 'DB_PASSWORD', getenv('DB_PASSWORD') );

/** MySQL hostname */
define( 'DB_HOST', getenv('DB_HOST') );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'VcGCi`[CrQ2D$>8$R fj0@z/KxgjFWz%TvN5Rv|@K*11ay__I(:Os=+cDR|75_eK');
define('SECURE_AUTH_KEY',  '<[h$wS ^]<3^|l|cD=,+I%q+2Pd_{[krj*+zEmg_=ASo:_#WJsu4o34<w4HDU]WK');
define('LOGGED_IN_KEY',    'i-|&jfr1 _G6g>v>+Ha8n]^l@mp~-QX[O%Hib/IoV4K#p$#*j6?WM!ht.!7({gUp');
define('NONCE_KEY',        '^nOTI$G0G4R?xkO>zG+B-K*CC*|U;an_IB,<-;z]{,Pser*VUqJ*sV|CA1d?yOO7');
define('AUTH_SALT',        'dWa)e&Ad^l.Yzis|c;&(}+u,8mxGxKfjS.?xu[&)+m>{/0?vp`3QL*V5;w/aX#A)');
define('SECURE_AUTH_SALT', '@PIt:*+ZwR*/j2]lTOS-=8;.61Z%*G7%{Ot;p3A1(70T&.dI/+8uL-$dvfIU<.}(');
define('LOGGED_IN_SALT',   '_K+K}>d<imkaY68ix2K)`C(|vvrC,7Kkp`#flW=:(X1r}(%S:wh*>v{l!P_=K*h9');
define('NONCE_SALT',       'z7w~knr%i&dGaGd-BplVQ@!Xt76-  ZH/#E{?%bHmvq->;^&E3:xGmnut=:LN;=C');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( getenv('APP_ENV') === 'dev' ) {

  define( 'WP_DEBUG', true );
  define( 'WP_DEBUG_LOG', true ); // Stored in wp-content/debug.log
  define( 'WP_DEBUG_DISPLAY', true );
  define( 'SCRIPT_DEBUG', true );
  define( 'SAVEQUERIES', true );

} else {

  define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
