<%@ Control Language="C#" AutoEventWireup="true" Inherits="App_Code.Controls.WidgetContainer" %>
<%@ Import Namespace="BlogEngine.Core" %>

<script runat="server">

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        ParseAndInjectRazor();
    }

    public override void RenderContainer()
    {
        base.RenderContainer();
        ParseAndInjectRazor();
    }
    
    private bool _rendered;
    private void ParseAndInjectRazor()
    {
        if (_rendered) { return; }
        
        string vPath = string.Format("~/Custom/Themes/{0}/WidgetContainer.cshtml", BlogSettings.Instance.Theme);
        string parsedRazor = RazorHelpers.ParseRazor(vPath, this);  // 'this' is WidgetContainer.

        if (!string.IsNullOrWhiteSpace(parsedRazor))
        {
            int placeHolderPos = parsedRazor.IndexOf(RazorHelpers.WIDGET_CONTAINER_BODY_MARKER, StringComparison.OrdinalIgnoreCase);
            if (placeHolderPos != -1)
            {
                string beforePlaceholderMarkup = parsedRazor.Substring(0, placeHolderPos);
                string afterPlaceholderMarkup = parsedRazor.Substring(placeHolderPos + RazorHelpers.WIDGET_CONTAINER_BODY_MARKER.Length);

                phBeforeContainerBody.Controls.Add(new LiteralControl(beforePlaceholderMarkup));
                phAfterContainerBody.Controls.Add(new LiteralControl(afterPlaceholderMarkup));
            }
        }
        
        _rendered = true;
    }
        
</script>

<asp:PlaceHolder ID="phBeforeContainerBody" runat="server" />
<asp:PlaceHolder ID="phWidgetBody" runat="server" />
<asp:PlaceHolder ID="phAfterContainerBody" runat="server" />
