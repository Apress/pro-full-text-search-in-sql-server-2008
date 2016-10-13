using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.IO;
using System.Runtime.Remoting.Messaging;
using System.Windows.Forms;

namespace Apress.Examples
{
    public partial class searchForm : Form
    {
        #region "Private variables"

        // This is the managed SqlFileStream object
        private SqlFileStream sqlFileStream = null;

        // This is the BinaryWriter that the data will be written to
        private BinaryWriter binaryWriter = null;

        // The destination file name (local file system)
        private string destinationFileName = "";

        // The SQL Server connection string
        private string connectionString = "SERVER=SQL2008;INITIAL CATALOG=iFTS_Books;INTEGRATED SECURITY=SSPI;";

        // This flag indicates whether we are in the middle of a FILESTREAM data retrieval operation
        private bool retrieving = false;

        // The SQL client connectivity variables, used to establish a connection, execute a T-SQL
        // command, and iterate the results
        private SqlConnection sqlConnection = null;
        private SqlCommand sqlCommand = null;
        private SqlDataReader sqlDataReader = null;

        #endregion "Private variables"

        #region "Constructor and initialization"
        // Default constructor is fine
        public searchForm()
        {
            InitializeComponent();
        }

        // On the Load event, perform some start-up functions
        private void searchForm_Load(object sender, EventArgs e)
        {
            // On initial load reset progress bar information
            ResetProgress();
        }
        #endregion "Constructor and initialization"

        #region "Perform search"

        // This procedure performs the actual search when you press the search button
        private void searchButton_Click
        (
            object sender, 
            EventArgs e
        )
        {
            try
            {
                // Start by creating and opening a connection to the SQL Server database
                sqlConnection = new SqlConnection
                (
                    connectionString
                );

                sqlConnection.Open();

                // Next create a command that will perform the T-SQL full-text search
                sqlCommand = new SqlCommand
                (
                    "SELECT " +
                    "  b.Book_ID, " +
                    "  t.Title, " +
                    "  b.Book_Content.PathName() AS FilePath, " +
                    "  b.Book_File_Ext " +
                    "FROM dbo.Book b " +
                    "INNER JOIN dbo.Book_Title bt " +
                    "  ON b.Book_ID = bt.Book_ID " +
                    "INNER JOIN dbo.Title t " +
                    "  ON bt.Title_ID = t.Title_ID " +
                    "WHERE FREETEXT(Book_Content, @SearchString) " +
                    "  AND t.Is_Primary_Title = 1;",
                    sqlConnection
                );

                // Add the search string as a parameter to the SQL command
                SqlParameter parameter = sqlCommand.Parameters.Add("@SearchString", SqlDbType.NVarChar, 512);
                parameter.Value = searchStringTextBox.Text;

                // Clear the results gridview
                resultsGridView.Rows.Clear();

                // Execute the SQL command and retrieve the results as a rowset
                sqlDataReader = sqlCommand.ExecuteReader();

                // Iterate over the results
                while (sqlDataReader.Read())
                {
                    // Add the results to the gridview, one row at a time
                    resultsGridView.Rows.Add
                    (
                        new Object[] 
                            {
                                sqlDataReader[0].ToString(), 
                                sqlDataReader[1].ToString(), 
                                sqlDataReader[2].ToString(),
                                sqlDataReader[3].ToString()
                            }
                    );
                }
            }
            catch (Exception ex)
            {
                // An error occurred, so show a message box
                ShowError(ex.Message);
            }
            finally
            {
                // Finally, error or not, clean up
                if (sqlDataReader != null)
                    sqlDataReader.Dispose();
                if (sqlCommand != null)
                    sqlCommand.Dispose();
                if (sqlConnection != null)
                    sqlConnection.Dispose();
            }
        }

        #endregion "Perform search"

        #region "Download data"

