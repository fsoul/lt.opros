<?

define('AP_ALLOWED_CELL_PHONE_CODES', '068, 096, 097, 066, 063, 093, 067, 098, 050, 095, 099, 092, 094, 091');

function ap_process_points_convertion_form()
{
	if (!defined('POINTS_FOR_CONVERTION_DIVISIBLE_TO')) define('POINTS_FOR_CONVERTION_DIVISIBLE_TO', 100);//100
	if (!defined('MIN_POINTS_FOR_CONVERTION')) define('MIN_POINTS_FOR_CONVERTION', 3000);//3000


	if (!defined('CONVERTION_SUBMIT_EMAIL'))
	{
		define('CONVERTION_SUBMIT_EMAIL', 'accesspanel.helpdesk@tns-ua.com');
	}

	define('CONVERTION_SUBMIT_SUBJECT', 'Points convertion');


	global $error;

	$resp = ap_resp_init();

	if (is_object($resp))
	{
		$info = $resp->Get_Info(ap_get_respondent_id());
//var_dump($info);
		foreach(array('district', 'region', 'city', 'street') as $address_field)
		{
			$info[$address_field.'_'] = get_respondent_address_field($address_field, $info[$address_field.'_']);
		}
	}
	else
	{
		$error['page_error'] = cons('Can\'t convert points');
//		$error['oci_debug'] = $resp->_oci->get_debug();

		trigger_error($error['page_error']);
	}

//var_dump(cms_cons('Points number should be at least'));
//var_dump(cms_cons('Points number should be at least %s')); exit;

	if (count($_POST))
	{
		global $error;

		$_POST['points_number'] = (int)$_POST['points_number'];

		if (empty($_POST['points_convertion_type']))
		{
			$error['page_error'] = $error['points_convertion_type'] = cms_cons('Select convertion type');
		}
		elseif (!($min_points_for_convertion = $resp->Get_Min_Points_For_Convertion($_POST['points_convertion_type'])))
		{
			$error['page_error'] = $error['points_number'] = e_cms_cons('Unknown minimal points for convertion value');
		}
		elseif (empty($_POST['points_number']))
		{
			$error['page_error'] = $error['points_number'] = e_cms_cons('Enter points number');
		}
		elseif ($_POST['points_number'] < $min_points_for_convertion)
		{
			$error['page_error'] = $error['points_number'] = sprintf(cms_cons('Points number should be at least %s'), $min_points_for_convertion);
		}
		elseif ($_POST['points_number'] > ap_points_available())
		{
			$error['page_error'] = $error['points_number'] = sprintf(cms_cons('You can not use more then %s points number'), ap_points_available());
		}
		elseif (fmod($_POST['points_number'], POINTS_FOR_CONVERTION_DIVISIBLE_TO))
		{
			$error['page_error'] = $error['points_number'] = sprintf(cms_cons('Points number should be divisible by %s'), POINTS_FOR_CONVERTION_DIVISIBLE_TO);
		}
		else
		{
			$ar_form_fields['post_order'] = array('last_name_', 'first_name_', 'second_name_', 'index_', 'district_', 'region_', 'city_', 'street_', 'house_');
			$ar_form_fields['replenishment_mobile'] = array('cell_phone_number_');
			$ar_form_fields['replenishment_webmoney'] = array('purse_number');

			if (	!array_key_exists($_POST['points_convertion_type'], $ar_form_fields)
				||
				!is_array($ar_form_fields[$_POST['points_convertion_type']])
			)
			{
				$error['page_error'] = cons('Can\'t convert points.');

				trigger_error($error['page_error']);
			}

			$ar_mandatory_fields = array_merge($ar_form_fields[$_POST['points_convertion_type']], array('pass_'.$_POST['points_convertion_type']));

			$ar_form_fields['post_order'][] = 'flat_';

			foreach($ar_mandatory_fields as $field_name)
			{
				if (empty($_POST[$field_name]))
				{
					$error[$field_name] = e_cms_cons('Mandatory field');
				}
			}

			if (	$_POST['points_convertion_type'] == 'replenishment_mobile' &&
				!check_phone('cell_phone_number_', $error, explode(', ', AP_ALLOWED_CELL_PHONE_CODES))
			)
			{
				if (empty($error['cell_phone_number_']))
				{
					$error['cell_phone_number_'] = e_cms_cons('Enter phone number with code (10 digits)');
				}
			}

			if (	$_POST['points_convertion_type'] == 'replenishment_webmoney' &&
				!check_webmoney_purse_number($_POST['purse_number'])
			)
			{
//logTo(ap_get_respondent_email(), 'purse_number.txt');
//logTo('$error 1', 'purse_number.txt');
//logTo(print_r($error, true), 'purse_number.txt');
				$error['purse_number'] = e_cms_cons('Enter purse number in correct format');
//logTo('$error 2', 'purse_number.txt');
//logTo(print_r($error, true), 'purse_number.txt');
			}

			if (	is_array($error) &&
				count($error) > 0
			)
			{
				$error['page_error'] = page_cms('page_error');

				foreach (array('cell_phone_number_', 'purse_number', 'pass_'.$_POST['points_convertion_type']) as $field_name)
				{
					if (	array_key_exists($field_name, $error) &&
						!empty($error[$field_name]) &&
						strpos($error['page_error'], $error[$field_name])===false
					)
					{
//logTo('$field_name', 'purse_number.txt');
//logTo($field_name, 'purse_number.txt');
						$error['page_error'].= '<br/>'.$error[$field_name];
					}
//logTo('$error 3', 'purse_number.txt');
//logTo(print_r($error, true), 'purse_number.txt');
				}

				if (	array_key_exists('password', $error) &&
					$error['password'] == PASSWORD_NOT_MUTCH_RULES)
				{
					$error['page_error'].= '<br/>'.longtext_edit_cms('password_rules_error').cms('password_rules_error');
				}
			}
			else
			{
				$resp = ap_resp_init();

				if (!$resp->Authorize($resp->_oci->spValue(ap_get_respondent_email()), $resp->_oci->spValue($_POST['pass_'.$_POST['points_convertion_type']])))
				{
					$error['page_error'] = $error['pass_'.$_POST['points_convertion_type']] = cons('Incorrect password');
				}
				else
				{
					$ar_purpose = array();

					foreach($ar_form_fields[$_POST['points_convertion_type']] as $f_name)
					{
						$ar_purpose[] = trim($_POST[$f_name]);
					}
//var_dump($_POST);
					$purpose = implode(', ', $ar_purpose);

					$ar_mail = array(
						'respondent_id' => $info['respondent_id_'],
						'respondent_fio' => $info['first_name_'].' '.$info['last_name_'],
						'sum' => $_POST['points_number']/100,
						'convertion_type' => $_POST['points_convertion_type'],
						'purpose' => $purpose,
						'date' => date("Y-m-d"),
						'district' => $info['district_'],
						'region' => $info['region_'],
						'city' => $info['city_'],
						'settlement' => $info['settlement_'],
						'street' => $info['street_'],
						'house' => $info['house_'],
						'flat' => $info['flat_'],
						'city_phone_number' => $info['city_phone_number_'],
						'cell_phone_number' => $info['cell_phone_number_']
					);

					$ar_mail_res = array();

					foreach($ar_mail as $f_name => $f_value)
					{
						$ar_mail_res[] = array(
							'points_convertion_field_name' => words(rtrim($f_name, '_')),
							'points_convertion_field_value' => $f_value
						);
					}

//var_dump($ar_mail);
					$res = $resp->Add_Points_Convertion_Request
					(
						$info['respondent_id_'],
						$_POST['points_number'],
						$_POST['points_convertion_type'],
						$purpose
					);

//var_dump($res);
					$msg = parse_array_to_html($ar_mail_res, 'points_convertion_mail');
//echo $msg;
//exit;
//					$res = mail_respondent(CONVERTION_SUBMIT_EMAIL, CONVERTION_SUBMIT_SUBJECT, $msg, null, null, null, null, true);
//var_dump($res);
				}
			}
		}


		if (	is_array($error) &&
			array_key_exists('page_error', $error)
		)
		{
			$error['page_error_flag'] = 1;
		}
		else
		{
			header('Location: '.get_href(31));
			exit;
		}
	}
	else
	{
		if (is_array($info))
		{
			foreach($info as $key=>$val)
			{
				{
					global $$key;
					$$key = $val;
				}
			}
		}
	}
}

