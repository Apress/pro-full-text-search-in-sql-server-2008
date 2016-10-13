using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Data;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

namespace Apress.Examples
{
    public partial class Phonetics
    {
        // nGram structure
        private struct NGramStruct
        {
            // The Id number and nGram string
            private SqlInt32 _Id;
            private SqlString _NGram;

            public SqlInt32 Id
            {
                get { return _Id; }
            }

            public SqlString NGram
            {
                get { return _NGram; }
            }

            // Requires a constructor
            public NGramStruct(SqlInt32 Id, SqlString NGram)
            {
                this._Id = Id;
                this._NGram = NGram;
            }
        }

        // The IEnumerable user-defined function breaks a string down to its 
        // component n-grams
        [Microsoft.SqlServer.Server.SqlFunction(Name = "GetNGrams",
            FillRowMethodName = "NGramFill",
            DataAccess = DataAccessKind.None,
            TableDefinition = "Id INT, nGram NVARCHAR(8)")]
        public static IEnumerable GetNGrams(SqlInt32 length, SqlString string1)
        {
            ArrayList NGrams = new ArrayList();
            if (string1 == SqlString.Null
                || length == SqlInt32.Null
                || length.Value < 2
                || length.Value > 8)
                NGrams.Add(new NGramStruct(1, SqlString.Null));
            else
            {
                string tempstr = "$$$$$$$$".Substring(0, length.Value - 1) + string1.Value + "$$$$$$$$".Substring(0, length.Value - 1);
                for (int i = 0; i < tempstr.Length - (length - 1); i++)
                    NGrams.Add(new NGramStruct(i, new SqlString(tempstr.Substring(i, length.Value))));
            }
            return NGrams;
        }

        // The fill method for the user-defined function
        private static void NGramFill(Object obj, out SqlInt32 Id, out SqlString NGram)
        {
            NGramStruct ngs = (NGramStruct)obj;
            Id = ngs.Id;
            NGram = ngs.NGram;
        }
    }
}
