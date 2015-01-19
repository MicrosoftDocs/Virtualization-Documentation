## Pandoc for converting files to markdown ##

Download Pandoc here: [https://github.com/jgm/pandoc/releases](https://github.com/jgm/pandoc/releases)
Full documentation: [C:\Users\cynthn\AppData\Local\Pandoc\Pandoc User's Guide.html](C:\Users\cynthn\AppData\Local\Pandoc\Pandoc User's Guide.html)

To convert a .docx file called **containers.docx** to a .md file with the same name, type: 

    pandoc -f docx -t markdown containers.docx -o containers.md

The switches are:

    -f = from
    -t = to
    -o = output

