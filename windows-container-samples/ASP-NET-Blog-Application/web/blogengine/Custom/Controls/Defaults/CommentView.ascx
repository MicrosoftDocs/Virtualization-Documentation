<%@ Control Language="C#" EnableViewState="False" Inherits="BlogEngine.Core.Web.Controls.CommentViewBase" %>
<div>
	<h4>By <%= Comment.Author %> at <%= Comment.DateCreated %></h4>
	<p><%= Text %></p>
</div>