        // This method retrieves a file with the OpenSqlFileStream API
        private void GetFile
        (
            string filePath, 
            string fileType
        )
        {
            // Don't allow clicking on other links until we finish retrieving the current file
            retrieving = true;
            // First check if the Files subdirectory exists under the current directory (bin\Debug).
            // Create it if it doesn't exist.
            if (!Directory.Exists("Files"))
                Directory.CreateDirectory("Files");

            try
            {
                // Always check InvokeRequired before updating the UI in case this is being called 
                // from a non-UI thread
                if (!this.InvokeRequired)
                    EnableDisableSearchButton(false);
                else
                    this.Invoke(new EnableDisableSearchButtonDelegate(EnableDisableSearchButton), new object[] {false});

                // Create and open a new SQL connection. This is required because the FILESTREAM 
                // requires a SQL Server transaction context, so we need to create a transaction,
                // which means we need an open connection
                sqlConnection = new SqlConnection
                (
                    connectionString
                );
                sqlConnection.Open();
                
                // Create a SQL Server transaction context over the connection
                SqlTransaction sqlTransaction = sqlConnection.BeginTransaction("fileStreamTx");
                
                // Use the T-SQL GET_FILESTREAM_TRANSACTION_CONTEXT() function to get the transaction
                // context identifier from SQL Server. The transaction context is returned as a binary
                // value, which maps to the .NET byte array.
                sqlCommand = new SqlCommand
                (
                    "SELECT GET_FILESTREAM_TRANSACTION_CONTEXT();",
                    sqlConnection,
                    sqlTransaction
                );
                byte[] transactionContext = (byte[])sqlCommand.ExecuteScalar();

                // Here we use the managed SqlFileStream wrapper to create a 
                sqlFileStream = new SqlFileStream
                (
                    filePath,
                    transactionContext,
                    FileAccess.Read
                );

                // A 4KB buffer to hold the SqlFileStream data as it's retrieved
                byte [] buffer = new byte[4096];
                
                // Progress status variables
                int percentDone = 0;                // Percent of data retrieved
                long fileLength = sqlFileStream.Length;        // Length of data to retrieve
                long totalBytesRead = 0;            // Total bytes retrieved
                int bytesBuffered = 0;              // Bytes buffered currently
                string shortFileName = filePath.Substring
                (
                    filePath.LastIndexOf("\\") + 1
                ) + fileType;                       // Short version of file name (no path)
                destinationFileName = "Files\\" + 
                    shortFileName;                  // File name with destination path

                // Write the data back out to the local file system in a BinaryWriter
                // as it's retrieved
                binaryWriter = new BinaryWriter
                (
                    File.Open(destinationFileName, FileMode.Create)     // Create/overwrite existing file of same name
                );

                // Keep going until the total bytes received is equal to the total bytes expected
                while (totalBytesRead != fileLength)
                {
                    // Buffer 4 KB of data at a time, and write to output file as soon as data is received
                    bytesBuffered = sqlFileStream.Read(buffer, 0, 4096); 
                    binaryWriter.Write(buffer, 0, bytesBuffered);

                    // Adjust counters and update display
                    totalBytesRead += bytesBuffered;
                    percentDone = (int)((totalBytesRead * 100) / fileLength);

                    // Only update the display if the % done has changed
                    if (fileReadProgress.Value != percentDone)
                    {
                        double mb_Read = Math.Round((double)totalBytesRead / 1048576.0, 2);     // Divide # of bytes read to get megabytes
                        double mb_FileLength = Math.Round((double)fileLength / 1048576.0, 2);   // Divide # of bytes expected to get megabytes
                        // Invoke screen update in case we are on a non-UI thread
                        if (this.InvokeRequired)
                            this.Invoke
                            (
                                new UpdateProgressDelegate(UpdateProgress), 
                                new object[] 
                                {
                                    mb_Read, 
                                    mb_FileLength, 
                                    percentDone
                                }
                            );
                        else
                            UpdateProgress(mb_Read, mb_FileLength, percentDone);
                    }
                }
            }
            catch (System.Exception ex)
            {
                if (this.InvokeRequired)
                    this.Invoke(new ShowErrorDelegate(ShowError), new object[] { ex.Message });
                else
                    ShowError(ex.Message);
            }
            return;
        }

