<%@ Page Language="C#" AutoEventWireup="true" Inherits="error_occurred" Codebehind="error.aspx.cs" %>

<asp:content id="Content1" contentplaceholderid="cphBody" runat="Server">
  <div class="post page-global">
    <h2 class="page-global-title"><%=BlogEngine.Core.BlogSettings.Instance.ErrorTitle %></h2>
        <%=BlogEngine.Core.BlogSettings.Instance.ErrorText %>
        <div id="divErrorDetails" runat="server" visible="false">
        <h2>Error Details:</h2>
        <p id="pDetails" runat="server"></p>
    </div>
    
  </div>
</asp:content>
