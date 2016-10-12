<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.CommentFormBase" %>
<%@ Import Namespace="BlogEngine.Core" %>
<div class="commentForm">
    <h3 id="addcomment"><%=Resources.labels.addComment %></h3>
    <p>
        <label for="txtName" class="lbl-user"><%=Resources.labels.name %>*</label>
        <input type="text" class="txt-user" name="txtName" id="txtName" tabindex="2" />
    </p>
    <p>
        <label for="txtEmail" class="lbl-email"><%=Resources.labels.email %>*</label>
        <input type="text" class="txt-email" ID="txtEmail" TabIndex="3" />
        <span id="gravatarmsg"></span>
    </p>
    <p>
        <label for="txtWebsite" class="lbl-website"><%=Resources.labels.website%></label>
        <input type="text" class="txt-website" ID="txtWebsite" TabIndex="4" />
        </p>
    <p>
        <label for="txtContent" class="lbl-content"><%=Resources.labels.comment%>*</label>
        <textarea class="txt-content" tabindex="7" id="txtContent" cols="50" rows="10" name="txtContent"></textarea>
    </p>
    <p>
        <input type="checkbox" id="cbNotify" class="cmnt-frm-notify" style="width: auto" tabindex="8" />
        <label for="cbNotify" style="width: auto; float: none; display: inline; padding-left: 5px"><%=Resources.labels.notifyOnNewComments %></label>
    </p>
    <p>
        <input type="button" id="btnSaveAjax" class="btn-save" style="margin-top: 10px" value="<%=Resources.labels.saveComment %>" onclick="return BlogEngine.validateAndSubmitCommentForm()" tabindex="10" />
    </p>
</div>