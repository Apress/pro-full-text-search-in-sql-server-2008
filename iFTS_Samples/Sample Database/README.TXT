Pro Full-Text Search In SQL Server 2008
Michael Coles With Hilary Cotter
==========================================

To install the iFTS_Books Sample Database go to the command line and change to this directory. Then execute the setup.bat batch file using one of the following syntaxes:

If your SQL server instance uses Windows integrated security, use this syntax:

  setup.bat server_name

Or, for named instances:

  setup.bat "server_name\instance_name"

If your SQL server instance uses SQL Server security, us this syntax:

  setup.bat server_name user_name password

Or, for named instances:

  setup.bat "server_name\instance_name" user_name password

Because the SQL scripts create a new database and bulk load data into it, you will need administrator rights on the SQL Server instance specified.

The setup.bat file creates a directory named IFTS_Books in the root directory of your C: drive.  Database files are placed in this directory, including filestream files.  If this directory already exists it will not be created.