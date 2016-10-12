<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.RelatedPostsBase" %>
<div id="relatedPosts" class="related-posts well-global">
    <h3 class="well-global-title"><%=Resources.labels.relatedPosts %></h3>
    <ul class="list-unstyled">
        <%foreach (var item in RelatedPostList)
          {%>
        <li><a href="<%=item.Link %>"><%=item.Title %></a>
            <div><small class="text-muted"><%=item.Description %></small></div>
        </li>
        <% } %>
    </ul>
</div>
