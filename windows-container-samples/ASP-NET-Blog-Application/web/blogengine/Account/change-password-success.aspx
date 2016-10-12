<%@ Page Title="Change Password" Language="C#" MasterPageFile="account.master" AutoEventWireup="true" Inherits="Account.ChangePasswordSuccess" CodeBehind="change-password-success.aspx.cs" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent"></asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <h1 class="account-title">
        <%=Resources.labels.changePassword %>
    </h1>
    <div class="account-body">
        <div id="ChangePwd" class="alert alert-success">
            <%=Resources.labels.passwordChangeSuccess %>
        </div>
        <br />
        <div class="btn-wrapper">
	        <input type="button" class="btn btn-block btn-success" id="goHome" onclick="window.location.href='<%=BlogEngine.Core.Utils.RelativeWebRoot%>'" value="<%=Resources.labels.home %>" />
        </div>
    </div>
</asp:Content>
