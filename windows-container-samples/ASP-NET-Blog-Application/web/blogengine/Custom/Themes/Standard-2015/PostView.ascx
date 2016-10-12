<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.PostViewBase" %>
<%@ Import Namespace="BlogEngine.Core" %>
<article class="post" id="post<%=Index %>">
    <header class="post-header">
        <h2 class="post-title">
            <a href="<%=Post.RelativeOrAbsoluteLink %>"><%=Server.HtmlEncode(Post.Title) %></a>
        </h2>
        <div class="post-info clearfix">
            <span class="post-date"><i class="glyphicon glyphicon-calendar"></i><%=Post.DateCreated.ToString("d. MMMM yyyy") %></span>
            <span class="post-author"><i class="glyphicon glyphicon-user"></i><a href="<%=Utils.AbsoluteWebRoot + "author/" + Utils.RemoveIllegalCharacters(Post.Author + BlogConfig.FileExtension) %>"><%=Post.AuthorProfile != null ? Utils.RemoveIllegalCharacters(Post.AuthorProfile.DisplayName) : Utils.RemoveIllegalCharacters(Post.Author) %></a></span>
            <span class="post-category"><i class="glyphicon glyphicon-folder-close"></i><%=CategoryLinks(", ") %></span>
            <a rel="nofollow" class="pull-right post-comment-link" href="<%=Post.RelativeOrAbsoluteLink %>#comment"><i class="glyphicon glyphicon-comment"></i>(<%=Post.ApprovedComments.Count %>)</a>
        </div>
    </header>
    <section class="post-body text">
        <asp:PlaceHolder ID="BodyContent" runat="server" />
    </section>

    <% if (Location == BlogEngine.Core.ServingLocation.SinglePost)
       {%>
    <footer class="post-footer">
        <div class="post-tags">
            <%=Resources.labels.tags %> : <%=TagLinks(", ") %>
        </div>
        <div class="post-rating">
            <%=Rating %>
        </div>
     
    </footer>

    <%} %>

       <%=AdminLinks %>
</article>