function get_respondent_address_field($address_field_name, $id)
{
	$res = '';

	if (!ereg("^[0-9]+$", $id))
	{
		$res = $id;
	}
	elseif ($oci = ap_oci_init())
	{
		$sql = '
                SELECT
                       '.$address_field_name.'_name
                  FROM
                       access_panel.v_'.$address_field_name.( $address_field_name=='district' ? '' : '_old' ).'
                 WHERE
                       '.$address_field_name.'_id='.$oci->sqlValue($id).'
                ';

		$res = $oci->getField($sql);

		if (empty($res))
		{
			$res = $id;
		}
	}

	return $res;
}

function uri_separator()
{
	return ( get('admin_template')=='yes' ? '&' : '?' );
}

function get_reffer_link()
{
	return get_href('forma_reestracii').uri_separator().'reffer_email_='.ap_get_respondent_email();
}


function ap_process_reffer_form()
{
	global $page_error_sfx;

	$page_error_sfx = '_reffer';

	if (count($_POST) && array_key_exists('invitation_to_email', $_POST))
	{
		global $error;

		if (!check_email($_POST['invitation_to_email']))
		{
			$error['page_error'.$page_error_sfx] = $error['invitation_to_email'] = cons('Enter e-mail in standart format');
		}
		else
		{
//function mail_respondent($to_email, $subject, $message, $hash_code, $page_code, $first_name, $last_name, $sex_=1)
			$res = mail_respondent($_POST['invitation_to_email'], cms('reffer_email_subject'), cms('reffer_email_body'), get_reffer_link(), ap_get_respondent_first_name(), ap_get_respondent_last_name());

			if (!$res)
			{
				$error['page_error'.$page_error_sfx] = cons('Can\'t send invitation email');
				trigger_error($error['page_error'.$page_error_sfx]);
			}
		}

		if (	is_array($error) &&
			array_key_exists('page_error'.$page_error_sfx, $error)
		)
		{
			$error['page_error_flag'.$page_error_sfx] = 1;
		}
		else
		{
			header('Location: '.get_href('invitation_sent_success'));
			exit;
		}
	}
}

