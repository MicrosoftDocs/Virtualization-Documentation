<%@ Application Language="C#" %>
<%@ Import Namespace="BlogEngine.NET.App_Start" %>

<script RunAt="server">
    void Application_BeginRequest(object sender, EventArgs e)
    {
        var app = (HttpApplication)sender;
        BlogEngineConfig.Initialize(app.Context);
    }
        
    void Application_PreRequestHandlerExecute(object sender, EventArgs e)
    {
        BlogEngineConfig.SetCulture(sender, e);
    }
</script>