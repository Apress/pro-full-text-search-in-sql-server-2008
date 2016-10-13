using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace SpellCheck_Client
{
    public partial class Form1 : Form
    {
        private string con_str = "SERVER=SQL2008;INITIAL CATALOG=iFTS_Books;INTEGRATED SECURITY=SSPI;";

        public Form1()
        {
            InitializeComponent();
        }

        private void ExitButton_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void ClearSuggestions()
        {
            SuggestionListBox.Items.Clear();
        }

        private void GetSuggestions(string word)
        {
            ClearSuggestions();
            SqlDataAdapter da = new SqlDataAdapter("dbo.GetSuggestions", con_str);
            da.SelectCommand.CommandType = CommandType.StoredProcedure;
            da.SelectCommand.Parameters.Add("@key", SqlDbType.NVarChar, 4000).Value = word;
            da.SelectCommand.Parameters.Add("@distance", SqlDbType.Int).Value = (int)SensitivityUpDown.Value;
            DataSet ds = new DataSet();
            da.Fill(ds);
            DataView dv = new DataView(ds.Tables[0]);
            dv.Sort = "Distance ASC, Suggestion ASC";
            foreach (DataRowView dr in dv)
            {
                SuggestionListBox.Items.Add(string.Format("{0} ({1})", (string)dr[0], (int)dr[1]) ); 
            }
            dv.Dispose();
            ds.Dispose();
            da.Dispose();
        }

        private void WordTextBox_TextChanged(object sender, EventArgs e)
        {
            TextBox t = (TextBox)sender;
            if (t.Text.Length > 1)
                GetSuggestions(t.Text);
            else
                ClearSuggestions();
        }

        private void SensitivityUpDown_ValueChanged(object sender, EventArgs e)
        {
            if (WordTextBox.Text.Length > 1)
                GetSuggestions(WordTextBox.Text);
            else
                ClearSuggestions();
        }

    }
}
