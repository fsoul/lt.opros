<style>
    #change_pass{
        position: relative;
    }
</style>
<script>
    $(document).ready(function(){
        $('#change_pass .inp').siblings('.hint').hide();
        $('#change_pass .inp').hover(function(){
            $(this).siblings('.hint').show();
        },function(){
            $(this).siblings('.hint').hide();
        });


    });
</script>