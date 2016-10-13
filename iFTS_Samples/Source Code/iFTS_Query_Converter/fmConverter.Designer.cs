namespace Apress.Examples
{
  partial class fmConverter {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing) {
      if (disposing && (components != null)) {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent() {
        this.SourceQueryText = new System.Windows.Forms.TextBox();
        this.label1 = new System.Windows.Forms.Label();
        this.label2 = new System.Windows.Forms.Label();
        this.ConvertButton = new System.Windows.Forms.Button();
        this.ResultsDataGridView = new System.Windows.Forms.DataGridView();
        this.label3 = new System.Windows.Forms.Label();
        this.FtsQueryTextBox = new System.Windows.Forms.TextBox();
        ((System.ComponentModel.ISupportInitialize)(this.ResultsDataGridView)).BeginInit();
        this.SuspendLayout();
        // 
        // SourceQueryText
        // 
        this.SourceQueryText.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
        this.SourceQueryText.Location = new System.Drawing.Point(8, 31);
        this.SourceQueryText.Multiline = true;
        this.SourceQueryText.Name = "SourceQueryText";
        this.SourceQueryText.Size = new System.Drawing.Size(967, 23);
        this.SourceQueryText.TabIndex = 0;
        this.SourceQueryText.Text = "\"Fish and chips\" -(<this is a test> or money)";
        // 
        // label1
        // 
        this.label1.AutoSize = true;
        this.label1.Location = new System.Drawing.Point(5, 15);
        this.label1.Name = "label1";
        this.label1.Size = new System.Drawing.Size(35, 13);
        this.label1.TabIndex = 2;
        this.label1.Text = "Query";
        // 
        // label2
        // 
        this.label2.AutoSize = true;
        this.label2.Location = new System.Drawing.Point(5, 387);
        this.label2.Name = "label2";
        this.label2.Size = new System.Drawing.Size(58, 13);
        this.label2.TabIndex = 3;
        this.label2.Text = "FTS Query";
        // 
        // ConvertButton
        // 
        this.ConvertButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
        this.ConvertButton.Location = new System.Drawing.Point(981, 31);
        this.ConvertButton.Name = "ConvertButton";
        this.ConvertButton.Size = new System.Drawing.Size(75, 23);
        this.ConvertButton.TabIndex = 4;
        this.ConvertButton.Text = "Convert";
        this.ConvertButton.UseVisualStyleBackColor = true;
        this.ConvertButton.Click += new System.EventHandler(this.btnConvert_Click);
        // 
        // ResultsDataGridView
        // 
        this.ResultsDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
        this.ResultsDataGridView.Location = new System.Drawing.Point(8, 76);
        this.ResultsDataGridView.Name = "ResultsDataGridView";
        this.ResultsDataGridView.Size = new System.Drawing.Size(1048, 308);
        this.ResultsDataGridView.TabIndex = 5;
        // 
        // label3
        // 
        this.label3.AutoSize = true;
        this.label3.Location = new System.Drawing.Point(5, 57);
        this.label3.Name = "label3";
        this.label3.Size = new System.Drawing.Size(42, 13);
        this.label3.TabIndex = 6;
        this.label3.Text = "Results";
        // 
        // FtsQueryTextBox
        // 
        this.FtsQueryTextBox.Location = new System.Drawing.Point(8, 403);
        this.FtsQueryTextBox.Multiline = true;
        this.FtsQueryTextBox.Name = "FtsQueryTextBox";
        this.FtsQueryTextBox.ReadOnly = true;
        this.FtsQueryTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
        this.FtsQueryTextBox.Size = new System.Drawing.Size(1044, 62);
        this.FtsQueryTextBox.TabIndex = 7;
        // 
        // fmConverter
        // 
        this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
        this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
        this.ClientSize = new System.Drawing.Size(1062, 477);
        this.Controls.Add(this.FtsQueryTextBox);
        this.Controls.Add(this.label3);
        this.Controls.Add(this.ResultsDataGridView);
        this.Controls.Add(this.ConvertButton);
        this.Controls.Add(this.label2);
        this.Controls.Add(this.label1);
        this.Controls.Add(this.SourceQueryText);
        this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
        this.MaximizeBox = false;
        this.MinimizeBox = false;
        this.Name = "fmConverter";
        this.Text = "Search Query Converter";
        this.Load += new System.EventHandler(this.fmConverter_Load);
        ((System.ComponentModel.ISupportInitialize)(this.ResultsDataGridView)).EndInit();
        this.ResumeLayout(false);
        this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.TextBox SourceQueryText;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.Label label2;
    private System.Windows.Forms.Button ConvertButton;
    private System.Windows.Forms.DataGridView ResultsDataGridView;
    private System.Windows.Forms.Label label3;
    private System.Windows.Forms.TextBox FtsQueryTextBox;
  }
}

