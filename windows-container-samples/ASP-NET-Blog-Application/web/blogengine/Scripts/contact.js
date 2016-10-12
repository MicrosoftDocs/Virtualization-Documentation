function beginSendMessage() {
    if ($('[data-id="txtAttachment"]').length > 0 && $('[data-id="txtAttachment"]').val().length > 0)
        return true;

    if (!Page_ClientValidate('contact'))
        return false;

    var recaptchaResponseField = $('#recaptcha_response_field');
    var recaptchaResponse = recaptchaResponseField.length > 0 ? recaptchaResponseField.val() : "";

    var recaptchaChallengeField = $('#recaptcha_challenge_field');
    var recaptchaChallenge = recaptchaChallengeField.length > 0 ? recaptchaChallengeField.val() : "";

    var name = $('[data-id="txtName"]').val();
    var email = $('[data-id="txtEmail"]').val();
    var subject = $('[data-id="txtSubject"]').val();
    var message = $('[data-id="txtMessage"]').val();
    var sep = '-||-';
    var arg = name + sep + email + sep + subject + sep + message + sep + recaptchaResponse + sep + recaptchaChallenge;
    WebForm_DoCallback('__Page', arg, endSendMessage, 'contact', onSendError, false)

    $('[data-id="btnSend"]').attr("disabled", true);

    return false;
}

function endSendMessage(arg, context) {

    if (arg == "RecaptchaIncorrect") {
        displayIncorrectCaptchaMessage();
        $('[data-id="btnSend"]').attr("disabled", "");

        if ($('#recaptcha_response_field').length > 0) {
            Recaptcha.reload();
        }
    }
    else {
        if ($("#spnCaptchaIncorrect")) $("#spnCaptchaIncorrect").css("display", "none");

        $('[data-id="btnSend').attr("disabled", "");
        var form = $('[data-id="divForm');
        var thanks = $('#thanks');

        form.css("display", "none");
        thanks.html(arg);
    }
}

function displayIncorrectCaptchaMessage() {
    if ($("#spnCaptchaIncorrect")) $("#spnCaptchaIncorrect").css("display", "none");
}

function onSendError(err, context) {
    if ($('#recaptcha_response_field')) {
        Recaptcha.reload();
    }
    $('[data-id="btnSend"]').css("display", "none");
    alert("Sorry, but the following occurred while attemping to send your message: " + err);
}