function ap_process_respondent_activate()
{
	if (	array_key_exists('sid', $_GET) &&
		!empty($_GET['sid'])
	)
	{
		$resp = ap_resp_init();

		if (is_object($resp))
		{
			if ($info = $resp->Get_Request_Info($resp->_oci->spValue($_GET['sid'])))
			{
				$res = (int)$resp->Activate($info['ap_respondent_id_']);

				if ($res)
				{
					$info = $resp->Get_Info($info['ap_respondent_id_']);
					mail_respondent($info['email_'], page_cms('email_subject'), page_cms('email_body'), get_href(57), $info['first_name_'], $info['last_name_'], $info['sex_']);

					$url = get_href(68);

					header('Location: '.$url);
					exit;
				}
				else
				{
					$error['page_error'] = 'Server is busy, please try again...';
					$error['page_error_flag'] = 1;

					trigger_error($error['page_error']);
				}
			}
			else
			{
				$res = 0;
			}
		}
		else
		{
			$error['page_error'] = cons('Can\'t activate respondent');

			trigger_error($error['page_error']);

			$res = 0;
		}
	}
	else
	{
		$res = 0;
	}

	return $res;
}


function ap_process_login_form($redirect=true)
{
	if (count($_POST))
	{
		switch($_POST['action'])
		{
			case 'access_package.authorize':
		
				global $error;

				$error = array();

				$resp = ap_resp_init();

				if (is_object($resp))
				{
					$_POST['login'] = trim($_POST['login']);
					$_POST['passw'] = trim($_POST['passw']);

					if ($resp->Baned($_POST['login']))
					{
						$_POST['is_email_baned'] = 'yes';
					}
					elseif ($resp->Authorize($_POST['login'], $_POST['passw']))
					{
						$info = $resp->Get_Info_By_Email($_POST['login']);
//vdump($info, '$info');
//if (DEBUG_MODE) { exit; }
						if ($info)
						{
							$_SESSION['respondent']['id_'] = $info['respondent_id_'];
							$_SESSION['respondent']['email_'] = $info['email_'];

							if ($redirect)
							{
								header('Location: '.get_href(45));
							}
						}
						else
						{
							$error['page_error'] = cons('Can\'t login');
							$error['page_error_flag'] = 1;
						}
					}
					else
					{
						$error['page_error'] = page_cms('page_error');
						$error['page_error_flag'] = 1;
					}
				}
				else
				{
					$error['page_error'] = cons('Can\'t login');
					$error['page_error_flag'] = 1;
//					$error['oci_debug'] = $resp->_oci->get_debug();

					trigger_error($error['page_error']);
				}

				break;

			case 'respondent_logout':

				unset($_SESSION['respondent']);

				if ($redirect)
				{
					header('Location: '.EE_HTTP);
				}

				break;
		}
	}
}

function ap_process_password_reminder_form()
{
	if (count($_POST))
	{
		global $error;

		$error = array();

		$_POST['email_'] = trim($_POST['email_']);

		if (!check_email($_POST['email_']))
		{
			$error['email_'] = cons('Enter e-mail in standart format');
		}

		if (count($error)==0)
		{
			$resp = ap_resp_init();

			$res = $resp->Check_If_Email_Exists($_POST['email_']);

			if ($res)
			{
				$hash_code = $resp->Reset_Password_Get_Hash_Code($_POST['email_']);

				if ($hash_code)
				{
					$info = $resp->Get_Info_By_Email($_POST['email_']);
					mail_respondent($_POST['email_'], page_cms('email_subject'), page_cms('email_body'), get_href('respondent-password-update').uri_separator().'sid='.$hash_code, $info['first_name_'], $info['last_name_'], $info['sex_']);
				}
				else
				{
					$error['email_'] = $resp->_oci->_error_message;
				}
			}
			else
			{
				$error['email_'] = cons('User with such e-mail not exists');
			}
		}

		if (count($error)>0)
		{
			$error['page_error'] = page_cms('page_error');
			$error['page_error_flag'] = 1;
		}
		else
		{
			header('Location: '.get_href('password_reminde_sended'));
			exit;
		}
	}
}

function ap_process_approv_form()
{
	ap_process_password_form('respondent_registration_approved_success');
}

function ap_process_remind_form()
{
	ap_process_password_form('password_update_success');
}

