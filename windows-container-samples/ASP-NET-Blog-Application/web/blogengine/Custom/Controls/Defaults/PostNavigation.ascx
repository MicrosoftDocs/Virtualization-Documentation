<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.PostNavigationBase" %>
<div id="postnavigation">
    <a href="<%=NextPostUrl %>" class="nav-next"><%=NextPostTitle %></a> |
    <a href="<%=PreviousPostUrl %>" class="nav-prev"><%=PreviousPostTitle %></a>
</div>
