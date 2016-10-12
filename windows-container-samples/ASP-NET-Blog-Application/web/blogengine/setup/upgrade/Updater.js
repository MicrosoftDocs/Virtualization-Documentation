$(document).ready(function () {
    Check();
});

var newVersion = "";

function Check() {
    // CurrentVersion
    CheckVersion();

    if (!newVersion) { newVersion = ""; }

    if (newVersion.length > 0) {
        $("#spin1").hide();
        $("#spin2").hide();
        $("#spin3").hide();
        $("#spin4").hide();
        $("#spin5").hide();
        $("#spin9").hide();
        $("#step9").hide();
        $('#msg-success').hide();
        $('#spnNewVersion').html(newVersion);
    }
    else {
        $("#frm").hide();
        $("#btnRun").hide();
        $("h2").html("Looks like you already running latest version!");
    }
}

function CheckVersion() {
    $("#spin1").show();
    $.ajax({
        url: AppRoot + "setup/upgrade/Updater.asmx/Check",
        data: "{ version: '" + CurrentVersion + "' }",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (result) {
            newVersion = result.d; // "3.2.0.0";
        }
    });
}

var upgrade = function () {
    $("#btnRun").prop("disabled", true);
    $("#btnHome").prop("disabled", true);
    $("#btnBack").prop("disabled", true);
    Download();
}

// returns version to which blog can be upgrated
function Download() {
    $("#spin1").show();
    $.ajax({
        url: AppRoot + "setup/upgrade/Updater.asmx/Download",
        data: "{ version: '" + newVersion + "' }",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            var rt = result.d;
            if (rt.length > 0) {
                $("#spin1").hide();
                ShowError("1", rt);
            }
            else {
                ShowSuccess("1");
                Extract();
            }        
        }
    });
}

function Extract() {
    $("#spin2").show();
    $.ajax({
        url: AppRoot + "setup/upgrade/Updater.asmx/Extract",
        data: "{ }",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            var rt = result.d;
            if (rt.length > 0) {
                $("#spin2").hide();
                ShowError("2", rt);
            }
            else {
                ShowSuccess("2");
                Backup();
            }
        }
    });
}

function Backup() {
    $("#spin3").show();
    $.ajax({
        url: AppRoot + "setup/upgrade/Updater.asmx/Backup",
        data: "{ }",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            var rt = result.d;
            if (rt.length > 0) {
                $("#spin3").hide();
                ShowError("3", rt);
            }
            else {
                ShowSuccess("3");
                Delete();
            }
        }
    });
}

function Delete() {
    $("#spin4").show();
    $.ajax({
        url: AppRoot + "setup/upgrade/Updater.asmx/Delete",
        data: "{ }",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            var rt = result.d;
            if (rt.length > 0) {
                $("#spin4").hide();
                ShowError("4", rt);
            }
            else {
                ShowSuccess("4");
                Install();
            }
        }
    });
}

function Install() {
    $("#spin5").show();
    $.ajax({
        url: AppRoot + "setup/upgrade/Updater.asmx/Install",
        data: "{ }",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            var rt = result.d;
            if (rt.length > 0) {
                $("#spin5").hide();
                ShowError("5", rt);
            }
            else {
                ShowSuccess("5");
                $('#msg-success').show();
                $("#btnHome").prop("disabled", false);
                $("#btnBack").prop("disabled", false);
            }          
        }
    });
}

function Rollback() {
    $("#step9").show();
    $("#spin9").show();
    $.ajax({
        url: AppRoot + "setup/upgrade/Updater.asmx/Rollback",
        data: "{ }",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            var rt = result.d;
            if (rt.length > 0) {
                $("#step9").html("Sorry, roll back failed: " + rt + ". Please check our <a href='https://blogengine.codeplex.com/discussions' target='_new'>forum</a> for solution.");
                $("#spin9").hide();
            }
            else {
                var rt = result.d;
                $("#step9").html("Installation has ben rolled back. Please try again and, if it does not work, check our <a href='https://blogengine.codeplex.com/discussions' target='_new'>forum</a> for solution.");
                $("#step9").removeClass("alert-danger");
                $("#step9").addClass("alert-success");

                $("#btnHome").prop("disabled", false);
                $("#btnBack").prop("disabled", false);
            }
        }
    });
}

function ShowSuccess(item) {
    if ($("#spin" + item)) {
        $("#spin" + item).hide();
    }
    $("#step" + item).removeClass("alert-info");
    $("#step" + item).addClass("alert-success");

    // clean up if error in the step fixed by restart
    $("#step" + item).removeClass("alert-danger");
    if (item === "4") {
        $("#step4").html('<strong><span class="nu-up">4</span> Replace old files with new version</strong>');
    }
    if (item === "5") {
        $("#step5").html('<strong><span class="nu-up">5</span> Configuration and cleanup</strong>');
    }
}

function ShowError(item, msg) {
    if ($("#spin" + item)) {
        $("#spin" + item).hide();
    }
    $("#step" + item).removeClass("alert-info");
    $("#step" + item).addClass("alert-danger");
    $("#step" + item).find("strong").html(msg);
    $("#btnHome").prop("disabled", false);
    $("#btnBack").prop("disabled", false);
    // TODO:
    //Rollback();
    $("#btnRun").prop("disabled", false);
    $("#btnRun").html('Restart');
}

function CheckPermissions() {
    $("#msgList").empty();
    CheckPermission("trust");
    CheckPermission("root");
    CheckPermission("data");
    CheckPermission("Custom");
}

function CheckPermission(p) {
    $.ajax({
        url: AppRoot + "api/tools/" + p,
        type: "GET",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (result) {
            addMsg(result);
        }
    });
}

addMsg = function (data) {
    if (data.success === true) {
        $("#msgList").append('<div class="alert alert-dismissable alert-success"><span><i class="fa fa-check-circle"></i> ' + data.msg + '</span></div>');
    }
    else {
        $("#msgList").append('<div class="alert alert-dismissable alert-danger"><span><i class="fa fa-exclamation-triangle"></i> ' + data.msg + '</span></div>');
    }
}