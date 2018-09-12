<script>
    // main_register.js
    document.ready = function () {
        var reg_resid_placeholder = '<%e_cms_cons:reg_resid_placeholder%>';
        var bd_placeholder = '<%e_cms_cons:bd_placeholder%>';
        var nomatch = '<%e_cms_cons:nomatch%>';
        var agr_msg = '<%e_cms_cons:agr_msg%>';
        var incorectData = '<%e_cms_cons:incorectData%>';
        var emptyResidence = '<%e_cms_cons:emptyResidence%>';
        var checkAllData = '<%e_cms_cons:checkAllData%>';
        var msgs = {
            reg_email_msg: '<%e_cms_cons:isEmailExist_msg%>',
            reg_pass_msg:'<%e_cms_cons:isValidPass_msg%>',
            //reg_pass_confirm_msg: '<%e_cms_cons:isValidPass_msg%>',
            //reg_birthdate_msg: '<%e_cms_cons:isValidDate_msg%>',
            //reg_name_msg: '<%e_cms_cons:isAlpha_msg%>',
            //reg_phone_msg: '<%e_cms_cons:isAllowedPhone_msg%>',
            //reg_residence_msg: '<%e_cms_cons:isNonEmpty_msg%>',
            //reg_how_msg: '<%e_cms_cons:isNonEmpty_msg%>',
            //know_about_msg: 'example'
        };
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
                $(e.target).closest('.inp_wrap').append('<div class="warning_i" style="background: url(/css/images/redesign/warning.png)no-repeat center;"></div>');
            }else{
                $(e.target).removeClass('warning');
            }
        });

        var $city = $('#reg_residence_id');

        $city.change(function(e){
            $(e.target).css('color', '#333');
            validator.showResult(e.target);
            $(e.target).trigger('blur');
        });

        $city.blur(function (e) {
            if(e.target.value == '...' ){
                validator.messages.push(emptyResidence);
                validator.showResult(e.target);
                $(e.target).addClass('warning');
                $(e.target).closest('.inp_wrap').append('<div class="warning_i" style="background: url(/css/images/redesign/warning.png)no-repeat center;"></div>');
            }else{
                $(e.target).removeClass('warning');
            }
        });

        function fixedEncodeURI (str) {
            return encodeURI(str).replace(/%5B/g, '[').replace(/%5D/g, ']');
        }

        $('#reg_residence').focus(function(){
            $('.cityList').removeClass('invis');
            $searchInput.trigger('focus');
        });

        $searchInput.blur(function(){
            setTimeout(function () {
                var $reg_residence = $('#reg_residence');
                $('.cityList').addClass('invis');
                if($reg_residence.val() == 0){
                    validator.messages.push(emptyResidence);
                    validator.showResult($reg_residence);
                    $($reg_residence).addClass('warning');
                }
            }, 150);
        });

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

        $('.inp').focus(function(){
            $('.hint').remove();
        });

        $inp.hover(function () {
                    var msg = msgs[this.id + '_msg'];
                    if (msg !== undefined) {
                        var input_row = $(this).closest('.inp_wrap');
                        if (input_row.find(".warning_i").length) {
                            if ($(this).hasClass('warning')) {
                                //input_row.append('<div class="hint warning"><div class="triangle"></div>' + msg + '</div>');
                            } else {
                                input_row.append('<div class="hint valid_hint"><div class="triangle"></div>' + msg + '</div>');
                            }
                        } else {
                            input_row.append('<div class="hint"><div class="triangle"></div>' + msg + '</div>');
                        }
                    }
                },
                function () {
                    $('.hint').remove();
                }
        );

        $inp.blur(function(el){
            var target = el.target || el.currentTarget;
            var key = target.id;
            var obj = {};

            if(key == 'reg_phone'){
                obj[key] = $('#reg_phone').inputmask('unmaskedvalue');
            }else{
                obj[key] = target.value;
            }

            validator.validate(obj, target);
        });

        function emailPreValidate(value){
            return (value.length > 0 && /.+@.+\..+/i.test(value));
        }
        function phonePreValidate(value){
            return /^((\+)+([0-9]){8,12})$/g.test(value);
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
                        if(type === 'isEmailExist' || type === 'isAllowedPhone'){
                            var preValidate = type === 'isEmailExist' ? emailPreValidate(data[i]): phonePreValidate(data[i]);
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
                var flag;
                if(this.hasErrors()){
                    lockSubmit();
                    $(target).addClass('warning');
                    flag = 'i_error';
                    url = 'url(/css/images/redesign/warning.png)no-repeat center';
                }else{
                    $(target).removeClass('warning');
                    unlockSubmit();
                    flag = 'i_valid';
                    url = 'url(/css/images/redesign/valid.png)no-repeat center';
                }
                $(input_row).append('<div class="warning_i ' + flag + '"></div>');
                var $current_icon = $(input_row).find('.warning_i');
                if($current_icon.length > 1){
                    $current_icon.first().remove();
                }
                if(this.messages[0] != undefined){
                    $current_icon.append('<div class="error_flag warning"><div class="triangle"></div>' + this.messages[0] + '</div>');
                }
                $current_icon.css('background', url);
                $('.error_flag').not(":contains(" + this.messages[0] + ")").remove();
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
            reg_phone: "isAllowedPhone",
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
                var unicodeWord = XRegExp("^\\pL+$");
                return unicodeWord.test(value);
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

        $('.show_pass').toggle(function() {
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

        $("#reg_birthdate").inputmask("9999/99/99");
        $('#reg_email').inputmask({
            mask: "*{1,30}[.*{1,20}][.*{1,20}][.*{1,20}]@*{1,20}[.*{2,6}][.*{1,2}]",
            greedy: false,
            onBeforePaste: function (pastedValue, opts) {
                pastedValue = pastedValue.toLowerCase();
                return pastedValue.replace("mailto:", "");
            },
            definitions: {
                '*': {
                    validator: "[0-9A-Za-z!#$%&'*+/=?^_`{|}~\-]",
                    cardinality: 1,
                    casing: "lower"
                }
            }
        });

        $('#reg_submit_btn').click(function (e) {
            if($('#tns_id').val() == '') $('#tns_id').val(window["IDCore"].getId());

            if($city.val() == '...'){
                validator.messages.push(emptyResidence);
                validator.showResult(e.target);
                $($city).addClass('warning');
                $($city).closest('.inp_wrap').append('<div class="warning_i" style="background: url(/css/images/redesign/warning.png)no-repeat center;"></div>');
                e.preventDefault();
            }

            if($know_about.val() == '...'){
                $($know_about).addClass('warning');
                $($know_about).closest('.inp_wrap').append('<div class="warning_i" style="background: url(/css/images/redesign/warning.png)no-repeat center;"></div>');
                e.preventDefault();
            }

            if ($('#agr_rul_conf').prop('checked')) {
                return;
            } else {
                e.preventDefault();
                $('.submit_btn').append('<div class="error_flag warning"><div class="triangle"></div>' + agr_msg + '</div>');
            }
        });

        $('#agr_rul_conf').click(function () {
            $('.submit_btn').find('.warning').remove();
        });
    };

    var imNotARobot = function () {
        var response = grecaptcha.getResponse();
        var emptyFields = [];
        $('#search_inp').removeClass('warning');
        $('.reg_form_wrapper .inp').each(function(indx, el){
            if(!el.value){
                emptyFields.push(el);
            }
        });

        var fieldsCount = 7;
        var lang = '<%getValueOf:language%>'.toLowerCase();
        if ((window.location.pathname).toLowerCase() == "/" + lang + "/user-profile.html"){
            fieldsCount = 3;
        }

        var isGenderChecked = $('input[name="sex"]').is(':checked');
        var isUserAgreementChecked = $('#agr_rul_conf').is(':checked');
        var isUserPersonalDataChecked = $('#pers_agr_rul_conf').is(':checked');
        var captcha = response.length !== 0;
        var noWarn = $('.warning').length === 0;
        var notEmpty = emptyFields.length === 0;

        if(captcha && noWarn && notEmpty && isGenderChecked && isUserAgreementChecked && isUserPersonalDataChecked){
            $('.reg_submit_btn').prop("disabled", false);
        }else{
            lockSubmit();
            var msg;
            if(emptyFields.length === fieldsCount && noWarn){
                msg = "<%e_cms_cons:all_required%>";
                $('.g_captcha').append('<div class="hint"><div class="triangle"></div>' + msg + '</div>');
            }else{
                msg = "<%e_cms_cons:checkAllData%>";
                $('.g_captcha').append('<div class="error_flag warning"><div class="triangle"></div>' + msg + '</div>');
            }
            grecaptcha.reset();
        }
    };

    var lockSubmit = function(){
        $('.reg_submit_btn').prop("disabled", true);
    };

    var unlockSubmit = function () {
        var captcha = grecaptcha.getResponse();
        var warnings = $('.warning').length;
        var emptyFields = [];
        $('.reg_form_wrapper .inp').each(function (indx, el) {
            if (!el.value) {
                emptyFields.push(el);
            }
        });
        if (captcha.length != 0 && warnings == 0 && emptyFields.length == 0) {
            $('.reg_submit_btn').prop("disabled", false);
        }
    };

    var captchaExpired = function(){
        lockSubmit();
    };
</script>
