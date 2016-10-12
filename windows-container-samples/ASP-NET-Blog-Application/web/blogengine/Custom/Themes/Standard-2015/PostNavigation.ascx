<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.PostNavigationBase" %>
<div id="postnavigation" class="navigation-posts well-global">
    <div class="row">
        <div class="col-sm-6 text-left next-post">
            <% if(!string.IsNullOrEmpty(NextPostUrl)){ %>
            <a href="<%=NextPostUrl %>" class="nav-next"> &larr; <%=NextPostTitle %> </a>
            <% } %> 
        </div>   
                  
        <div class="col-sm-6 text-right prev-post">
            <% if(!string.IsNullOrEmpty(PreviousPostUrl)){ %>
            <a href="<%=PreviousPostUrl %>" class="nav-prev"><%=PreviousPostTitle %> &rarr;</a>
            <% } %> 
        </div>
    </div>
</div>
