<?

class AccessPanel_DB_Oracle
{
	var $_connection = null;
	var $_servername = null;
	var $_username = null;
	var $_password = null;

	var $_error = null;
	var $_error_code = null;
	var $_error_message = null;
	var $_debug = null;

	var $_table_prefix = '';

	function __construct($username, $password, $servername)
	{
		if (function_exists('oci_pconnect'))
		{
			$conn = oci_pconnect($username, $password, $servername);
		}
		else
		{
			$conn = null;
		}

		if (is_resource($conn))
		{
			$this->_connection = $conn;
			$this->_servername = $servername;
			$this->_username = $username;
			$this->_password = $password;

			$this->query('ALTER SESSION SET NLS_DATE_FORMAT=\''.AP_DATE_FORMAT_ORACLE.'\'');
		}
		else
		{
			if (	function_exists('oci_error') &&
				is_array($ar_err = oci_error())
			)
			{
				$this->_error = $ar_err;
				$this->_error_code = $ar_err['code'];
				$this->_error_message = $ar_err['message'];
			}
			else
			{
				$this->_error_message = 'No oci_ functions!';
			}

			trigger_error($this->_error_message);
		}
	}


	public function Get_Error()
	{
		return $this->_error_message;
	}

	public function Get_Errors()
	{
		return array($this->Get_Error());
	}


	function __destruct()
	{
		/*if ($this->is_connected())
		{
			oci_close($this->_connection);

			$this->_connection = null;
			$this->_servername = null;
			$this->_username = null;
			$this->_password = null;
		}
*/
		$this->_error = null;
		$this->_error_code = null;
		$this->_error_message = null;
		$this->_debug = null;
	}


	function execute($query)
	{
        	return $this->query($query);
	}


	function get_connection()
	{
		if ($this->is_connected())
		{
			return $this->_connection;
		}
		else
		{
			return false;
		}
	}


	function is_connected()
	{
		return is_resource($this->_connection);
	}


	function fetch($stid, $mode)
	{
		$res = false;

		if (is_resource($stid))
		{
			$row = array();

			if (OCIFetchInto($stid, $row, $mode+OCI_RETURN_LOBS))
			{
				$res = array_change_key_case($row);
			}
		}
		else
		{
			trigger_error('Not resource is provided here: '.$stid);
		}

		return $res;
	}

	function fetch_array($stid)
	{
		return $this->fetch($stid, OCI_NUM+OCI_ASSOC+OCI_RETURN_NULLS);
	}

	function fetch_assoc($stid)
	{
		return $this->fetch($stid, OCI_ASSOC+OCI_RETURN_NULLS);
	}

	function fetch_row($stid)
	{
		return $this->fetch($stid, OCI_NUM+OCI_RETURN_NULLS);
	}

	function num_fields($stid)
	{
		return OCINumCols($stid);
	}

	function num_rows($stid)
	{
		OCIExecute($stid, OCI_DEFAULT);

		$rows_num = OCIFetchStatement($stid, $arr_tmp=array());

		// OCIFetchStatment kills our query result
		// so we have to execute the statment again
		// if we ever want to use the $stid again.
		OCIExecute($stid, OCI_DEFAULT);

		return $rows_num;
	}

	function get_debug()
	{
		return $this->_debug;
	}

	function print_oci_error_array($ar_error)
	{
		$s = '';
		foreach ($ar_error as $k=>$v)
		{
			$s.= "\r\n".'['.$k.']: '.$v;
		}

		$s.= "\r\n";
		$s.= print_r(debug_backtrace(), true);

		$this->_debug = $s;
	}

	function get_query_as_array($query, $debug=0, $limit1=null, $limit2=null)
	{
		return $this->get_query_as_('array', $query, $debug, $limit1, $limit2);
	}

	function get_query_as_assoc($query, $debug=0, $limit1=null, $limit2=null)
	{
		return $this->get_query_as_('assoc', $query, $debug, $limit1, $limit2);
	}

	function get_query_as_row($query, $debug=0, $limit1=null, $limit2=null)
	{
		return $this->get_query_as_('row', $query, $debug, $limit1, $limit2);
	}

	function get_query_as_($type, $query, $debug=0, $limit1=null, $limit2=null)
	{
		$func_name = 'fetch_'.$type;

		$res = $this->query($query, $debug, $limit1, $limit2);

		$ar = array();
		$i = 0;

		while ($row = $this->$func_name($res))
		{
			$ar[$i++] = $row;
		}

		return $ar;
	}


	function query($query, $debug=0, $limit1=null, $limit2=null)
	{
		if ($debug)
		{
			msg($query, 'Query');
		}

		if ($limit1!=null)
		{
			if ($limit2==null)
			{
				// limit 10
				$limit_start = 1;
				$limit_end = $limit1;
			}
			else
			{
				// limit 5,10
				$limit_start = $limit1;
				$limit_end = $limit1+$limit2-1;
			}

			$query = self::limit_records($query, $limit_start, $limit_end);

			if ($debug)
			{
				msg($query, 'Query limited');
			}
		}

		$db = $this->_connection;

		if (!($stid = OCIParse($db, $query)))
		{
			$this->print_oci_error_array(OCIError($db));
			$result = false;
		}
		elseif (!(OCIExecute($stid, OCI_DEFAULT)))
		{
			$this->print_oci_error_array(OCIError($stid));
			$result = false;
		}
		else
		{
			$result = $stid;
		}

		return $result;
	}

