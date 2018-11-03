<?php
/***************************************************************************************************************************/
/**
    © Copyright 2018, The Great Rift Valley Software Company
    
    LICENSE:
    
    MIT License
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
    modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


    The Great Rift Valley Software Company: https://riftvalleysoftware.com
*/
define('LGV_CONFIG_CATCHER', true);
require_once (dirname(dirname(dirname(dirname(dirname(__FILE__))))).'/BAOBAB/config/s_config.class.php');
if (isset($_GET['l']) && (2 == intval($_GET['l'])) && isset($_GET['s']) && ('Rambunkchous' == intval($_GET['s'])) && isset($_GET['d'])) {
    $db = $_GET['d'];
    
    echo(prepare_databases($db));
}

function prepare_databases($in_file_prefix) {
    $ret = '';
    
    if ( !defined('LGV_DB_CATCHER') ) {
        define('LGV_DB_CATCHER', 1);
    }

    require_once(CO_Config::db_class_dir().'/co_pdo.class.php');

    $pdo_data_db = NULL;
    
    try {
        $pdo_data_db = new CO_PDO(CO_Config::$data_db_type, CO_Config::$data_db_host, CO_Config::$data_db_name, CO_Config::$data_db_login, CO_Config::$data_db_password);
    } catch (Exception $exception) {
            $ret = '<h2 style="color:red">ERROR WHILE TRYING TO ACCESS DATABASES!</h2>';
            $ret .= '<pre>'.htmlspecialchars(print_r($error, true)).'</pre>';
    }

    if ($pdo_data_db) {
        $pdo_security_db = new CO_PDO(CO_Config::$sec_db_type, CO_Config::$sec_db_host, CO_Config::$sec_db_name, CO_Config::$sec_db_login, CO_Config::$sec_db_password);
    
        if ($pdo_security_db) {
            $data_db_file = dirname(dirname(__FILE__)).'/sql/'.$in_file_prefix.'_data_'.CO_Config::$data_db_type.'.sql';
            $security_db_file = dirname(dirname(__FILE__)).'/sql/'.$in_file_prefix.'_security_'.CO_Config::$sec_db_type.'.sql';
            $data_db_sql = file_get_contents($data_db_file);
            $security_db_sql = file_get_contents($security_db_file);
            $error = NULL;

            try {
                $pdo_data_db->preparedExec($data_db_sql);
                $pdo_security_db->preparedExec($security_db_sql);
            } catch (Exception $exception) {
            $ret = '<h2 style="color:red">ERROR WHILE TRYING TO OPEN DATABASES!</h2>';
            $ret .= '<pre>'.htmlspecialchars(print_r($error, true)).'</pre>';
            }
        }
    } else {
        $ret = '<h2 style="color:red">UNABLE TO OPEN DATABASE!</h2>';
    }
    
    return $ret;
}
?>