using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.IO;
using System.Text;
using System.Xml.Xsl;

namespace XMLReis.Pages
{
    public class IndexModel : PageModel
    {
        public string TransformedXml { get; private set; }

        private readonly IWebHostEnvironment _hostingEnvironment;

        public IndexModel(IWebHostEnvironment hostingEnvironment)
        {
            _hostingEnvironment = hostingEnvironment;
        }

        public void OnGet()
        {
            try
            {
                var xmlPath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "XMLFile1.xml");
                var xsltPath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "XSLTFile1.xslt");

                if (!System.IO.File.Exists(xmlPath) || !System.IO.File.Exists(xsltPath))
                {
                    TransformedXml = "<p class='text-danger'>Error: XML or XSLT file not found.</p>";
                    return;
                }

                var xslt = new XslCompiledTransform();
                xslt.Load(xsltPath);

                using (var sw = new StringWriter())
                {
                    xslt.Transform(xmlPath, null, sw);
                    TransformedXml = sw.ToString();
                }
            }
            catch (Exception ex)
            {
                TransformedXml = $"<p class='text-danger'>An error occurred during XML transformation: {ex.Message}</p>";
            }
        }
    }
}