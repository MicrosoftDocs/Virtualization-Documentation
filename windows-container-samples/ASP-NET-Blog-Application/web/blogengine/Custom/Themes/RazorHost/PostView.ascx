<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.PostViewBase" %>
<%@ Import Namespace="BlogEngine.Core" %>

<script runat="server">

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        ParseAndInjectRazor();
    }

    private void ParseAndInjectRazor()
    {
        string vPath = string.Format("~/Custom/Themes/{0}/PostView.cshtml", BlogSettings.Instance.Theme);
        string parsedRazor = RazorHelpers.ParseRazor(vPath, this);  // 'this' is PostViewBase.

        if (!string.IsNullOrWhiteSpace(parsedRazor))
        {
            phContent.Controls.Add(new LiteralControl(parsedRazor));
        }
    }
        
</script>
<asp:PlaceHolder ID="phContent" runat="server" EnableViewState="false"></asp:PlaceHolder>
