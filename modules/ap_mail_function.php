<?
date_default_timezone_set('Etc/UTC');
//require_once 'PHPMailer/test/PHPMailer-5.2.26/class.phpmailer.php';
//require_once 'PHPMailer/test/PHPMailer-5.2.26/class.smtp.php';
require_once 'PHPMailer/test/PHPMailer-5.2.26/PHPMailerAutoload.php';
function mail_respondent_smtp($to_email, $subject, $message, $link, $first_name, $last_name, $sex_=1, $use_html=false){
    $subject = str_replace('{HTTP}', EE_HTTP, $subject);
    $subject = str_replace('{SITE_NAME}', EE_SITE_NAME, $subject);

    $from = NOREPLY_EMAIL;
    if ($use_html)
    {
        $message =
            '<html>'."\r\n".
            '<head>'."\r\n".
            '<title>'.$subject.'</title>'."\r\n".
            '</head>'."\r\n".
            '<body>'."\r\n".
            $message.
            '</body>'."\r\n".
            '</html>'."\r\n";
    }
    $message = str_replace(
        array (
            '{HTTP}',
            '{login}',
            '{first_name}',
            '{last_name}',
            '{link}',

            '&lt;br&gt;',
            '&lt;br/&gt;',
            '&lt;br /&gt;',
            '<br>',
            '<br/>',
            '<br />'
        ),

        array (
            EE_HTTP,
            $to_email,
            $first_name,
            $last_name,
            $link,

            "\r\n",
            "\r\n",
            "\r\n",
            "\r\n",
            "\r\n",
            "\r\n"
        ),

        $message
    );

    if ($sex_ != 1)
    {
        global $language;

        $ar_refers = array(
            'UA'=>array('Шановна', 'Шановний'),
            'RU'=>array('Уважаемая', 'Уважаемый')
        );

        if (array_key_exists($language, $ar_refers))
        {
            $message = str_replace($ar_refers[$language][1], $ar_refers[$language][0], $message);
        }
    }

    if (!$use_html)
    {
        $message = strip_tags($message);
    }


    if (empty($subject))
    {
        trigger_error('Empty email subject');
    }

    if (empty($message))
    {
        trigger_error('Empty email message');
    }

   try{

        $mail = new PHPMailer;
        //Tell PHPMailer to use SMTP
        $mail->isSMTP();

        $mail->CharSet = 'UTF-8';

        //Enable SMTP debugging
        // 0 = off (for production use)
        // 1 = client messages
        // 2 = client and server messages
        $mail->SMTPDebug = 0;
       //Set the hostname of the mail server
        $mail->Host = SMTP_HOST;
        //Set the SMTP port number - likely to be 25, 465 or 587
        $mail->Port = 25;
        //Set who the message is to be sent from
        $mail->setFrom($from);
        //Set an alternative reply-to address
        $mail->addReplyTo($from);
        //Set who the message is to be sent to
        $mail->addAddress($to_email);
        //Set the subject line
        $mail->Subject = $subject;
        //Set the body line
        $mail->Body = $message;
        //send the message, check for errors
        $res = $mail->send();


   } catch (phpmailerException $e) {
       $errors[] = $e->errorMessage(); //Pretty error messages from PHPMailer
   } catch (Exception $e) {
       $errors[] = $e->getMessage(); //Boring error messages from anything else!
   }

    $log = array(
        'isSuccess' => strval($res),
        'Host' => $mail->Host,
        'To Email' => $to_email,
        'PORT' => $mail->Port,
        'Error' => $mail->ErrorInfo
    );

    logTo($log, 'smtp_mail.log');
    return $res;
}

function mail_respondent($to_email, $subject, $message, $link, $first_name, $last_name, $sex_=1, $use_html=false)
{
//var_dump(debug_backtrace());
//var_dump($link); exit;
//	$subject = page_cms('email_subject');
    $subject = str_replace('{HTTP}', EE_HTTP, $subject);
    $subject = str_replace('{SITE_NAME}', EE_SITE_NAME, $subject);

    $from = NOREPLY_EMAIL;

    //send email
    $eol = "\r\n";
    $headers = 'From: '.$from.$eol;
    $headers .= 'Reply-To: '.$from.$eol;
    $headers .= 'Return-Path: '.$from.$eol;
    $headers .= 'MIME-Version: 1.0'.$eol;
    $headers .= 'Content-Type: text/'.( $use_html ? 'html' : 'plain' ).'; charset='.getCharset().$eol;
    $headers .= 'X-Mailer: PHP/'.phpversion();

    if ($use_html)
    {
        $message =
            '<html>'."\r\n".
            '<head>'."\r\n".
            '<title>'.$subject.'</title>'."\r\n".
            '</head>'."\r\n".
            '<body>'."\r\n".
            $message.
            '</body>'."\r\n".
            '</html>'."\r\n";
    }

    $message = str_replace(
        array (
            '{HTTP}',
            '{login}',
            '{first_name}',
            '{last_name}',
            '{link}',

            '&lt;br&gt;',
            '&lt;br/&gt;',
            '&lt;br /&gt;',
            '<br>',
            '<br/>',
            '<br />'
        ),

        array (
            EE_HTTP,
            $to_email,
            $first_name,
            $last_name,
            $link,

            "\r\n",
            "\r\n",
            "\r\n",
            "\r\n",
            "\r\n",
            "\r\n"
        ),

        $message
    );


    if ($sex_ != 1)
    {
        global $language;

        $ar_refers = array(
            'UA'=>array('Шановна', 'Шановний'),
            'RU'=>array('Уважаемая', 'Уважаемый')
        );

        if (array_key_exists($language, $ar_refers))
        {
            $message = str_replace($ar_refers[$language][1], $ar_refers[$language][0], $message);
        }
    }


    if (!$use_html)
    {
        $message = strip_tags($message);
    }


    if (empty($subject))
    {
        trigger_error('Empty email subject');
    }

    if (empty($message))
    {
        trigger_error('Empty email message');
    }

    $subject = "=?".getCharset()."?b?".base64_encode($subject)."?=";

    $res = mail($to_email, $subject, $message, $headers);

    /*
    $h = fopen(EE_PATH.'log/mail.html', "a");
    fwrite($h, 'Date/time: '."\r\n".date("Y-m-d H:i:s")."\r\n\r\n");
    fwrite($h, 'IP (remote address): '."\r\n".$_SERVER['REMOTE_ADDR']."\r\n\r\n");
    fwrite($h, 'HTTP_X_FORWARDED_FOR: '."\r\n".getenv('HTTP_X_FORWARDED_FOR')."\r\n\r\n");
    fwrite($h, 'Page id: '."\r\n".getValueOf('page_id')."\r\n\r\n");
    fwrite($h, '$to_email: '."\r\n".$to_email."\r\n\r\n");
    fwrite($h, '$subject:'."\r\n".$subject."\r\n\r\n");
    fwrite($h, '$message:'."\r\n".$message."\r\n\r\n");
    fwrite($h, '$headers:'."\r\n".$headers."\r\n\r\n\r\n");

    fclose($h);
    */

    return $res;
}