function ap_process_password_form($location)
{
	if (count($_POST))
	{
		global $error;

		$error = array();

		$captcha = ap_captcha_init();

		if ($captcha->check($_POST['captcha_code']) == false)
		{
			$error['captcha_code'] = cons('Captcha is incorrect');
		}

		$_POST['password'] = trim($_POST['password']);
		$_POST['password_confirm'] = trim($_POST['password_confirm']);

		if ($_POST['password'] != $_POST['password_confirm'])
		{
			$error['password'] = $error['password_confirm'] = cons('Passwords are not the same');
		}
		elseif (empty($_POST['password']))
		{
			$error['password'] = $error['password_confirm'] = cons('Password must be not empty');
		}
		else
		{
			$resp = ap_resp_init();

			if (is_object($resp))
			{
				$info = $resp->Get_Request_Info($resp->_oci->spValue($_POST['sid']));
				$info = $resp->Get_Info($info['ap_respondent_id_']);

				if (!ap_check_password($_POST['password'], $info['email_']))
				{
					$error['password'] = $error['password_confirm'] = PASSWORD_NOT_MUTCH_RULES;
				}
			}
			else
			{
				$error['page_error'] = 'Server is busy, please try again...';
			}
		}

		if (count($error))
		{
			if (	array_key_exists('password', $error) &&
				$error['password'] == PASSWORD_NOT_MUTCH_RULES)
			{
				$error['page_error'] = longtext_edit_cms('password_rules_error_header').cms('password_rules_error_header').longtext_edit_cms('password_rules_error').cms('password_rules_error');
			}
			elseif (!array_key_exists('page_error', $error))
			{
				$error['page_error'] = page_cms('page_error');
			}

			$error['page_error_flag'] = 1;
		}
		else
		{
			if ($resp->Reset_Password($resp->_oci->spValue($_POST['sid']), $resp->_oci->spValue($_POST['password'])))
			{
				mail_respondent($info['email_'], page_cms('email_subject'), page_cms('email_body'), get_href(57), $info['first_name_'], $info['last_name_'], $info['sex_']);

				$url = get_href($location);

				header('Location: '.$url);
				exit;
			}
			else
			{
				if (count($resp->Get_Errors()))
				{
					$error['page_error'] = implode('<br/>', $resp->Get_Errors());
				}
				elseif ($resp->_oci->Get_Error())
				{
					// ошибку на уровне БД юзеру не показываем, а отправляем в офис
					// todo: перенести весь подобный код в class AccessPanel_Respondent
					trigger_error($resp->_oci->Get_Error(), E_USER_ERROR);
					$error['page_error'] = page_cms('page_error');
				}

				if (count($error))
				{
					$error['page_error_flag'] = 1;
				}
			}
		}
	}
}

function ap_check_captcha($captcha_name='captcha_code', $error)
{
	$captcha = ap_captcha_init();

	if ($captcha->check($_POST[$captcha_name]) == false)
	{
		$error[$captcha_name] = cons('Captcha is incorrect');
	}

	return $error;
}

function ap_check_respondent_fields()
{
	$error = array();

	$ar_trim_fields = array(
		'first_name_',
		'last_name_',
		'house_',
		'flat_',
		'email_',
		'reffer_email_',
		'city_phone_number_',
		'cell_phone_number_',

		'region_other',
		'city_other',
		'settlement_other',
		'street_other'

	);

	$_POST['email_'] = str_replace(' ', '', $_POST['email_']);
	$_POST['reffer_email_'] = str_replace(' ', '', post('reffer_email_'));

	foreach($ar_trim_fields as $key)
	{
		if (array_key_exists($key, $_POST))
		{
			$_POST[$key] = trim($_POST[$key]);
			$_POST[$key] = preg_replace("/(\ )+/", ' ', $_POST[$key]);

			global $$key;
			$$key = $_POST[$key];
		}
	}

	$error = ap_check_captcha('respondent_fields_captcha_code', $error);

	if (!array_key_exists('sex_', $_POST))
	{
		$error['sex_'] = e_cms_cons('Mandatory field');
	}

	if (empty($_POST['last_name_']))
	{
		$error['last_name_'] = e_cms_cons('Mandatory field');
	}

	if (empty($_POST['first_name_']))
	{
		$error['first_name_'] = e_cms_cons('Mandatory field');
	}

	if (empty($_POST['flat_']))
	{
		$error['flat_'] = e_cms_cons('Mandatory field');
	}

	$ar_address_fields = array(
		'district_id_',
		'region_',
		'city_',
		'settlement_',
		'street_'
	);

	foreach($ar_address_fields as $address_field)
	{
		if (	$_POST[$address_field] == OPTION_VALUE_DEFAULT
			||
			$_POST[$address_field] == OPTION_VALUE_OTHER &&
			$_POST[$address_field.'other'] == ''
		)
		{
			$error[$address_field] = e_cms_cons('Mandatory field');
		}
	}



//	if (!preg_match("/^([0-9])+([\ \-]){0,1}([a-zA-Zа-яА-Я]){0,1}$/", $_POST['house_']))
	if (empty($_POST['house_']))
	{
		$error['house_'] = e_cms_cons('Mandatory field');
	}

	if (!preg_match("/^[1-9]([0-9]){0,3}$/", $_POST['flat_']))
	{
		$error['flat_'] = e_cms_cons('Incorrect flat number');
	}

	if (	empty($_POST['city_phone_number_']) &&
		empty($_POST['cell_phone_number_'])
	)
	{
		$error['city_phone_number_'] = e_cms_cons('Enter at least one phone');
	}

	if (	!empty($_POST['city_phone_number_']) &&
		!check_phone('city_phone_number_', $error)
	)
	{
//var_dump($error['city_phone_number_']);
		if (empty($error['city_phone_number_']))
		{
			$error['city_phone_number_'] = e_cms_cons('Enter phone number with code (10 digits)');
		}
	}

	if (	!empty($_POST['cell_phone_number_']) &&
		!check_phone('cell_phone_number_', $error, explode(', ', AP_ALLOWED_CELL_PHONE_CODES))
	)
	{
		if (empty($error['cell_phone_number_']))
		{
			$error['cell_phone_number_'] = e_cms_cons('Enter phone number with code (10 digits)');
		}
	}

	if (!check_email($_POST['email_']))
	{
		$error['email_'] = cons('Enter e-mail in standart format');
	}

	if (	!empty($_POST['reffer_email_']) &&
		!check_email($_POST['reffer_email_'])
	)
	{
		$error['reffer_email_'] = cons('Enter e-mail in standart format');
	}


	if (!checkdate((int)$_POST['birth_date_m'], (int)$_POST['birth_date_d'], (int)$_POST['birth_date_y']))
	{
		$error['birth_date_'] = cons('Date is incorrect');
	}

	return $error;
}

