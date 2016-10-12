<%@ Control Language="C#" EnableViewState="False" Inherits="BlogEngine.Core.Web.Controls.CommentViewBase" %>
<ul id="id_<%=Comment.Id %>" class="media-list">
    <li class="media comment-item">
        <div class="pull-left comment-gravatar <%= Post.Author.Equals(Comment.Author, StringComparison.OrdinalIgnoreCase) ? " self" : "" %>"><%= Gravatar(72)%> <div class="carrow"></div></div>
        <div class="media-body">
            <div class="comment-content <%= Post.Author.Equals(Comment.Author, StringComparison.OrdinalIgnoreCase) ? " self" : "" %>">
                <div class="comment-header clearfix">
                    <h4 class="media-heading pull-left"><%= Comment.Website != null ? "<a href=\"" + Comment.Website + "\" rel=\"nofollow\" class=\"url fn\">" + Comment.Author + "</a>" : "<span class=\"fn\">" +Comment.Author + "</span>" %></h4>
                    <small class="pull-right text-muted text-uppercase"><%= Comment.DateCreated  %> |  <%=ReplyToLink%> </small>
                </div>
                <p><%= Text %></p>
                <div class="text-right reply-to">
                    <%= AdminLinks.Length > 2 ? AdminLinks.Substring(2) : AdminLinks %>
                </div>
            </div>
            <div class="media" id="replies_<%=Comment.Id %>" <%= (Comment.Comments.Count == 0 || Comment.Email == "pingback" || Comment.Email == "trackback") ? " style=\"display:none;\"" : "" %>>
                <asp:PlaceHolder ID="phSubComments" runat="server" />
            </div>
        </div>
    </li>
</ul>