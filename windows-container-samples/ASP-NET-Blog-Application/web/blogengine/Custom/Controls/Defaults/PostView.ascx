<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.PostViewBase" %>
<article class="post" id="post<%=Index %>">
	<h2><a href="<%=Post.RelativeOrAbsoluteLink %>"><%=Server.HtmlEncode(Post.Title) %></a></h2>
    <asp:PlaceHolder ID="BodyContent" runat="server" />
</article>