function check_phone($phone_field_name, &$error, $ar_allowed_phone_codes=null)
{
//var_dump($phone_field_name);
	$phone = $_POST[$phone_field_name];
//var_dump($phone);
	$res = false;

	if (preg_match("/^([0-9]){10}$/", $phone))
	{
//vdump($ar_allowed_phone_codes);
		if (	empty($ar_allowed_phone_codes)
			||
			is_array($ar_allowed_phone_codes) &&
			in_array(substr($phone, 0, 3), $ar_allowed_phone_codes)
		)
		{
			$res = true;
		}
		else
		{
			$error[$phone_field_name] = e_cms_cons('Unknown provider code');
//var_dump($error);
		}
	}

	return $res;
}

function check_webmoney_purse_number($purse)
{
//logTo('$purse', 'purse_number.txt');
//logTo($purse, 'purse_number.txt');
	$res = false;

	if (preg_match("/^U([0-9]){12}$/", $purse))
	{
		$numbers = ltrim($purse, 'U');
//logTo('$numbers', 'purse_number.txt');
//logTo($numbers, 'purse_number.txt');

		if (strlen($numbers) == 12)
		{
			$res = true;
		}
	}
//logTo('$res', 'purse_number.txt');
//logTo($res, 'purse_number.txt');

	return $res;
}

