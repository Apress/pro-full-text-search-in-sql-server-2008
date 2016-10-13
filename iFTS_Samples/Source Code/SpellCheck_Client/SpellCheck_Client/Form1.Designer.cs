namespace SpellCheck_Client
{
    partial class Form1
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
            this.ExitButton = new System.Windows.Forms.Button();
            this.WordTextBox = new System.Windows.Forms.TextBox();
            this.SuggestionListBox = new System.Windows.Forms.ListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.SensitivityUpDown = new System.Windows.Forms.NumericUpDown();
            this.label2 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.SensitivityUpDown)).BeginInit();
            this.SuspendLayout();
            // 
            // ExitButton
            // 
            this.ExitButton.Location = new System.Drawing.Point(258, 313);
            this.ExitButton.Name = "ExitButton";
            this.ExitButton.Size = new System.Drawing.Size(75, 23);
            this.ExitButton.TabIndex = 0;
            this.ExitButton.Text = "Exit";
            this.ExitButton.UseVisualStyleBackColor = true;
            this.ExitButton.Click += new System.EventHandler(this.ExitButton_Click);
            // 
            // WordTextBox
            // 
            this.WordTextBox.Location = new System.Drawing.Point(91, 13);
            this.WordTextBox.Name = "WordTextBox";
            this.WordTextBox.Size = new System.Drawing.Size(242, 20);
            this.WordTextBox.TabIndex = 1;
            this.WordTextBox.TextChanged += new System.EventHandler(this.WordTextBox_TextChanged);
            // 
            // SuggestionListBox
            // 
            this.SuggestionListBox.FormattingEnabled = true;
            this.SuggestionListBox.Location = new System.Drawing.Point(12, 69);
            this.SuggestionListBox.Name = "SuggestionListBox";
            this.SuggestionListBox.Size = new System.Drawing.Size(321, 238);
            this.SuggestionListBox.TabIndex = 2;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(73, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Enter a Word:";
            // 
            // SensitivityUpDown
            // 
            this.SensitivityUpDown.Location = new System.Drawing.Point(91, 43);
            this.SensitivityUpDown.Maximum = new decimal(new int[] {
            5,
            0,
            0,
            0});
            this.SensitivityUpDown.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.SensitivityUpDown.Name = "SensitivityUpDown";
            this.SensitivityUpDown.Size = new System.Drawing.Size(75, 20);
            this.SensitivityUpDown.TabIndex = 4;
            this.SensitivityUpDown.Value = new decimal(new int[] {
            2,
            0,
            0,
            0});
            this.SensitivityUpDown.ValueChanged += new System.EventHandler(this.SensitivityUpDown_ValueChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(15, 45);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(57, 13);
            this.label2.TabIndex = 5;
            this.label2.Text = "Sensitivity:";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(345, 345);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.SensitivityUpDown);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.SuggestionListBox);
            this.Controls.Add(this.WordTextBox);
            this.Controls.Add(this.ExitButton);
            this.Name = "Form1";
            this.Text = "Word Suggestion";
            ((System.ComponentModel.ISupportInitialize)(this.SensitivityUpDown)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button ExitButton;
        private System.Windows.Forms.TextBox WordTextBox;
        private System.Windows.Forms.ListBox SuggestionListBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.NumericUpDown SensitivityUpDown;
        private System.Windows.Forms.Label label2;
    }
}

