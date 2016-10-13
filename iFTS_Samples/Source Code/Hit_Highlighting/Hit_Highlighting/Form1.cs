using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Apress.Examples
{
    public partial class HitHighlightForm : Form
    {
        public HitHighlightForm()
        {
            InitializeComponent();
        }

        string sqlConString = "SERVER=SQL2008;" +
            "INITIAL CATALOG=iFTS_Books;" +
            "INTEGRATED SECURITY=SSPI;";

        private void SearchButton_Click(object sender, EventArgs e)
        {
            SqlConnection sqlCon = null;
            SqlCommand sqlCmd = null;
            SqlDataReader sqlDr = null;

            try
            {
                sqlCon = new SqlConnection(sqlConString);
                sqlCon.Open();
                sqlCmd = new SqlCommand
                (
                    "dbo.SimpleCommentaryHighlight",
                    sqlCon
                );

                sqlCmd.CommandType = CommandType.StoredProcedure;

                sqlCmd.Parameters.Add
                (
                    "@SearchTerm",
                    SqlDbType.NVarChar,
                    100
                ).Value = SearchText.Text;

                sqlCmd.Parameters.Add
                (
                    "@Style",
                    SqlDbType.NVarChar,
                    200
                ).Value = "background-color:yellow; font-weight:bold;";

                sqlDr = sqlCmd.ExecuteReader();
                string Results = "";
                int RowCount = 0;

                while (sqlDr.Read())
                {
                    RowCount++;
                    if (RowCount % 2 == 1)
                        Results += "<p style='background-color:#ffffff'>";
                    else
                        Results += "<p style='background-color:#C0C0C0'>";
                    Results += "<b>" + sqlDr["Title"].ToString() + "</b><br>";
                    Results += sqlDr["Snippet"].ToString() + "</p>";
                }

                Results = "<html><body>" +
                    String.Format
                    (
                        "<p style='background-color:#FBB917'><b>Total Results Found: {0}</b></p>",
                        RowCount
                    ) +
                    Results +
                    "</body></html>";

                ResultWebBrowser.DocumentText = Results;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                if (sqlDr != null)
                    sqlDr.Dispose();
                if (sqlCmd != null)
                    sqlCmd.Dispose();
                if (sqlCon != null)
                    sqlCon.Dispose();
            }
        }
    }
}