function ap_process_registration_form()
{
	if (count($_POST))
	{
		global $error;

		$error = ap_check_respondent_fields();

		if (empty($_POST['checkboxConfirm']))
		{
			$error['checkboxConfirm'] = cons('Please read rules');
		}

		$_POST['password'] = trim($_POST['password']);
		$_POST['password_confirm'] = trim($_POST['password_confirm']);

		if (	$_POST['password'] != $_POST['password_confirm']
			||
			empty($_POST['password'])
			||
			!ap_check_password($_POST['password'], $_POST['email_'])
		)
		{
			$error['password'] = $error['password_confirm'] = PASSWORD_NOT_MUTCH_RULES;
		}

		if (count($error) > 0)
		{
			$error['page_error'] = page_cms('page_error');
//var_dump($error['city_phone_number_']);
			foreach (array('birth_date_', 'city_phone_number_', 'cell_phone_number_', 'email_', 'reffer_email_') as $field_name)
			{
				if (	array_key_exists($field_name, $error) &&
					!empty($error[$field_name]) &&
					strpos($error['page_error'], $error[$field_name])===false
				)
				{
					$error['page_error'].= '<br/>'.$error[$field_name];
				}
			}

			if (	array_key_exists('password', $error) &&
				$error['password'] == PASSWORD_NOT_MUTCH_RULES)
			{
				$error['page_error'].= '<br/>'.longtext_edit_cms('password_rules_error').cms('password_rules_error');
			}
		}
		else
		{
			$resp = ap_resp_init();

			$_POST['email_'] = trim($_POST['email_']);
			$_POST['reffer_email_'] = trim($_POST['reffer_email_']);

			$resp_in_db_id_city = $resp_in_db_id_cell = false;

			if (array_key_exists('city_phone_number_', $_POST) && !empty($_POST['city_phone_number_']))
			{
				$resp_in_db_id_city = $resp->Get_Respondent_Id_By_Phone($_POST['city_phone_number_']);
			}

			if (array_key_exists('cell_phone_number_', $_POST) && !empty($_POST['cell_phone_number_']))
			{
				$resp_in_db_id_cell = $resp->Get_Respondent_Id_By_Phone($_POST['cell_phone_number_']);
			}

			
			foreach (array('region', 'city', 'settlement', 'street') as $addr_type)
			{
				if (	$_POST[$addr_type] == OPTION_VALUE_OTHER &&
					ereg("^[0-9]+$", $_POST[$addr_type.'_other'])
				)
				{
					$error['page_error'].= ($error[$addr_type.'_other_'] = e_cms_cons('Incorrect '.$addr_type).'.').'<br/>';
				}
			}


			if ($res = $resp->Check_If_Email_Exists($_POST['email_']))
			{
				$error['page_error'].= cons('User with such e-mail already exists').'<br/>';
				$error['email_'] = '1';
			}
			elseif (!empty($_POST['reffer_email_']) &&
				!($res = $resp->Check_If_Email_Exists($_POST['reffer_email_']))
			)
			{
				$error['page_error'] = $error['reffer_email_'] = e_cms_cons('There is no reffer with such e-mail');
			}
			elseif ($resp_in_db_id_city || $resp_in_db_id_cell)
			{
				if ($resp_in_db_id_city)
				{
					$check_info = $resp->Get_Info($resp_in_db_id_city);

					if ($resp->Baned($check_info['email_']))
					{
//bug_id=0021465
// ­Ґ гзЁвлў вм § Ў«®ЄЁа®ў ­­ле о§Ґа®ў ЇаЁ Їа®ўҐаЄҐ ­ «ЁзЁп вҐ«Ґд®­  ў Ў §Ґ
//						$error['page_error'].= e_cms_cons('User with such city phone already blocked').'<br/>';
//						$error['city_phone_number_'] = '1';
					}
					else
					{
						$error['page_error'].= e_cms_cons('User with such city phone already exists').'<br/>';
						$error['city_phone_number_'] = '1';
					}
				}

				if ($resp_in_db_id_cell)
				{
					$check_info = $resp->Get_Info($resp_in_db_id_cell);

					if ($resp->Baned($check_info['email_']))
					{
//bug_id=0021465
// ­Ґ гзЁвлў вм § Ў«®ЄЁа®ў ­­ле о§Ґа®ў ЇаЁ Їа®ўҐаЄҐ ­ «ЁзЁп вҐ«Ґд®­  ў Ў §Ґ
//						$error['page_error'].= e_cms_cons('User with such cell phone already blocked').'<br/>';
//						$error['cell_phone_number_'] = '1';
					}
					else
					{
						$error['page_error'].= e_cms_cons('User with such cell phone already exists').'<br/>';
						$error['cell_phone_number_'] = '1';
					}

				}
			}
			else
			{
				$res = $resp->Add(

					$_POST['last_name_'],
					$_POST['first_name_'],
					$_POST['sex_'],
					$_POST['birth_date_d'].'.'.$_POST['birth_date_m'].'.'.$_POST['birth_date_y'],

					$_POST['city_phone_number_'],
					$_POST['cell_phone_number_'],
        
					$_POST['email_'],
        
					$_POST['district_id_'],

					( $_POST['region_']==OPTION_VALUE_OTHER ? $_POST['region_other'] : $_POST['region_'] ),
					( $_POST['city_']==OPTION_VALUE_OTHER ? $_POST['city_other'] : $_POST['city_'] ),
					( $_POST['settlement_']==OPTION_VALUE_OTHER ? $_POST['settlement_other'] : $_POST['settlement_'] ),
					( $_POST['street_']==OPTION_VALUE_OTHER ? $_POST['street_other'] : $_POST['street_'] ),

					$_POST['house_'],
					$_POST['flat_'],
					$_POST['reffer_email_'],
					$_SERVER['REMOTE_ADDR'],
					(array_key_exists('tnsId', $_POST) ? $_POST['tnsId'] : null)
				);

				if ($res)
				{
					$hash_code = $resp->Reset_Password_Get_Hash_Code($_POST['email_']);
        
					if ($hash_code)
					{
						if ($resp->Reset_Password($resp->_oci->spValue($hash_code), $resp->_oci->spValue($_POST['password'])))
						{
							$subj = page_cms('email_subject');

							$body = page_cms('email_body');

							mail_respondent($_POST['email_'], $subj, $body, get_href('respondent_activate').uri_separator().'sid='.$hash_code, $_POST['first_name_'], $_POST['last_name_'], $_POST['sex_']);
						}
						else
						{
							$error['page_error'] = cons('Can\'t reset password');
							$error['oci_debug'] = $resp->_oci->get_debug();

							trigger_error($error['page_error']);
						}
					}
					else
					{
						$error['page_error'] = cons('Can\'t obtain hash code');
						$error['oci_debug'] = $resp->_oci->get_debug();

						trigger_error($error['page_error']);
					}
				}
				else
				{
					$error['page_error'] = cons('Can\'t add respondent');
					$error['page_error'].= '<br/>'.implode('<br/>', $resp->Get_Errors());
					$error['oci_debug'] = $resp->_oci->get_debug();
//					trigger_error($error['page_error'], E_USER_ERROR);
				}
			}
		}

		if (array_key_exists('page_error', $error))
		{
			$error['page_error_flag'] = 1;
		}
		else
		{
			header('Location: '.get_href('respondent-registered-success'));
			exit;
		}
	}
}


