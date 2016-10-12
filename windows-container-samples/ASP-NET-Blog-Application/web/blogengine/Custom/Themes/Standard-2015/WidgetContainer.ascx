<%@ Control Language="C#" AutoEventWireup="true" Inherits="App_Code.Controls.WidgetContainer" %>
<div class="widget <%= Widget.Name.Replace(" ", String.Empty).ToLowerInvariant() %>" id="widget<%= Widget.WidgetId %>">
    <% if (!this.Widget.ShowTitle)
       { %> <%= AdminLinks %> <% } %>
    <% if (this.Widget.ShowTitle)
       { %>
    <h4 class="widget-header">
        <%= Widget.Title%>
        <span class="pull-right"><%= AdminLinks %></span>
    </h4>
    <% } %>
    <div class="widget-content">
        <asp:PlaceHolder ID="phWidgetBody" runat="server"></asp:PlaceHolder>
    </div>
</div>