        // This is a delegate for calling the GetFile method asynchronously
        private delegate void GetFileDelegate
        (
            string filePath, 
            string fileType
        );

        // This is the Callback method for the GetFileDelegate asynchronous delegate
        private void Callback
        (
            IAsyncResult iar
        )
        {
            // Cast the AsyncDelegate property of the AsyncResult to a delegate
            GetFileDelegate gfd = (GetFileDelegate)((AsyncResult)iar).AsyncDelegate;

            // Call to EndInvoke - simplified since it's a delegate for a void method
            gfd.EndInvoke(iar);

            // Do all the cleanup
            if (binaryWriter != null)
                binaryWriter.Close();
            if (sqlFileStream != null)
                sqlFileStream.Dispose();
            if (sqlCommand != null)
            {
                if (sqlCommand.Transaction != null)
                    sqlCommand.Transaction.Commit();
                sqlCommand.Dispose();
            }
            if (sqlCommand != null)
                sqlCommand.Dispose();
            if (sqlConnection != null)
                sqlConnection.Dispose();
            // Enable the search button (Invoke since this is on a non-UI thread)
            if (!this.InvokeRequired)
                EnableDisableSearchButton(true);
            else
                this.Invoke
                (
                    new EnableDisableSearchButtonDelegate(EnableDisableSearchButton), 
                    new object[] 
                    {
                        true
                    }
                );
            // We are no longer retrieving a file; let user click on other links
            retrieving = false;
            // Opens the file on the local file system
            OpenFile(destinationFileName);
        }

        // This is a utility method that simply updates the progress status bar and label
        private void UpdateProgress
        (
            double mb_Read, 
            double mb_FileLength, 
            int percentDone 
        )
        {
            // Update the label
            bytesReadLabel.Text = string.Format 
            (
                "{0} MB / {1} MB ({2}%)",
                mb_Read,
                mb_FileLength,
                percentDone
            );

            // Update the progress bar
            fileReadProgress.Value = percentDone;

            // Refresh both
            fileReadProgress.Refresh();
            bytesReadLabel.Refresh();
        }

        // This delegate is for updating the progress status bar from a non-UI thread
        private delegate void UpdateProgressDelegate
        (
            double mb_Read, 
            double mb_FileLength, 
            int percentDone
        );

        // This method simply enables or disables the Search button
        private void EnableDisableSearchButton
        (
            bool flag
        )
        {
            searchButton.Enabled = flag;
        }

        // This delegate is for changing the Search button enabled flag from a non-UI thread
        private delegate void EnableDisableSearchButtonDelegate
        (
            bool Flag
        );

        // This method simply resets the progress status bar
        private void ResetProgress()
        {
            fileReadProgress.Value = 0;
            bytesReadLabel.Text = "";
        }

        // Show an exception in a message box
        private void ShowError
        (
            string message
        )
        {
            MessageBox.Show(this, message);
        }

        // Delegate for showing error messages from a non-UI thread
        private delegate void ShowErrorDelegate
        (
            string message
        );

        // Capture the click event on the gridview
        private void resultsGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // We're only interested in capturing clicks in the hyperlink "Title" column.
            // Do not allow clicking on other links if we are currently retrieving a file.
            if (e.ColumnIndex == 1 && !retrieving)
            {
                // Grab the row that was clicked on
                DataGridViewRow row = (((DataGridView)sender).Rows[e.RowIndex]);

                // Reset the progress bars
                ResetProgress();

                // Start an asynchronous delegate to retrieve the file
                GetFileDelegate del = new GetFileDelegate(GetFile); 
                del.BeginInvoke(row.Cells[2].Value.ToString(), row.Cells[3].Value.ToString(), new AsyncCallback(Callback), null);
            }
        }

        #endregion "Download data"

        #region "Open file locally"

        // This method simply starts a new process that opens the file on the local
        // computer
        private void OpenFile
        (
            string destinationFileName
        )
        {
            // Create a new process
            Process p = new Process();
            // Set the file name to start
            p.StartInfo.FileName = destinationFileName;
            // Open the file in its associated application
            p.Start();
        }

        #endregion "Open file locally"
 

    }
}