function ap_process_edit_profile_form()
{
	global $page_error_sfx;

	$page_error_sfx = '_edit_profile';

	if (count($_POST) && array_key_exists('respondent_id_', $_POST))
	{
		$_POST['birth_date_'] = $_POST['birth_date_d'].'.'.$_POST['birth_date_m'].'.'.$_POST['birth_date_y'];

		global $error;

		$error = ap_check_respondent_fields();

		$resp = ap_resp_init();

		if (!$resp->Authorize($resp->_oci->spValue(ap_get_respondent_email()), $resp->_oci->spValue($_POST['pass_'])))
		{
			$error['pass_'] = cons('Incorrect password');
		}


		foreach (array('region', 'city', 'settlement', 'street') as $addr_type)
		{
			if (	$_POST[$addr_type] == OPTION_VALUE_OTHER &&
				ereg("^[0-9]+$", $_POST[$addr_type.'_other'])
			)
			{
				$error['page_error'].= ($error[$addr_type.'_other_'] = e_cms_cons('Incorrect '.$addr_type).'.').'<br/>';
			}
		}

		if (count($error) > 0)
		{
			$error['page_error'.$page_error_sfx] = page_cms('page_error').'<br/>'.$error['page_error'];
		}
		else
		{
			$res = $resp->Edit(

				$_POST['respondent_id_'],
				$_POST['last_name_'],
				$_POST['first_name_'],
				$_POST['sex_'],
				$_POST['birth_date_'],

				$_POST['city_phone_number_'],
				$_POST['cell_phone_number_'],

				$_POST['email_'],

				$_POST['district_id_'],

				( $_POST['region_']==OPTION_VALUE_OTHER ? $_POST['region_other'] : $_POST['region_'] ),
				( $_POST['city_']==OPTION_VALUE_OTHER ? $_POST['city_other'] : $_POST['city_'] ),
				( $_POST['settlement_']==OPTION_VALUE_OTHER ? $_POST['settlement_other'] : $_POST['settlement_'] ),
				( $_POST['street_']==OPTION_VALUE_OTHER ? $_POST['street_other'] : $_POST['street_'] ),

				$_POST['house_'],
				$_POST['flat_']
			);


			if (!$res)
			{
				$error['page_error'.$page_error_sfx] = cons('Can\'t update respondent info');
				trigger_error($error['page_error'.$page_error_sfx]);
			}
		}

		if (array_key_exists('page_error'.$page_error_sfx, $error))
		{
			$error['page_error_flag'.$page_error_sfx] = 1;
			$info = $_POST;
		}
		else
		{
			header('Location: '.get_href('respondent_updated'));
			exit;
		}
	}
	else
	{
		if ($respondent_id = ap_get_respondent_id())
		{
			$resp = ap_resp_init();

			if (is_object($resp))
			{
				$info = $resp->Get_Info($respondent_id);
			}
//vdump($info, '$info');
		}
	}

	if (isset($info) && is_array($info))
	{
		foreach($info as $key=>$val)
		{
//			if (substr($key, -1) == '_')
			{
				global $$key;
				$$key = $val;
//vdump($$key, $key);
			}
		}

		global $birth_date_d, $birth_date_m, $birth_date_y;
		$ar_birth_date = explode('.', $birth_date_);

		$birth_date_d = $ar_birth_date[0];
		$birth_date_m = $ar_birth_date[1];
		$birth_date_y = $ar_birth_date[2];
	}
}


