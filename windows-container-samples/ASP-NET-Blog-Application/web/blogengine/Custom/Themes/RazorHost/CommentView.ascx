<%@ Control Language="C#" EnableViewState="False" Inherits="BlogEngine.Core.Web.Controls.CommentViewBase" %>
<%@ Import Namespace="BlogEngine.Core" %>

<script runat="server">

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        ParseAndInjectRazor();
    }

    public override void RenderComment()
    {
        base.RenderComment();
        ParseAndInjectRazor();
    }
    
    private bool _rendered;
    private void ParseAndInjectRazor()
    {
        if (_rendered) { return; }
        
        string vPath = string.Format("~/Custom/Themes/{0}/CommentView.cshtml", BlogSettings.Instance.Theme);
        string parsedRazor = RazorHelpers.ParseRazor(vPath, this);  // 'this' is CommentViewBase.

        if (!string.IsNullOrWhiteSpace(parsedRazor))
        {
            // Assuming the Razor CommentView.cshtml is using @Html.NestedComments().
            int placeHolderPos = parsedRazor.IndexOf(RazorHelpers.NESTED_COMMENTS_MARKER, StringComparison.OrdinalIgnoreCase);
            if (placeHolderPos != -1)
            {
                string beforePlaceholderMarkup = parsedRazor.Substring(0, placeHolderPos);
                string afterPlaceholderMarkup = parsedRazor.Substring(placeHolderPos + RazorHelpers.NESTED_COMMENTS_MARKER.Length);

                phBeforeSubComments.Controls.Add(new LiteralControl(beforePlaceholderMarkup));
                phAfterSubComments.Controls.Add(new LiteralControl(afterPlaceholderMarkup));
            }
        }
        
        _rendered = true;
    }
        
</script>

<asp:PlaceHolder ID="phBeforeSubComments" runat="server" />
<asp:PlaceHolder ID="phSubComments" runat="server" />
<asp:PlaceHolder ID="phAfterSubComments" runat="server" />
