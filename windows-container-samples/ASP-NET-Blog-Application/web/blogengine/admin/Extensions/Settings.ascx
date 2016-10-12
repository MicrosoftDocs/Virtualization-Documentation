<%@ Control Language="C#" AutoEventWireup="true" Inherits="Admin.Extensions.UserControlSettings" Codebehind="~/admin/Extensions/Settings.ascx.cs" %>
<h4><%=SettingName%> <%=Resources.labels.settings %></h4>
<div id="ErrorMsg" runat="server" style="color:Red; padding:5px 0 5px 0; display:block;"></div>
<div id="InfoMsg" runat="server" style="color:Green; padding:5px 0 5px 0; display:block;"></div>

<% if(!string.IsNullOrEmpty(this.Settings.Help)) { %>
<div class="alert alert-info"><%=this.Settings.Help%></div>
<%} %>

<div class="form-horizontal">
    <asp:PlaceHolder ID="phAddForm" runat="server"></asp:PlaceHolder>
</div>

<div style="margin: 10px 0; padding-bottom: 10px; border-bottom: 1px solid #ccc; display:block">
    <asp:Button CssClass="btn btn-success btn-header" runat="server" ID="btnAdd" ValidationGroup="new" /> 
</div>

<asp:GridView ID="grid"  
        runat="server"
        class="beTable"
        GridLines="None"
        AutoGenerateColumns="False"
        HeaderStyle-BackColor="#f9f9f9"
        AlternatingRowStyle-BackColor="#f7f7f7"
        CellPadding="3" 
        HeaderStyle-HorizontalAlign="Left"
        BorderStyle="Ridge"
        BorderWidth="1"
        Width="100%"
        AllowPaging="True" 
        AllowSorting="True"
        onpageindexchanging="GridPageIndexChanging" 
        OnRowDataBound="GridRowDataBound" >
 </asp:GridView>