	function sp($proc_name, &$ar_params, $debug_mode=0, $commit=true)
	{
		$query = $proc_name.'(:'.implode(', :', array_keys($ar_params)).')';

		$query = str_replace(chr(10), '', $query);
		$query = str_replace(chr(13), '', $query);
		$query = trim($query);

		$query = 'begin '.$query.'; '.( $commit ? 'commit; ' : '' ).'end;';

		if ($debug_mode)
		{
			vdump($query, 'query');
			vdump($ar_params, 'ar_params');
logTo("\r\n\t".'Date/Time: '.date("Y-m-d H:i:s"), $proc_name.'.txt');
if (count($_POST))
{
	logTo(print_r($_POST, true), $proc_name.'.txt');
}
logTo($query, $proc_name.'.txt');
logTo($ar_params, $proc_name.'.txt');

		}

		if (!is_array($ar_params))
		{
			$result = false;
		}
		elseif (!($stid = OCIParse($this->_connection, $query)))
		{
			$this->print_oci_error_array(OCIError($this->_connection));
			$result = false;
		}
		else
		{
			foreach($ar_params as $param=>$val)
			{
				oci_bind_by_name($stid, ":".$param, $ar_params[$param], 1024);
			}
	
			if (!(@OCIExecute($stid, OCI_DEFAULT)))
			{
logTo("\r\n\t".'Date/Time: '.date("Y-m-d H:i:s"), 'sp.txt');

logTo($ar_params, 'sp.txt');
				$ar_err = OCIError($stid);
logTo($ar_err, 'sp.txt');
				vdump($ar_err, '$ar_err');

logTo('code: '.$ar_err['code'], 'sp.txt');
				if (	$ar_err['code']<20000
					OR
					$ar_err['code']>20999	)
				{
logTo('print_oci_error_array', 'sp.txt');
					$this->print_oci_error_array($ar_err);
					$result = false;
				}
				else // user seted error
				{
					$this->_error = $ar_params['error'] = $ar_err;
					$this->_error_code = $ar_err['code'];

					preg_match("/^ORA-([0-9]*):(.*)/i", $ar_err['message'], $ar_matches);
					$this->_error_message = $ar_matches[2];
logTo('$this->_error_message: '.$this->_error_message, 'sp.txt');

					$result = false;
				}

				vdump($this->_error_message, '$this->_error_message');
			}
			else
			{
				$result = $stid;
			}

			if ($debug_mode)
			{
				vdump($result, '$result');
				vdump($ar_params, 'ar_params');
				vdump($result, 'result');
			}
		}


		if ($debug_mode)
		{
			vdump($result, '$result');
			vdump($ar_params, 'ar_params');
logTo($result, $proc_name.'.txt');
logTo($ar_params, $proc_name.'.txt');
		}

		return $result;
	}
	

	function result($result, $row, $field)
	{
//		return mysql_result($result, $row, $field);
	}

	function affected_rows($stmt)
	{
		return OCIRowCount($stmt);
	}

	function rows_affected($stmt)
	{
		return OCIRowCount($stmt);
	}

	function select_db($database_name, $link_identifier)
	{
		return ((bool)$link_identifier);
	}


	function escape_string($str)
	{
		return self::oci_escape_string($str);
	}

	function oci_escape_string($str)
	{
		return str_replace(array("'"), array("''"), $str);
	}

	function insert_id()
	{
//		return mysql_insert_id();
	}

	function error()
	{
		$ar = OCIError();
		if (is_array($ar))
			return implode('<br>', $ar);
		else
			return null;
	}

	function table_fields($table_name)
	{
		return $this->query_fields('SELECT * FROM '.$table_name);
	}

	function query_fields($sql)
	{
		$field_names = array();

		$ncols = $this->num_fields($stmt = $this->query($sql));

		for ($i = 1; $i <= $ncols; $i++)
		{
			$field_names[] = strtolower(OCIColumnName($stmt, $i));
		}

		return $field_names;
	}

	function is_enum_field($table_name, $field)
	{
		return false;
	}

	function show_enum_params($table_name, $field)
	{
		return array();
	}

	function db_date_field_format($date_field_name)
	{
		return 'to_char('.$date_field_name.', \''.DATE_FORMAT_ORACLE.'\')';
	}


	function limit_records($query, $start_record, $end_record)
	{
		$query = '
		SELECT *
		  FROM
			( SELECT
				main_query.*,
				ROWNUM AS record_number
			   FROM
				('.$query.') main_query
			  WHERE
				ROWNUM <= '.$end_record.'
			)
		  WHERE
			record_number >= '.$start_record;

		return $query;
	}


	/*
	* Use it in WHERE clause of SQL-queries
	*/
	function sqlValueWhere($var)
	{
		if (is_null($var))
		{
			$s = ' IS NULL ';
		}
		else
		{
			$s = ' = '.sqlValue($var);
		}

		return $s;
	}


	/*
	* Use it in SET clause of SQL-queries
	*/
	function sqlValueSet($var)
	{
		if (is_null($var))
		{
			$s = 'NULL';
		}
		else
		{
			$s = self::sqlValue($var);
		}

		return $s;
	}

	function sqlValue($var)
	{
		if (!isset($var) or is_null($var) or $var==='')
		{
			$s = '\'\'';
		}
		else
		{
			$s = '\''.(self::escape_string($var)).'\'';
		}

		return $s;
	}

	function spValue($var)
	{
		if (!isset($var) or is_null($var) or $var==='')
		{
			$s = 'NULL';
		}
		else
		{
			$s = self::escape_string($var);
		}

		return $s;
	}

	function getField($query, $field=0, $debug=0)
	{
		$rs = $this->query($query, $debug);

		if (is_int($field))
		{
			$row = $this->fetch_row($rs);
		}
		else
		{
			$row = $this->fetch_assoc($rs);
		}

		return $row[$field];
	}
}

