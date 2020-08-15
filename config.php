<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = $_ENV["MOODLE_DB_HOST"];
$CFG->dbname    = $_ENV["MOODLE_DB_NAME"];
$CFG->dbuser    = $_ENV["MOODLE_DB_USER"];
$CFG->dbpass    = $_ENV["MOODLE_DB_PASS"];
$CFG->prefix    = $_ENV["MOODLE_DB_PREFIX"];
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => $_ENV["MOODLE_DB_PORT"],
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

$CFG->wwwroot   = $_ENV["MOODLE_WWWROOT"];
$CFG->dataroot  = $_ENV["MOODLE_DATAROOT"];
$CFG->admin     = 'admin';

$CFG->directorypermissions = 02777;
$CFG->sslproxy = true;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
