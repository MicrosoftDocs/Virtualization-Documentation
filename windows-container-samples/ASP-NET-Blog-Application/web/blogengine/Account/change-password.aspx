<%@ Page Language="C#" MasterPageFile="account.master" AutoEventWireup="true" Inherits="Account.ChangePassword" CodeBehind="change-password.aspx.cs" %>

<%@ MasterType VirtualPath="~/Account/account.master" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
        <h1 class="account-title"><%=Resources.labels.changePassword %></h1>

 
    <asp:ChangePassword ID="ChangeUserPassword" runat="server" CancelDestinationPageUrl="~/"
        EnableViewState="false" RenderOuterTable="false">
        <ChangePasswordTemplate>
               <div class="account-body">
           
                <div class="form-group first-child">
                    <asp:Label ID="CurrentPasswordLabel" runat="server" CssClass="label-up" AssociatedControlID="CurrentPassword"><%=Resources.labels.oldPassword %>:</asp:Label>
                    <asp:TextBox ID="CurrentPassword" runat="server" placeholder="" CssClass="passwordEntry form-control ltr-dir" TextMode="Password"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label ID="NewPasswordLabel" runat="server" CssClass="label-up" AssociatedControlID="NewPassword"><%=Resources.labels.newPassword %>:</asp:Label>
                    <asp:TextBox ID="NewPassword" runat="server" CssClass="passwordEntry form-control ltr-dir" TextMode="Password"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label ID="ConfirmNewPasswordLabel" CssClass="label-up" runat="server" AssociatedControlID="ConfirmNewPassword"><%=Resources.labels.confirmNewPassword %>:</asp:Label>
                    <asp:TextBox ID="ConfirmNewPassword" runat="server" CssClass="passwordEntry form-control ltr-dir" TextMode="Password"></asp:TextBox>
                </div>
                <div class="btn-wrapper">
                    <asp:Button ID="ChangePasswordPushButton" CssClass="btn btn-block btn-success" runat="server" CommandName="ChangePassword" Text="<%$Resources:labels,changePassword %>" OnClick="ChangePasswordPushButton_Click" OnClientClick="return ValidateChangePassword();" />
                </div>

            </div>
        </ChangePasswordTemplate>
    </asp:ChangePassword>
    <asp:HiddenField ID="hdnPassLength" runat="server" />
</asp:Content>
