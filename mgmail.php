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
    $mail->Host = "smtp.gmail.com";
    //Set the SMTP port number - likely to be 25, 465 or 587
    $mail->Port = 465;
    //Whether to use SMTP authentication
    $mail->SMTPAuth = true;
    $mail->SMTPSecure = "ssl";
    //Username to use for SMTP authentication
    $mail->Username = "bilinskyivitalii@gmail.com";
    //Password to use for SMTP authentication
    $mail->Password = "vk179crow1275";
    //Set who the message is to be sent from
    $mail->setFrom('bilinskyivitalii@gmail.com', 'First Last');
    //Set an alternative reply-to address
    $mail->addReplyTo('bilinskyivitalii@gmail.com', 'First Last');
    //Set who the message is to be sent to
    $mail->addAddress('seekndestroy@mail.ru', 'John Doe');
    //Set the subject line
    $mail->Subject = 'PHPMailer SMTP test';

    $mail->Body     = 'Hi! This is my first e-mail sent through PHPMailer.';
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