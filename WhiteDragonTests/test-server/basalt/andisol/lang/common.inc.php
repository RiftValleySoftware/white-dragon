<?php
/***************************************************************************************************************************/
/**
    COBRA Security Administration Layer
    
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
defined( 'LGV_LANG_CATCHER' ) or die ( 'Cannot Execute Directly' );	// Makes sure that this file is in the correct context.

global $g_lang_override;    // This allows us to override the configured language at initiation time.

if (isset($g_lang_override) && $g_lang_override && file_exists(dirname(__FILE__).'/'.$lang.'.php')) {
    $lang = $g_lang_override;
} else {
    $lang = CO_Config::$lang;
}

$lang_common_file = CO_Config::cobra_lang_class_dir().'/common.inc.php';

require_once(dirname(__FILE__).'/'.$lang.'.php');
require_once($lang_file);
require_once($lang_common_file);
    
/***************************************************************************************************************************/
/**
 */
class CO_ANDISOL_Lang_Common {
    static  $andisol_error_code_user_not_authorized = 2000;
    static  $andisol_error_code_login_instance_failed_to_initialize = 2001;
    static  $andisol_error_code_login_instance_unavailable = 2002;
    static  $andisol_error_code_user_instance_unavailable = 2003;
    static  $andisol_error_code_user_not_deleted = 2004;
    static  $andisol_error_code_login_not_deleted = 2005;
    static  $andisol_error_code_insufficient_location_information = 2006;
    static  $andisol_error_code_location_failed_to_initialize = 2007;
}
?>