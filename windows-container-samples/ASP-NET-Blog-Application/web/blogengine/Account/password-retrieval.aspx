<%@ Page Title="Password Retrieval" Language="C#" MasterPageFile="~/Account/account.master" AutoEventWireup="true" Inherits="Account.PasswordRetrieval" CodeBehind="password-retrieval.aspx.cs" %>

<%@ MasterType VirtualPath="~/Account/account.master" %>
<%@ Import Namespace="BlogEngine.Core" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <h1 class="account-title"><%=Resources.labels.passwordRetrieval %></h1>
    <div class="account-body">
        <div class="form-group with-icon first-child">
            <label>Username</label>

            <asp:TextBox ID="txtUser" runat="server" placeholder="" AutoCompleteType="None" CssClass="textEntry form-control "></asp:TextBox>
        </div>
        <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="<%$Resources:labels,send %>" CssClass="btn btn-block btn-success" OnClick="LoginButton_Click" OnClientClick="return ValidatePasswordRetrieval()" />

        <script type="text/javascript">
            $(document).ready(function () {
                $("input[name$='txtUser']").focus();
            });
        </script>
    </div>
</asp:Content>
