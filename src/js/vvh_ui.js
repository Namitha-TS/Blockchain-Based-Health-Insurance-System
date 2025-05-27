$(function(){


    $( "#tabs" ).tabs().css({
    	'min-height': '500px',
    	'overflow': 'auto'
    });

    $('body').css('background-color', '#F08C28');
    //#F47802');
    //#2383A9');

	//$( '#button_vvh' ).button();

    $("#btn-reg-policy-holder").button();
    $("#btn-reg-appraiser").button();
    $("#btn-reg-adjuster").button();

    $("#btn-open").button();
    $("#btn-appraise").button();
    $("#btn-approve").button();

    //$("#btn-reg-policy-holder").button().on( App.handleRegisterPolicyHolder);
    //$("#btn-reg-appraiser").button().on( handleRegisterAppraiser);
    //$("#btn-reg-adjuster").button().on( App.handleRegisterAdjuster);

	//$( '#btn-register' ).button().on();
	
	//$( '.btn-openClaim' ).button().on(App.handleOpenClaim);
	//$( '.btn-appraiseClaim' ).button();
	//$( '.btn-approveClaim' ).button();


});
