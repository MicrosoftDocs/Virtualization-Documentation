<%@ Page Title="Register" Language="C#" MasterPageFile="account.master" AutoEventWireup="true" Inherits="Account.Register" CodeBehind="register.aspx.cs" %>

<%@ MasterType VirtualPath="~/Account/account.master" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:CreateUserWizard ID="RegisterUser" runat="server" EnableViewState="false" OnCreatedUser="RegisterUser_CreatedUser"
        OnCreatingUser="RegisterUser_CreatingUser">
        <WizardSteps>
            <asp:CreateUserWizardStep ID="RegisterUserWizardStep" runat="server">
                <ContentTemplate>
                    <h1 id="CreateHdr" class="account-title"><%=Resources.labels.createAccount %></h1>
                    <div class="account-body">
                        <div class="form-group first-child">
                            <asp:Label ID="UserNameLabel" runat="server" CssClass="label-up" AssociatedControlID="UserName"><%=Resources.labels.userName %>:</asp:Label>
                            <div class="boxRound">
                                <asp:TextBox ID="UserName" runat="server" CssClass="textEntry form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="EmailLabel" runat="server" CssClass="label-up" AssociatedControlID="Email"><%=Resources.labels.email %>:</asp:Label>
                            <div class="boxRound">
                                <asp:TextBox ID="Email" runat="server" CssClass="textEntry form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="PasswordLabel" runat="server" CssClass="label-up" AssociatedControlID="Password"><%=String.Format(Resources.labels.passwordMinimumCharacters, Membership.MinRequiredPasswordLength) %></asp:Label>
                            <div class="boxRound">
                                <asp:TextBox ID="Password" runat="server" CssClass="passwordEntry form-control" TextMode="Password"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="ConfirmPasswordLabel" runat="server" CssClass="label-up" AssociatedControlID="ConfirmPassword"><%=Resources.labels.confirmPassword %>:</asp:Label>
                            <div class="boxRound">
                                <asp:TextBox ID="ConfirmPassword" runat="server" CssClass="passwordEntry form-control" TextMode="Password"></asp:TextBox>
                            </div>
                        </div>
                        <blog:RecaptchaControl ID="recaptcha" runat="server" />

                        <div class="btn-wrapper text-center">
                            <asp:Button ID="CreateUserButton" CssClass="btn btn-success btn-block" runat="server" CommandName="MoveNext" Text="<%$Resources:labels,createUser %>" OnClientClick="return ValidateNewUser()" />


                     
                        </div>
                    </div>
                           <hr />

                       <div class="account-body text-center text-uppercase">
                           <%=Resources.labels.alreadyHaveAccount %>
                            <a id="HeadLoginStatus" runat="server"><%=Resources.labels.loginNow %></a>

                    </div>


                </ContentTemplate>
                <CustomNavigationTemplate>
                </CustomNavigationTemplate>
            </asp:CreateUserWizardStep>
        </WizardSteps>
    </asp:CreateUserWizard>
    <asp:HiddenField ID="hdnPassLength" runat="server" />
    <script type="text/javascript">
        $(document).ready(function () {
            $("input[name$='UserName']").focus();
        });
    </script>
</asp:Content>
