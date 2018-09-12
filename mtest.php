<?php
date_default_timezone_set('Etc/UTC');
require_once 'modules/PHPMailer/test/PHPMailer-5.2.26/PHPMailerAutoload.php';

try{

    /**
     * This example shows making an SMTP connection with authentication.
     */

    //SMTP needs accurate times, and the PHP time zone MUST be set
    //This should be done in your php.ini, but this is how to do it if you don't have access to that




    //Create a new PHPMailer instance
    $mail = new PHPMailer;
    //Tell PHPMailer to use SMTP
    $mail->isSMTP();
    //Enable SMTP debugging
    // 0 = off (for production use)
    // 1 = client messages
    // 2 = client and server messages
    $mail->SMTPDebug = 4;
    //Ask for HTML-friendly debug output
    $mail->Debugoutput = 'html';
    //Set the hostname of the mail server
    $mail->Host = "mail.smtp2go.com";
    //Set the SMTP port number - likely to be 25, 465 or 587
    $mail->Port = 25;
    //Whether to use SMTP authentication
//    $mail->SMTPAuth = true;
    //Username to use for SMTP authentication
//    $mail->Username = "noreply@tns.lt";
    //Password to use for SMTP authentication
//    $mail->Password = "";
    //Set who the message is to be sent from
    $mail->setFrom('noreply@tns.lt', 'fix');
    //Set an alternative reply-to address
    $mail->addReplyTo('noreply@tns.lt', 'fix');
    //Set who the message is to be sent to
    $mail->addAddress('bilinskyivitalii@gmail.com', 'John Doe 2');
    //Set the subject line
    $mail->Subject = 'PHPMailer SMTP test fix';

    $mail->Body     = 'Hi!!! This is my first e-mail sent through PHPMailer.';
    //send the message, check for errors
    $res = $mail->send();


} catch (phpmailerException $e) {
    $errors[] = $e->errorMessage(); //Pretty error messages from PHPMailer
    var_dump($errors);die('error!');
} catch (Exception $e) {
    $errors[] = $e->getMessage(); //Boring error messages from anything else!
    var_dump($errors);die('error!');

}
//
//$log = array(
//    'isSuccess' => strval($res),
//    'Host' => $mail->Host,
//    'Username' => $mail->Username,
//    'To Email' => $to_email,
//    'PORT' => $mail->Port,
//    'Error' => $mail->ErrorInfo
//);
//
//logTo($log, 'smtp_mail.log');
var_dump($res);