<%@ WebService Language="C#" Class="Updater" %>
using System;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Hosting;
using System.Web;
using System.IO;
using ICSharpCode.SharpZipLib.Core;
using ICSharpCode.SharpZipLib.Zip;
using System.Collections.Specialized;
using System.Net;
using BlogEngine.Core;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class Updater  : WebService {

    private StringCollection _ignoreDirs;
    private List<InstalledLog> _installed;
    private string _root;
    private string _newZip;
    private string _oldZip;
    private static string _upgradeReleases = BlogConfig.GalleryFeedUrl.Replace("nuget", "/Releases/");
    //private static string _upgradeReleases = "http://dnbe.net/v01/Releases/";
    private string _downloadUrl = _upgradeReleases + "{0}.zip";
    private string _versionsTxt = _upgradeReleases + "versions.txt";
    private bool _test = false;    // when set to "true" will run in test mode without actually updating site
    private int _tries;

    public Updater()
    {
        _root = HostingEnvironment.MapPath("~/");
        if (_root.EndsWith("\\")) _root = _root.Substring(0, _root.Length - 1);

        _newZip = _root + "\\setup\\upgrade\\backup\\new.zip";
        _oldZip = _root + "\\setup\\upgrade\\backup\\old.zip";

        _ignoreDirs = new StringCollection();
        _ignoreDirs.Add(_root + "\\Custom");
        _ignoreDirs.Add(_root + "\\setup\\upgrade");

        _installed = new List<InstalledLog>();
    }

    [WebMethod]
    public string Check(string version)
    {
        try
        {
            WebClient client = new WebClient();
            Stream stream = client.OpenRead(_versionsTxt);
            StreamReader reader = new StreamReader(stream);
            string line = "";

            while (reader.Peek() >= 0)
            {
                line = reader.ReadLine();
                if (!string.IsNullOrEmpty(version) && line.Contains("|"))
                {
                    var iCurrent = int.Parse(version.Replace(".", ""));
                    var iFrom = int.Parse(line.Substring(0, line.IndexOf("|")).Replace(".", ""));
                    var iTo = int.Parse(line.Substring(line.LastIndexOf("|") + 1).Replace(".", ""));

                    if (iCurrent >= iFrom  && iCurrent < iTo)
                    {
                        return line.Substring(line.LastIndexOf("|") + 1);
                    }
                }
            }
            return "";
        }
        catch (Exception)
        {
            return "";
        }
    }

    [WebMethod]
    public string Download(string version)
    {
        if (_test)
        {
            System.Threading.Thread.Sleep(2000);
            return "";
        }
        try
        {
            if (!Directory.Exists(_root + "\\setup\\upgrade\\backup"))
                Directory.CreateDirectory(_root + "\\setup\\upgrade\\backup");

            if (File.Exists(_newZip))
                File.Delete(_newZip);

            var startTime = DateTime.UtcNow;
            var request = WebRequest.Create(string.Format(_downloadUrl, version.Replace(".", "")));
            var response = request.GetResponse();
            using (Stream responseStream = response.GetResponseStream())
            {
                using (Stream fileStream = File.OpenWrite(_newZip))
                {
                    byte[] buffer = new byte[4096];
                    int bytesRead = responseStream.Read(buffer, 0, 4096);
                    while (bytesRead > 0)
                    {
                        fileStream.Write(buffer, 0, bytesRead);
                        DateTime nowTime = DateTime.UtcNow;
                        if ((nowTime - startTime).TotalMinutes > 5)
                        {
                            throw new ApplicationException(
                                "Download timed out");
                        }
                        bytesRead = responseStream.Read(buffer, 0, 4096);
                    }
                }
            }
            Utils.Log(string.Format("Upgrade: downloaded version {0} by {1}", version, Security.CurrentUser.Identity.Name));
            return "";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    [WebMethod]
    public string Extract()
    {
        if (_test)
        {
            System.Threading.Thread.Sleep(2000);
            return "";
        }

        ZipFile zf = null;
        string outFolder = _root + "\\setup\\upgrade\\backup\\be";
        try
        {
            if (!Directory.Exists(outFolder))
                Directory.CreateDirectory(outFolder);

            FileStream fs = File.OpenRead(_newZip);
            zf = new ZipFile(fs);

            foreach (ZipEntry zipEntry in zf)
            {
                if (!zipEntry.IsFile)
                {
                    continue;
                }
                String entryFileName = zipEntry.Name;

                byte[] buffer = new byte[4096];
                Stream zipStream = zf.GetInputStream(zipEntry);

                String fullZipToPath = Path.Combine(outFolder, entryFileName);
                string directoryName = Path.GetDirectoryName(fullZipToPath);
                if (directoryName.Length > 0)
                    Directory.CreateDirectory(directoryName);

                using (FileStream streamWriter = File.Create(fullZipToPath))
                {
                    StreamUtils.Copy(zipStream, streamWriter, buffer);
                }
            }
            return "";
        }
        catch(Exception ex)
        {
            return ex.Message;
        }
        finally
        {
            if (zf != null)
            {
                zf.IsStreamOwner = true;
                zf.Close();
            }
        }
    }

    [WebMethod]
    public string Backup()
    {
        if (_test)
        {
            System.Threading.Thread.Sleep(2000);
            return "";
        }

        try
        {
            var backupDir = HostingEnvironment.MapPath("~/setup/upgrade/backup");
            var blogDir = HostingEnvironment.MapPath("~/");

            if (!Directory.Exists(backupDir))
                Directory.CreateDirectory(backupDir);

            if (File.Exists(_oldZip))
                File.Delete(_oldZip);

            var fsOut = File.Create(_oldZip);
            var zipStream = new ZipOutputStream(fsOut);

            zipStream.SetLevel(3);
            int folderOffset = blogDir.Length + (blogDir.EndsWith("\\") ? 0 : 1);

            CompressFolder(blogDir, zipStream, folderOffset);

            zipStream.IsStreamOwner = true;
            zipStream.Close();

            return "";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    [WebMethod]
    public string Delete()
    {
        if (_test)
        {
            System.Threading.Thread.Sleep(2000);
            return "";
        }
        try
        {
            DeleteDir("\\api");
            DeleteDir("\\editors");
            DeleteDir("\\Modules");
            DeleteDir("\\pics");
            DeleteDir("\\App_Data\\datastore\\widgets");

            ReplaceDir("\\Account");
            ReplaceDir("\\admin");
            ReplaceDir("\\fonts");

            ReplaceDir("\\setup\\Mono");
            ReplaceDir("\\setup\\MySQL");
            ReplaceDir("\\setup\\SQL_CE");
            ReplaceDir("\\setup\\SQLite");
            ReplaceDir("\\setup\\SQLServer");

            ReplaceDir("\\App_GlobalResources");
            ReplaceDir("\\Scripts");
            ReplaceDir("\\Content");
            ReplaceDir("\\Custom\\Themes\\Standard");
            ReplaceDir("\\Custom\\Widgets");
            
            return "";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    [WebMethod]
    public string Install()
    {
        if (_test)
        {
            CopyWebConfig();

            System.Threading.Thread.Sleep(2000);
            return "";
        }
        try
        {
            ReplaceFile("archive.aspx");
            ReplaceFile("contact.aspx");
            ReplaceFile("default.aspx");
            ReplaceFile("error.aspx");
            ReplaceFile("error404.aspx");
            ReplaceFile("page.aspx");
            ReplaceFile("post.aspx");
            ReplaceFile("search.aspx");
            ReplaceFile("web.sitemap");
            ReplaceFile("wlwmanifest.xml");

            ReplaceFilesInDir("bin");

            ReplaceLabelsFile();

            CopyWebConfig();

            ReplaceFile("Global.asax");

            FixSH();

            // add few new custom controls
            string from = "{0}\\setup\\upgrade\\backup\\be\\Custom\\Controls\\{1}";
            string to = "{0}\\Custom\\Controls\\{1}";
            CopyFile(string.Format(from, _root, "CommentList.ascx"), string.Format(to, _root, "CommentList.ascx"));
            CopyFile(string.Format(from, _root, "PostList.ascx"), string.Format(to, _root, "PostList.ascx"));
            CopyFile(string.Format(from, _root, "Defaults\\CommentView.ascx"), string.Format(to, _root, "Defaults\\CommentView.ascx"));
            CopyFile(string.Format(from, _root, "Defaults\\PostView.ascx"), string.Format(to, _root, "Defaults\\PostView.ascx"));

            Directory.Delete(_root + "\\setup\\upgrade\\backup", true);
            Utils.Log(string.Format("Upgrade completed by {0}", Security.CurrentUser.Identity.Name));

            return "";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    public void CopyWebConfig()
    {
        string webConfig = _root + "\\web.config";
        StreamReader reader = new StreamReader(webConfig);
        string content = reader.ReadToEnd();
        reader.Close();

        if (content.Contains("defaultProvider=\"DbBlogProvider"))
        {
            ReplaceDbConfig(content);
        }
        else
        {
            ReplaceXMLConfig(content);
        }
    }

    void ReplaceLabelsFile()
    {
        string sourceFile = _root + "\\setup\\upgrade\\backup\\be\\App_Data\\labels.txt";
        string targetFile = _root + "\\App_Data\\labels.txt";

        if (File.Exists(sourceFile) && File.Exists(targetFile))
        {
            File.Delete(targetFile);
            File.Copy(sourceFile, targetFile);
        }
    }

    void ReplaceXMLConfig(string content)
    {
        string targetFile = _root + "\\Web.config";
        DeleteFile(targetFile);

        content = UpdateWebConfig(content);

        var writer = new StreamWriter(targetFile);
        writer.Write(content);
        writer.Close();
    }

    void ReplaceDbConfig(string content)
    {
        string oldCon = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["BlogEngine"].ConnectionString;
        string conPrv = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["BlogEngine"].ProviderName;
        string sourceFile = _root + "\\setup\\upgrade\\backup\\be\\web.config";
        string defCon = "";

        if (conPrv.StartsWith("System.Data.SqlServerCe"))
        {
            sourceFile = _root + "\\setup\\upgrade\\backup\\be\\setup\\SQL_CE\\SQL_CE_Web.Config";
            defCon = @"Data Source=|DataDirectory|BlogEngine.sdf;";
        }
        else if (conPrv.StartsWith("MySql.Data.MySqlClient"))
        {
            sourceFile = _root + "\\setup\\upgrade\\backup\\be\\setup\\MySQL\\MySQLWeb.Config";
            defCon = @"Server=localhost;Database=blogengine;Uid=beUser;Pwd=password;";
        }
        else if (conPrv.StartsWith("System.Data.SQLite"))
        {
            sourceFile = _root + "\\setup\\upgrade\\backup\\be\\setup\\SQLite\\SQLiteWeb.Config";
            defCon = @"Data Source=|DataDirectory|\BlogEngine.s3db;Version=3;BinaryGUID=False;";
        }
        else if (conPrv == "System.Data.SqlClient")
        {
            sourceFile = _root + "\\setup\\upgrade\\backup\\be\\setup\\SQLServer\\DbWeb.Config";
            defCon = @"Server=.\SQLEXPRESS;Database=BlogEngine;Trusted_Connection=True;";
        }

        string targetFile = _root + "\\Web.config";

        DeleteFile(targetFile);
        CopyFile(sourceFile, targetFile);

        // replace connection string
        StreamReader reader = new StreamReader(targetFile);
        string webContent = reader.ReadToEnd();
        reader.Close();

        webContent = webContent.Replace(defCon, oldCon);
        webContent = UpdateWebConfig(webContent);

        StreamWriter writer = new StreamWriter(targetFile);
        writer.Write(webContent);
        writer.Close();
    }

    string UpdateWebConfig(string content)
    {
        var defaultValidationKey = "D9F7287EFDE8DF4CAFF79011D5308643D8F62AE10CDF30DAB640B7399BF6C57B0269D60A23FBCCC736FC2487ED695512BA95044DE4C58DC02C2BA0C4A266454C";
        var defaultDecryptionKey = "BDAAF7E00B69BA47B37EEAC328929A06A6647D4C89FED3A7D5C52B12B23680F4";

        string validationKey = CreateKey(Convert.ToInt32(64));
        string decryptionKey = CreateKey(Convert.ToInt32(24));

        content = content.Replace(defaultValidationKey, validationKey);
        content = content.Replace(defaultDecryptionKey, decryptionKey);

        // replace old editor path in web.config
        content = content.Replace("~/editors", "~/admin/editors");

        // replace runtime tag in web.config
        var newWebConfig = _root + "\\setup\\upgrade\\backup\\be\\Web.Config";
        try
        {
            StreamReader reader = new StreamReader(newWebConfig);
            string newContent = reader.ReadToEnd();
            reader.Close();

            var oldRuntimeTag = content.Substring(content.IndexOf("<runtime>"), (content.IndexOf  ("</runtime>") - content.IndexOf("<runtime>") + 11));
            var newRuntimeTag = newContent.Substring(newContent.IndexOf("<runtime>"), (newContent.IndexOf  ("</runtime>") - newContent.IndexOf("<runtime>") + 11));

            if(oldRuntimeTag.Length > 0 && newRuntimeTag.Length > 0)
            {
                content = content.Replace(oldRuntimeTag, newRuntimeTag);
            }
        }
        catch (Exception)
        {
        }
        return content;
    }

    static String CreateKey(int numBytes)
    {
        var rng = new System.Security.Cryptography.RNGCryptoServiceProvider();
        byte[] buff = new byte[numBytes];

        rng.GetBytes(buff);
        return BytesToHexString(buff);
    }

    static String BytesToHexString(byte[] bytes)
    {
        var hexString = new System.Text.StringBuilder(64);

        for (int counter = 0; counter < bytes.Length; counter++)
        {
            hexString.Append(String.Format("{0:X2}", bytes[counter]));
        }
        return hexString.ToString();
    }

    [WebMethod]
    public string Rollback()
    {
        try
        {
            foreach (var item in _installed)
            {
                if (item.IsDirectory)
                {
                    var source = new DirectoryInfo(item.To);
                    var target = new DirectoryInfo(item.From);

                    //Log(source.FullName, target.FullName, true);
                    CopyRecursive(source, target);
                }
                else
                {
                    File.Copy(item.To, item.From, true);
                }
            }
            return "";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    //----------------------------------------------

    void ReplaceDir(string dir)
    {
        try
        {
            DeleteDir(dir);
            CopyDir(dir);
            _tries = 0;
            Utils.Log(string.Format("Updater: replaced directory {0}", dir));
        }
        catch (Exception ex)
        {
            // wait 2 seconds then repeat
            System.Threading.Thread.Sleep(2000);
            _tries++;

            if (_tries == 3)
            {
                _tries = 0;
                throw new ApplicationException(string.Format("Failed to replace directory {0}; error: {1}", dir, ex.Message));
            }

            if (_tries < 4)
            {
                ReplaceDir(dir);
            }
        }
    }

    void DeleteDir(string dir)
    {
        if (Directory.Exists(_root + dir))
        {
            Directory.Delete(_root + dir, true);
        }
    }

    void CopyDir(string dir)
    {
        var source = new DirectoryInfo(_root + "\\setup\\upgrade\\backup\\be\\" + dir);
        var target = new DirectoryInfo(_root + "\\" + dir);

        //Log(source.FullName, target.FullName, true);
        CopyRecursive(source, target);
    }

    //------------------------------------------------

    void ReplaceFile(string file)
    {
        string sourceFile = _root + "\\setup\\upgrade\\backup\\be\\" + file;
        string targetFile = _root + "\\" + file;

        try
        {
            DeleteFile(targetFile);
        }
        catch (Exception ex)
        {
            Utils.Log(string.Format("Updater: failed to delete file {0}; error: {1}", file, ex.Message));
        }

        if (!File.Exists(targetFile))
        {
            CopyFile(sourceFile, targetFile);
        }
    }

    void DeleteFile(string file)
    {
        if (File.Exists(file))
            File.Delete(file);
    }

    void CopyFile(string from, string to)
    {
        File.Copy(from, to, true);
    }

    void ReplaceFilesInDir(string dir)
    {
        string sourceDir = _root + "\\setup\\upgrade\\backup\\be\\" + dir;
        string[] files = Directory.GetFiles(sourceDir);

        foreach (string sourceFile in files)
        {
            string fileName = sourceFile.Substring(sourceFile.LastIndexOf(@"\") + 1);
            ReplaceFile(dir + "\\" + fileName);
        }
    }

    //---------------------------------------------------

    void CompressFolder(string path, ZipOutputStream zipStream, int folderOffset)
    {
        if (IgnoredDirectory(path))
            return;

        string[] files = Directory.GetFiles(path);

        foreach (string filename in files)
        {
            FileInfo fi = new FileInfo(filename);
            string entryName = filename.Substring(folderOffset);
            entryName = ZipEntry.CleanName(entryName);
            ZipEntry newEntry = new ZipEntry(entryName);
            newEntry.DateTime = fi.LastWriteTime;
            newEntry.Size = fi.Length;
            zipStream.PutNextEntry(newEntry);

            byte[] buffer = new byte[4096];
            using (FileStream streamReader = File.OpenRead(filename))
            {
                StreamUtils.Copy(streamReader, zipStream, buffer);
            }
            zipStream.CloseEntry();
        }
        string[] folders = Directory.GetDirectories(path);
        foreach (string folder in folders)
        {
            CompressFolder(folder, zipStream, folderOffset);
        }
    }

    void ExtractZipFile(string archiveFilenameIn, string outFolder)
    {
        ZipFile zf = null;
        try
        {
            FileStream fs = File.OpenRead(archiveFilenameIn);
            zf = new ZipFile(fs);

            foreach (ZipEntry zipEntry in zf)
            {
                if (!zipEntry.IsFile)
                    continue;

                String entryFileName = zipEntry.Name;

                byte[] buffer = new byte[4096];
                Stream zipStream = zf.GetInputStream(zipEntry);

                String fullZipToPath = Path.Combine(outFolder, entryFileName);
                string directoryName = Path.GetDirectoryName(fullZipToPath);
                if (directoryName.Length > 0)
                    Directory.CreateDirectory(directoryName);

                using (FileStream streamWriter = File.Create(fullZipToPath))
                {
                    StreamUtils.Copy(zipStream, streamWriter, buffer);
                }
            }
        }
        finally
        {
            if (zf != null)
            {
                zf.IsStreamOwner = true;
                zf.Close();
            }
        }
    }

    static void CopyRecursive(DirectoryInfo source, DirectoryInfo target)
    {
        var rootPath = HttpContext.Current.Server.MapPath(BlogEngine.Core.Utils.RelativeWebRoot);

        if (!Directory.Exists(target.FullName))
            Directory.CreateDirectory(target.FullName);

        foreach (var dir in source.GetDirectories())
        {
            var dirPath = Path.Combine(target.FullName, dir.Name);
            var relPath = dirPath.Replace(rootPath, "");

            CopyRecursive(dir, Directory.CreateDirectory(dirPath));
        }

        foreach (var file in source.GetFiles())
        {
            var filePath = Path.Combine(target.FullName, file.Name);

            var relPath = filePath.Replace(rootPath, "");

            file.CopyTo(filePath);
        }
    }

    bool IgnoredDirectory(string item)
    {
        return _ignoreDirs.Contains(item) ? true : false;
    }

    //----------------------------------------------------
    void FixSH()
    {
        var themesPath = HttpContext.Current.Server.MapPath(BlogEngine.Core.Utils.RelativeWebRoot + "Custom/Themes");

        if (!Directory.Exists(themesPath))
            return;

        var themes = new DirectoryInfo(themesPath);

        foreach (var dir in themes.GetDirectories())
        {
            if (dir.Name != "RazorHost")
            {
                System.Diagnostics.Debug.WriteLine(dir.Name);

                foreach (var file in dir.GetFiles())
                {
                    if (file.Name.Contains(".cs") ||
                        file.Name.Contains(".ascx") ||
                        file.Name.Contains(".cshtml") ||
                        file.Name.Contains(".master"))
                    {
                        ReplaceInFile(file.FullName, "editors/tiny_mce_3_5_8/plugins", "Scripts");
                    }
                }
            }
        }
    }
    static void ReplaceInFile(string filePath, string searchText, string replaceText)
    {
        var cnt = 0;
        StreamReader reader = new StreamReader(filePath);
        string content = reader.ReadToEnd();
        cnt = content.Length;
        reader.Close();

        content = System.Text.RegularExpressions.Regex.Replace(content, searchText, replaceText);

        if (cnt > 0 && cnt != content.Length)
        {
            Utils.Log(string.Format("Updater: replacing in {0} from {1} to {2}", filePath, searchText, replaceText));
        }

        StreamWriter writer = new StreamWriter(filePath);
        writer.Write(content);
        writer.Close();
    }
    //----------------------------------------------------

    //void Log(string from, string to = "", bool directory = false, Operation action = Operation.Copy)
    //{
    //    _installed.Add(new InstalledLog { IsDirectory = directory, Action = action, From = from, To = to });

    //    string s = action == Operation.Copy ? "UPGRADE: Copy " : "UPGRADE: Delete ";
    //    s = s + (directory ? "directory " : "file ");

    //    if (action == Operation.Copy)
    //        BlogEngine.Core.Utils.Log(string.Format("{0} from {1} to {2}", s, from, to));
    //    else
    //    BlogEngine.Core.Utils.Log(string.Format("{0} from {1}", s, from));   
    //}
}

public class InstalledLog
{
    public InstalledLog(){}
    public Operation Action { get; set; }
    public bool IsDirectory { get; set; }
    public string From { get; set; }
    public string To { get; set; }
}

public enum Operation
{
    Copy,
    Delete
}