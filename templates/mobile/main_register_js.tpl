<script>
    // main_register_mobile.js
    document.ready = function () {
        var nomatch = '<%e_cms_cons:nomatch%>';
        var agrMsg = '<%e_cms_cons:agr_msg%>';
        var incorectData = '<%e_cms_cons:incorectData%>';
        var emptyResidence = '<%e_cms_cons:emptyResidence%>';
        var checkAllData = '<%e_cms_cons:checkAllData%>';
        var allRequired = "<%e_cms_cons:all_required%>";

        var errors = {
            old_pass_msg: '<%e_cms_cons:isValidOldPass_err%>',
            reg_email_msg: '<%e_cms_cons:isEmailExist_err%>',
            reg_pass_msg: '<%e_cms_cons:isValidPass_msg%>',
            reg_pass_confirm_msg: '<%e_cms_cons:isEqualToPass_err%>',
            reg_birthdate_msg: '<%cms_cons:incorectData%>',
            //reg_name_msg: 'name error',
            reg_phone_msg: '<%e_cms_cons:isAllowedPhone_err%>',
            //reg_residence_msg: 'residence error',
            //reg_how_msg: 'about error',
            //know_about_msg: 'example'
        };
        $('.user_agreement p br').remove();

        var $know_about = $('#know_about');
        var $searchInput = $('#search_inp');
        
        $know_about.change(function(e){
            $(e.target).css('color', '#333');
            validator.showResult(e.target);
            if(e.target.value == '-'){
                $('.inp_textarea').removeClass('invis');
            }else{
                $('.inp_textarea').addClass('invis');
            }
            $(e.target).trigger('blur');
        });

        $know_about.blur(function (e) {
            if(e.target.value == '...'){
                $(e.target).addClass('warning');
                $(e.target).closest('.inp_field').prepend('<div class="warning_i" style="background: url(/css/images/redesign/warning.png)no-repeat center;"></div>');
            }else{
                $(e.target).removeClass('warning');
            }
        });

        $('#reg_residence').focus(function(){
            $('.cityList').removeClass('invis');
            $searchInput.trigger('focus');
        });

        $searchInput.blur(function(){
            setTimeout(function () {
                $('.cityList').addClass('invis');
                if($('#reg_residence').val() == 0){
                    validator.messages.push(emptyResidence);
                    validator.showResult($('#reg_residence'));
                    $('#reg_residence').addClass('warning');
                }
            }, 100);
        });

        function fixedEncodeURI (str) {
            return encodeURI(str).replace(/%5B/g, '[').replace(/%5D/g, ']');
        }

        $searchInput.on('input', $.debounce( 300, false, function(){
            var curVal = this.value;
            var lang = '<%getValueOf:language%>'.toLowerCase();
            if(curVal.length > 2){
                $('.search_hint').addClass('invis');
                $.ajax({
                    type: "GET",
                    url: '/action.php?action=search_residence&search_string=' + fixedEncodeURI(curVal) + '&lang=' + lang,
                    success: function(data){
                        $('.listEl').remove();
                        if(data !== null){
                            showResponseList(JSON.parse(data), curVal);
                        }else{
                            showResponseList(data, curVal);
                        }
                    },
                    error: function (request, status, error) {
                        alert(request.responseText);
                    }
                });
            }else{
                $('.search_hint').removeClass('invis');
            }
        }));

        $('.cityList').on('click', 'li.city', function(e){
            var $reg_residence = $('#reg_residence');
            $reg_residence.val(e.target.firstChild.textContent);
            $('#reg_residence_id').val(e.target.id);
            validator.showResult($reg_residence);
        });

        function sortDicId(a,b) {
            var property = 'dic_city_id';
            return (+a[property]) < (+b[property]) ? -1 : (+a[property]) > (+b[property]) ? 1 : 0;
        }

        function showResponseList(data, query_string){
            var li_wrap = $('.li_wrap');
            if(data){
                var length = query_string.length;
                data.sort(sortDicId);
                $.each(data, function(indx, el){
                    $(li_wrap).append('<li class="city listEl" id=' + el.dic_city_id + '>' + el.name + '<span class="underline">' + (el.name).substr(0, length) + '</span></li>');
                });
            }else{
                $(li_wrap).append('<li class="listEl">' + nomatch + '</li>');
            }
        }

        var $inp = $('.inp:not(#reg_residence)');

        $inp.focus(function () {
            $('.nextStep').siblings('.m_error_flag').remove();
        });

        $inp.blur(function(el){
            var target = el.target || el.currentTarget;
            var key = target.id;
            var obj = {};

            if(key == 'reg_phone'){
                var phone = $('#reg_phone').val();
                obj[key] = phone.substr(3, phone.length);
            }else{
                obj[key] = target.value;
            }

            validator.validate(obj, target);
        });

        function emailPreValidate(value){
            return (value.length > 0 && /.+@.+\..+/i.test(value));
        }

        function phonePreValidate(value){
            return (value.length > 8);
        }

        var validator = {
            types: {},
            messages: [],
            config: {},
            result_ok: {},
            validate: function(data, target){
                var i, msg, type, checker;
                var self = this;
                for (i in data) {
                    if (data.hasOwnProperty(i)) {
                        type = this.config[i];
                        checker = this.types[type];
                        var resp = false;
                        if (!type) {
                            continue;
                        }
                        if (!checker) {
                            throw {
                                name: "ValidationError",
                                message: "No handler to validate type " + type
                            };
                        }
                        if(type == 'isEmailExist' || type == 'isAllowedPhone'){
                            var preValidate = type == 'isEmailExist' ? emailPreValidate(data[i]): phonePreValidate(data[i]);
                            if(preValidate){
                                checker.validate(data[i]).then(function (res) {
                                    this.result_ok = JSON.parse(res);
                                    resp = this.result_ok.response;

                                    if (resp) {
                                        msg = checker.instructions;
                                        self.messages.push(msg);
                                    }
                                    self.showResult(target);
                                });
                            }else{
                                msg = incorectData;
                                this.messages.push(msg);
                                self.showResult(target);
                            }
                        }else if(type == 'isValidOldPass' ) {
                            checker.validate(data[i]).then(function (res) {
                                this.result_ok = JSON.parse(res);
                                resp = this.result_ok.response;

                                if (!resp) {
                                    msg = checker.instructions;
                                    self.messages.push(msg);
                                }
                                self.showResult(target);
                            });
                        }else{
                            this.result_ok.response = checker.validate(data[i]);
                            if (!this.result_ok.response) {
                                msg = checker.instructions;
                                this.messages.push(msg);
                            }
                            self.showResult(target);
                        }

                    }
                }

            },
            hasErrors: function () {
                return this.messages.length !== 0;
            } ,
            showResult: function (target) {
                var input_row = target.closest('.inp_wrap');
                var icon = $(input_row).find('.inp_field');
                var flag;
                if(this.hasErrors()){
                    $(target).addClass('warning');
                    flag = 'i_error';
                    url = 'url(/css/images/redesign/warning.png)no-repeat center';
                }else{
                    $(target).removeClass('warning');
                    flag = 'i_valid';
                    url = 'url(/css/images/redesign/valid.png)no-repeat center';
                }
                icon.append('<div class="warning_i ' + flag + '"></div>');
                var $current_icon = $(input_row).find('.warning_i');
                if($current_icon.length > 1){
                    $current_icon.first().remove();
                }
                if(this.messages[0] != undefined){
                    if($(input_row).find('.m_error_flag').length == 0){
                        $(input_row).prepend('<div class="m_error_flag warning"><div class="triangle_bottom"></div>' + this.messages[0] + '</div>');
                    }
                }
                $current_icon.css('background', url);
                $('.m_error_flag').not(":contains(" + this.messages[0] + ")").remove();
                this.messages = [];
            }
        };

        validator.config = {
            old_pass: "isValidOldPass",
            reg_email: "isEmailExist",
            reg_pass: "isValidPass",
            reg_pass_confirm: "isEqualToPass",
            reg_name: "isAlpha",
            reg_birthdate: "isValidDate",
            //reg_phone: "isAllowedPhone",
            reg_residence: "isNonEmpty",
            reg_how: "isNonEmpty"
        };

        validator.types.isValidOldPass = {
            validate: function (value) {
                return new Promise(function(resolve, reject){
                    $('#old_pass').closest('.inp_wrap').find('.loader').removeClass('invis');
                    var resp_email = $('#resp_email').val();
                    $.ajax({
                        type: "GET",
                        url: '/action.php?action=check_old_pass&pass=' + value + '&email=' + resp_email,
                        success: function(data){
                            $('#old_pass').closest('.inp_wrap').find('.loader').addClass('invis');
                            resolve(data);
                        }
                    });
                });
            },
            instructions: errors.old_pass_msg
        };

        validator.types.isEmailExist = {
            validate: function (value) {
                return new Promise(function(resolve, reject){
                    $('#reg_email').closest('.inp_wrap').find('.loader').removeClass('invis');
                    $.ajax({
                        type: "GET",
                        url: '/action.php?action=check_reg_email&email=' + value,
                        success: function(data){
                            $('#reg_email').closest('.inp_wrap').find('.loader').addClass('invis');
                            resolve(data);
                        }
                    });
                });
            },
            instructions: errors.reg_email_msg
        };

        validator.types.isNonEmpty = {
            validate: function (value) {
                return value !== "";
            },
            instructions: errors.reg_how_msg
        };

        validator.types.isValidPass = {
            validate: function (value) {
                $('#reg_pass_confirm').val('');
                $('#reg_pass_confirm').closest('.inp_wrap').find('.warning_i').remove();
                return /^[A-Za-z0-9_]{6,}$/.test(value);
            },
            instructions: errors.reg_pass_msg
        };

        validator.types.isEqualToPass = {
            validate: function (value) {
                console.log(value === $('#reg_pass').val());
                value = value ? value : false;
                return (value === $('#reg_pass').val());
            },
            instructions: errors.reg_pass_confirm_msg
        };

        validator.types.isAlpha = {
            validate: function (value) {
                return /^[A-z\u0410-\u044f\u0406\u0456\u042d\u044d\u0490\u0491\u0407\u0457\s]+$/.test(value);
            },
            instructions: errors.reg_name_msg
        };

        validator.types.isValidDate = {
            validate: function (value) {
                var input = value.match(/\d+/g) ? value.match(/\d+/g) : false ,
                    date = new Date(input[0], input[1] - 1, input[2]);

                return date.getFullYear() == input[0] &&
                    date.getDate()     == input[2] &&
                    date.getMonth()    == input[1] - 1 &&
                    inAgeRange(input[0], input[1] - 1, input[2]);
            },
            instructions: errors.reg_birthdate_msg
        };

        function inAgeRange(year, month, day){

            var yearDiff = new Date().getFullYear() - new Date(year, month, day).getFullYear();
            var inpMonth = new Date(year, month, day).getMonth();
            var currMonth = new Date().getMonth();
            var inpDate = new Date(year, month, day).getDate();
            var currDate = new Date().getDate();

            if(yearDiff < 0){
                return false;
            }

            if((yearDiff == 0 && inpMonth > currMonth) || (yearDiff == 0 && inpMonth == currMonth && inpDate > currDate)){
                return false;
            }

            if(yearDiff > 99){
                return false;
            }
            return true;
        }

        validator.types.isAllowedPhone = {
            validate: function (value) {
                return new Promise(function(resolve, reject){
                    $('#reg_phone').closest('.inp_wrap').find('.loader').removeClass('invis');
                    $.ajax({
                        type: "GET",
                        url: '/action.php?action=check_reg_phone&phone=' + value,
                        success: function(data){
                            $('#reg_phone').closest('.inp_wrap').find('.loader').addClass('invis');
                            resolve(data);
                        }
                    });
                });
            },
            instructions: errors.reg_phone_msg
        };

        $('.show_pass').toggle(function () {
            $(this).removeClass('eyeon').addClass('eyeoff');
            $(this).siblings('input[type=password]').prop('type', 'text');
        },function () {
            $(this).removeClass('eyeoff').addClass('eyeon');
            $(this).siblings('input[type=text]').prop('type', 'password');
        });

        $('#reg_phone').focus(function(){
            if($(this).val().length == 0){
                $(this).val('+370');
            }
        });

        function reverseString(str) {
            return str.split("").reverse().join("");
        }
        //$("#reg_birthdate").inputmask("99/99/9999");
//        $("#reg_birthdate").on('change', function(e){
//            var $el = $(e.target);
//            var val = $el.val();
//            if(val[2] != '-' && val[2] != '/' && val[2] != '.'){
//                val = reverseString(val);
//            }
//
//            var dateDelim = val[2];
//            var regExp = new RegExp(dateDelim,"g");
//            var normaliseVal = val.replace(regExp, "/" );
//
//            $el.val(normaliseVal);
//        });

        $('.g-recaptcha').click(function (e) {
            $(e.target).find('.m_error_flag').remove();
        });

        steps = {
            current: 0,
            btnValues: [
                "<%e_cms_cons:reg_step_1%>",
                "<%e_cms_cons:reg_step_2%>",
                "<%e_cms_cons:reg_submit%>"
            ]
        };
        $('input[name="sex"]').change(function(e){
            var url = 'url(/css/images/redesign/valid.png)no-repeat center';
            var input_row = $(e.target).closest('.inp_wrap');
            var icon = $(input_row).find('.inp_field');
            var flag = 'i_valid';

            icon.append('<div class="warning_i ' + flag + '"></div>');
            var $current_icon = $(input_row).find('.warning_i');
            $current_icon.css('background', url);
            $('.m_error_flag').remove();
            $('input[name="sex"]').unbind('change');
        });

        $('#reg_submit_btn').on('click', function (e) {
            e.preventDefault();
            if($('#tns_id').val() == '') $('#tns_id').val(window["IDCore"].getId());
            $(':focus').trigger('blur');

            var $section = $('.section_wrap[data-section=' + steps.current + ']');
            var warnings = $section.find('.warning').length;
            var emptyFields = [];
            var sectionRequiredFields = $section.find('.inp');
            var msg = "<%e_cms_cons:checkAllData%>";

            $.each(sectionRequiredFields, function(indx, el) {
                if(!el.value){
                    emptyFields.push(el);
                }
            });

            if (warnings == 0 && emptyFields.length == 0) {
                if(steps.current == 1){
                    var isCheckedGender = $('input[name="sex"]').is(':checked');
                    $(e.target).closest('.submit_btn').find('.m_error_flag').remove();
                    if(!isCheckedGender){
                        $(e.target).closest('.submit_btn').prepend('<div class="m_error_flag warning"><div class="triangle_bottom"></div>' + msg + '</div>');
                    }else{
                        $('.section_wrap').hide();
                        $('.section_wrap[data-section=' + (++steps.current) + ']').show();
                        $(e.target).text(steps.btnValues[steps.current]);
                    }

                }else if(steps.current == 2){

                    var $agreeRules = $('.user_agreement');
                    var isAgreeRulesChecked = $('#agr_rul_conf').prop('checked') == undefined ? true : $('#agr_rul_conf').prop('checked');
                    var isValidCaptcha = !!(grecaptcha.getResponse()).length;
                    var isNoWarnings = !warnings;
                    var isEmptyNotExist = !emptyFields.length;

                    if (isEmptyNotExist && isNoWarnings && isAgreeRulesChecked && isValidCaptcha) {
                        $("form").submit();
                    } else {
                        $(e.target).closest('.submit_btn').find('.m_error_flag').remove();
                        $(e.target).closest('.submit_btn').prepend('<div class="m_error_flag warning"><div class="triangle_bottom"></div>' + msg + '</div>');
                        if(!isAgreeRulesChecked){
                            $agreeRules.prepend('<div class="m_error_flag warning"><div class="triangle_bottom"></div>' + agrMsg + '</div>');
                        }
                    }
                }else{
                    $('.section_wrap').hide();
                    $('.section_wrap[data-section=' + (++steps.current) + ']').show();
                    $(e.target).text(steps.btnValues[steps.current]);
                }
                $('html, body').animate({
                    scrollTop: $(".m_form").offset().top
                }, 500);
            }else{
                $(e.target).closest('.submit_btn').find('.m_error_flag').remove();
                $(e.target).closest('.submit_btn').prepend('<div class="m_error_flag warning"><div class="triangle_bottom"></div>' + msg + '</div>');
            }
        });

        $('#agr_rul_conf').click(function () {
            $('.m_error_flag').remove();
        });
    };

    var imNotARobot = function () {
        $('.m_error_flag').remove();
    };
</script>
