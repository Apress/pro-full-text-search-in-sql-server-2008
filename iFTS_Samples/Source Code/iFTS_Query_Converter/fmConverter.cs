using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Irony.Compiler;


namespace Apress.Examples
{
    public partial class fmConverter : Form
    {
        public fmConverter()
        {
            InitializeComponent();
        }

        SearchGrammar _grammar;
        LanguageCompiler _compiler;

        private void fmConverter_Load(object sender, EventArgs e)
        {
            _grammar = new SearchGrammar();
            _compiler = new LanguageCompiler(_grammar);
            Irony.StringSet errors = _compiler.Parser.GetErrors();
            if (errors.Count > 0)
            {
                FtsQueryTextBox.Text = "SearchGrammar contains errors. Investigate using GrammarExplorer.\r\n" + errors.ToString();
            }
        }

        private void btnConvert_Click(object sender, EventArgs e)
        {
            try
            {
                AstNode root = _compiler.Parse(SourceQueryText.Text.ToLower());
                if (!CheckParseErrors()) return;
                FtsQueryTextBox.Text = SearchGrammar.ConvertQuery(root, SearchGrammar.TermType.Inflectional);
                DataTable dt = SearchGrammar.ExecuteQuery(FtsQueryTextBox.Text);
                ResultsDataGridView.DataSource = dt;

            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
                FtsQueryTextBox.Text = "Error: " + ex.Message;
            }
        }

        private bool CheckParseErrors()
        {
            if (_compiler.Context.Errors.Count == 0) return true;
            string errs = "Errors: \r\n";
            foreach (SyntaxError err in _compiler.Context.Errors)
                errs += err.ToString() + "\r\n";
            FtsQueryTextBox.Text = errs;
            return false;
        }

    }
}