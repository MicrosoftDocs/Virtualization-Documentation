<%@ Page Title="" Language="C#" MasterPageFile="account.master" AutoEventWireup="true" Inherits="Account.CreateBlog" CodeBehind="create-blog.aspx.cs" %>

<%@ MasterType VirtualPath="~/Account/account.master" %>
<%@ Import Namespace="BlogEngine.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">

    <h1 class="account-title"><%=Resources.labels.createBlog %></h1>
    <div class="account-body">
        <div class="form-group first-child ltr-dir">
            <label class="label-up"><%=BlogEngine.Core.Utils.AbsoluteWebRoot %><span id="blogId" style="font-weight: bold"></span></label>
            <asp:TextBox ID="BlogName" runat="server" CssClass="textEntry form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label ID="UserLabel" runat="server" CssClass="label-up" AssociatedControlID="UserName"><%=Resources.labels.userName %>:</asp:Label>
            <asp:TextBox ID="UserName" runat="server" CssClass="textEntry form-control ltr-dir"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label ID="EmailLabel" runat="server" CssClass="label-up" AssociatedControlID="Email"><%=Resources.labels.email %>:</asp:Label>
            <asp:TextBox ID="Email" runat="server" CssClass="textEntry form-control ltr-dir"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label ID="PasswordLabel" runat="server" CssClass="label-up" AssociatedControlID="Password"><%=String.Format(Resources.labels.passwordMinimumCharacters, Membership.MinRequiredPasswordLength) %></asp:Label>
            <asp:TextBox ID="Password" runat="server" CssClass="passwordEntry form-control ltr-dir" TextMode="Password"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label ID="ConfirmPasswordLabel" runat="server" CssClass="label-up" AssociatedControlID="ConfirmPassword"><%=Resources.labels.confirmPassword %>:</asp:Label>
            <asp:TextBox ID="ConfirmPassword" runat="server" CssClass="passwordEntry form-control ltr-dir" TextMode="Password"></asp:TextBox>
        </div>
        <blog:RecaptchaControl ID="recaptcha" runat="server" />
        <asp:Button ID="CreateUserButton" runat="server" Text="Create" CssClass="btn btn-success btn-block" OnClientClick="return ValidateNewBlog()" OnClick="CreateUserButton_Click" />
        <script type="text/javascript">
            $(document).ready(function () {
                $("input[name$='BlogName']").focus();

                $(function () {
                    $('#<%= BlogName.ClientID %>').keyup(function () {
                    $('#blogId').text($(this).val());
                });
            });
        });
        </script>
    </div>
</asp:Content>

