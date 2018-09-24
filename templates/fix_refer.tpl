<script>
    $(document).ready(function(){
        var $referEmail = $('#refer_email');
        var sc = '<div class="warning_i i_valid referr_valid" style="background: url(&quot;/css/images/redesign/valid.png&quot;) center center no-repeat;"></div>';
        $referEmail.parent().removeClass('invis');
        $referEmail.val(findGetParameter('reffer_email_'));
        $referEmail.prop('readonly', true);
        $('#know_about>option').prop('disabled', true);
        $('#know_about>option:eq(2)').prop('disabled', false).prop('selected', true);
        $('#know_about').parents('.inp_wrap').append(sc);

        function findGetParameter(parameterName) {
            var result = null,
                tmp = [];
            location.search
                .substr(1)
                .split("&")
                .forEach(function (item) {
                    tmp = item.split("=");
                    if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
                });
            return result;
        }

    });
</script>