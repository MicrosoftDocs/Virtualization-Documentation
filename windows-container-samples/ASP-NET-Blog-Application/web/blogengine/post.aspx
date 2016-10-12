<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="False" Inherits="post" Codebehind="post.aspx.cs" %>
<%@ Register Src="Custom/Controls/CommentList.ascx" TagName="CommentList" TagPrefix="uc" %>
<%@ Import Namespace="BlogEngine.Core"%>
<asp:content id="Content1" contentplaceholderid="cphBody" runat="Server">
  
  <asp:PlaceHolder ID="phCommentNotificationUnsubscription" runat="server" visible="false">
    <div id="commentNotificationUnsubscription">
        <h1><%= Resources.labels.commentNotificationUnsubscriptionHeader %></h1>
        <div><%= Resources.labels.commentNotificationUnsubscriptionText %></div>
    </div>
  </asp:PlaceHolder>

  <asp:placeholder runat="server" id="phPostNavigation" visible="false" />
 
  <asp:placeholder runat="server" id="pwPost" />

  <asp:placeholder runat="server" id="phRelatedPosts" />
  
  <asp:placeholder runat="server" id="phRDF">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
      <rdf:Description rdf:about="<%=Post.AbsoluteLink %>" dc:identifier="<%=Post.AbsoluteLink %>" dc:title="<%=Post.Title %>" trackback:ping="<%=Post.TrackbackLink %>" />
    </rdf:RDF>
  </asp:placeholder>
  
  <blog:RelatedPosts runat="server" ID="related" MaxResults="3" ShowDescription="true" DescriptionMaxLength="100" Visible="false" />
  
  <uc:CommentList ID="ucCommentList" runat="server" />

    <% if (ShowDisqusComments){ %>
    <div id="comment" class="comment-form well-global">
      <div id="disqus_thread" class="form-horizontal"></div>
    </div>
    <script type="text/javascript">
        var disqus_url = '<%= Post.PermaLink %>';
        var disqus_developer = '<%= BlogSettings.Instance.DisqusDevMode ? 1 : 0 %>';
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '<%=Request.Url.Scheme %>://<%= BlogSettings.Instance.DisqusWebsiteName %>.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <%} %>

    <% if (ShowFacebookComments) { %>
    <div id="comment" class="comment-form well-global">
        <div class="form-horizontal">
            <div class="fb-comments" data-href="<%=Post.PermaLink %>" data-version="v2.4" data-width="100%"></div>
        </div>
    </div> 
    <div id="fb-root"></div>
    <script>(function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/<%=BlogSettings.Instance.FacebookLanguage%>/sdk.js#xfbml=1&version=v2.4";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));</script>    
    <%} %>

</asp:content>