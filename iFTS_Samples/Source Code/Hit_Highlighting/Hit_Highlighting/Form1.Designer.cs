namespace Apress.Examples
{
    partial class HitHighlightForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ResultsPanel = new System.Windows.Forms.Panel();
            this.ResultWebBrowser = new System.Windows.Forms.WebBrowser();
            this.SearchPanel = new System.Windows.Forms.Panel();
            this.SearchButton = new System.Windows.Forms.Button();
            this.SearchText = new System.Windows.Forms.TextBox();
            this.ResultsPanel.SuspendLayout();
            this.SearchPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // ResultsPanel
            // 
            this.ResultsPanel.AutoSize = true;
            this.ResultsPanel.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.ResultsPanel.Controls.Add(this.ResultWebBrowser);
            this.ResultsPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ResultsPanel.Location = new System.Drawing.Point(0, 70);
            this.ResultsPanel.Name = "ResultsPanel";
            this.ResultsPanel.Size = new System.Drawing.Size(570, 448);
            this.ResultsPanel.TabIndex = 0;
            // 
            // ResultWebBrowser
            // 
            this.ResultWebBrowser.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ResultWebBrowser.Location = new System.Drawing.Point(0, 0);
            this.ResultWebBrowser.MinimumSize = new System.Drawing.Size(20, 20);
            this.ResultWebBrowser.Name = "ResultWebBrowser";
            this.ResultWebBrowser.Size = new System.Drawing.Size(566, 444);
            this.ResultWebBrowser.TabIndex = 0;
            // 
            // SearchPanel
            // 
            this.SearchPanel.Controls.Add(this.SearchButton);
            this.SearchPanel.Controls.Add(this.SearchText);
            this.SearchPanel.Dock = System.Windows.Forms.DockStyle.Top;
            this.SearchPanel.Location = new System.Drawing.Point(0, 0);
            this.SearchPanel.Name = "SearchPanel";
            this.SearchPanel.Size = new System.Drawing.Size(570, 70);
            this.SearchPanel.TabIndex = 1;
            // 
            // SearchButton
            // 
            this.SearchButton.Location = new System.Drawing.Point(483, 39);
            this.SearchButton.Name = "SearchButton";
            this.SearchButton.Size = new System.Drawing.Size(75, 23);
            this.SearchButton.TabIndex = 1;
            this.SearchButton.Text = "Search";
            this.SearchButton.UseVisualStyleBackColor = true;
            this.SearchButton.Click += new System.EventHandler(this.SearchButton_Click);
            // 
            // SearchText
            // 
            this.SearchText.Location = new System.Drawing.Point(13, 13);
            this.SearchText.Name = "SearchText";
            this.SearchText.Size = new System.Drawing.Size(545, 20);
            this.SearchText.TabIndex = 0;
            // 
            // HitHighlightForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(570, 518);
            this.Controls.Add(this.ResultsPanel);
            this.Controls.Add(this.SearchPanel);
            this.Name = "HitHighlightForm";
            this.Text = "Hit Highlight Example";
            this.ResultsPanel.ResumeLayout(false);
            this.SearchPanel.ResumeLayout(false);
            this.SearchPanel.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel ResultsPanel;
        private System.Windows.Forms.WebBrowser ResultWebBrowser;
        private System.Windows.Forms.Panel SearchPanel;
        private System.Windows.Forms.TextBox SearchText;
        private System.Windows.Forms.Button SearchButton;
    }
}