function ap_process_password_update_form()
{
	global $page_error_sfx;

	$page_error_sfx = '_password_update';

	if (count($_POST) && array_key_exists('old_password', $_POST))
	{
		global $error;

		$error = ap_check_captcha('password_update_captcha_code', $error);

		$resp = ap_resp_init();

		if (!is_object($resp))
		{
			$error['page_error'.$page_error_sfx] = cons('Can\'t update respondent info');
			trigger_error($error['page_error'.$page_error_sfx]);
		}
		elseif (!$resp->Authorize($resp->_oci->spValue(ap_get_respondent_email()), $resp->_oci->spValue($_POST['old_password'])))
		{
			$error['old_password'] = cons('Incorrect password');
		}

		if ($_POST['new_password'] != $_POST['confirm_password'])
		{
			$error['new_password'] = $error['confirm_password'] = cons('Passwords are not the same');
		}
		elseif ($_POST['new_password'] == '')
		{
			$error['new_password'] = $error['confirm_password'] = cons('Password must be not empty');
		}
		elseif (!ap_check_password($_POST['new_password'], ap_get_respondent_email()))
		{
			$error['new_password'] = $error['confirm_password'] = PASSWORD_NOT_MUTCH_RULES;
		}


		if (count($error)>0)
		{
//vdump($error, '$error');
			if ($error['new_password'] == PASSWORD_NOT_MUTCH_RULES)
			{
				$error['page_error'.$page_error_sfx] = longtext_edit_cms('password_rules_error_header').cms('password_rules_error_header').longtext_edit_cms('password_rules_error').cms('password_rules_error');
			}
			elseif (!array_key_exists('page_error'.$page_error_sfx, $error))
			{
				$error['page_error'.$page_error_sfx] = page_cms('page_error');
			}
//vdump($error, '$error 2');
		}
		else
		{
			$res = $resp->Password_Update(
				ap_get_respondent_email(),
				$_POST['new_password']
			);


			if (!$res)
			{
				$error['page_error'.$page_error_sfx] = cons('Can\'t update respondent info');
				trigger_error($error['page_error'.$page_error_sfx]);
			}
		}

		if (	is_array($error) &&
			array_key_exists('page_error'.$page_error_sfx, $error)
		)
		{
			$error['page_error_flag'.$page_error_sfx] = 1;
		}
		else
		{
			header('Location: '.get_href('password-updated-success'));
			exit;
		}
	}
}

function ap_process_project_complete()
{
	// By default will go to page Potochni-proekty    Поточн_ проекти    current_projects.tpl 
	$page_id = 45;
	
logTo("\r\n\t".'date/time: '.date("Y-m-d H:i:s"), 'ap_process_project_complete.txt');

	if (	array_key_exists('project_code', $_GET) &&
		(0==1 or is_object($resp = ap_resp_init()))
	)
	{
		$ar_out_results = array (
			0 => cons('Operation complete successfull'), //операция прошла успешно
			1 => cons('Survey was complete before'), //респондент уже проходил этот опрос
			2 => cons('This respondent was not registered on this survey'), //респондент не был зарегистрирован на опросе
			3 => cons('Project already closed'), //проект уже закрыт
			4 => cons('There is no project with such code'), //не найден проект с таким кодом
			5 => cons('There is no respondent with such code') // не найден респондент с таким кодом
		);

		$project_code = $_GET['project_code'];
		$respondent_code = ( $_GET['respondent_code'] ? $_GET['respondent_code'] : ap_get_respondent_id() );
		$complete_type = ( $_GET['complete_type'] ? $_GET['complete_type'] : 1 );

logTo('$project_code: '.$project_code, 'ap_process_project_complete.txt');
logTo('$respondent_code: '.$respondent_code, 'ap_process_project_complete.txt');
logTo('$complete_type: '.$complete_type, 'ap_process_project_complete.txt');

		$res = $resp->Project_Complete($project_code, $respondent_code, $complete_type);

logTo('$res: '.$res, 'ap_process_project_complete.txt');

		if (	$res !== false &&
			array_key_exists($res, $ar_out_results)
		)
		{
			$res = $ar_out_results[$res];

logTo('$res 2: '.$res, 'ap_process_project_complete.txt');
			// In this case will go to page survey-history    _стор_я опитувань    survey_history.tpl 
			$page_id = 30;
		}

logTo('$page_id: '.$page_id, 'ap_process_project_complete.txt');

//		return $res;
	}

	header('Location: '.get_href($page_id));
	exit;
}


function ap_check_password($passw, $login)
{
	if (!defined('AP_PASSWORD_MIN_LEN'))	define('AP_PASSWORD_MIN_LEN', 6);
	if (!defined('AP_PASSWORD_DIF_CASES'))	define('AP_PASSWORD_DIF_CASES', false);
	if (!defined('AP_PASSWORD_LETTERS'))	define('AP_PASSWORD_LETTERS', false);
	if (!defined('AP_PASSWORD_DIGITS'))	define('AP_PASSWORD_DIGITS', false);
	if (!defined('AP_PASSWORD_NO_LOGIN'))	define('AP_PASSWORD_NO_LOGIN', false);


	if (	AP_PASSWORD_MIN_LEN &&
		strlen($passw) < AP_PASSWORD_MIN_LEN
		||
		AP_PASSWORD_DIF_CASES &&
		(
			$passw == strtolower($passw)
			||
			$passw == strtoupper($passw)
		)
		||
		AP_PASSWORD_LETTERS &&
		preg_match("/([a-zA-Z]+)/", $passw)==0
		||
		AP_PASSWORD_DIGITS &&
		preg_match("/([0-9]+)/", $passw)==0
		||
		AP_PASSWORD_NO_LOGIN &&
		preg_match("/'.$login.'/i", $passw)
	)
	{
		$result = false;
	}
	else
	{
		$result = true;
	}

	return $result;
}


