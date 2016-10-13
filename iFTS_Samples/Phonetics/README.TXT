Pro Full-Text Search In SQL Server 2008
Michael Coles With Hilary Cotter
==========================================

To install the Phonetics samples go to the command line and change to this directory. Then execute the setup.bat batch file using one of the following syntaxes:

If your SQL server instance uses Windows integrated security, use this syntax:

  setup.bat server_name

Or, for named instances:

  setup.bat "server_name\instance_name"

If your SQL server instance uses SQL Server security, us this syntax:

  setup.bat server_name user_name password

Or, for named instances:

  setup.bat "server_name\instance_name" user_name password

The SQL scripts create new tables, bulk loads data into them, creates a SQL CLR assembly, and SQL CLR functions.  You will need administrator rights on the SQL Server instance specified.