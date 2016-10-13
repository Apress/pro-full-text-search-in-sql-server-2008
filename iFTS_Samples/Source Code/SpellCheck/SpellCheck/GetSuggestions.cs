using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Collections;

namespace Apress.Examples
{
    public partial class SpellCheck
    {
        private readonly static Tst.TstDictionary Dictionary = new Tst.TstDictionary();

        [Microsoft.SqlServer.Server.SqlProcedure]
        public static void GetSuggestions(SqlString key, SqlInt32 distance)
        {
            if (key.IsNull || distance.IsNull)
                return;
            if (Dictionary.Count == 0)
                ReloadDictionary();
            ICollection a = new ArrayList();
            a = Dictionary.NearNeighbors(key.Value, distance.Value);
            SqlDataRecord dr = new SqlDataRecord
            (
                new SqlMetaData("Suggestion", SqlDbType.NVarChar, 512),
                new SqlMetaData("Distance", SqlDbType.Int)
            );
            SqlContext.Pipe.SendResultsStart(dr);
            foreach (DictionaryEntry de in a)
            {
                dr.SetValue(0, de.Key);
                dr.SetValue(1, de.Value);
                SqlContext.Pipe.SendResultsRow(dr);
            }
            SqlContext.Pipe.SendResultsEnd();
        }

        [Microsoft.SqlServer.Server.SqlProcedure]
        public static void GetMatch(SqlString key)
        {
            if (key.IsNull)
                return;
            if (Dictionary.Count == 0)
                ReloadDictionary();
            ICollection a = new ArrayList();
            a = Dictionary.PartialMatch(key.Value);
            SqlDataRecord dr = new SqlDataRecord
            (
                new SqlMetaData("Match", SqlDbType.NVarChar, 512)
            );
            SqlContext.Pipe.SendResultsStart(dr);
            foreach (DictionaryEntry de in a)
            {
                dr.SetValue(0, de.Key);
                SqlContext.Pipe.SendResultsRow(dr);
            }
            SqlContext.Pipe.SendResultsEnd();
        }

        [Microsoft.SqlServer.Server.SqlProcedure]
        public static void ReloadDictionary()
        {
            Dictionary.Clear();
            SqlConnection con = new SqlConnection("Context Connection = true;");
            con.Open();
            SqlCommand cmd = new SqlCommand("SELECT Keyword FROM Dictionary;", con);
            cmd.CommandType = CommandType.Text;
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                SqlString s = dr.GetSqlString(0);
                Dictionary.Add(s.Value, s.Value);
            }
            dr.Dispose();
            cmd.Dispose();
            con.Dispose();
        }

        [Microsoft.SqlServer.Server.SqlProcedure]
        public static void GetDictionary()
        {
            SqlDataRecord dr = new SqlDataRecord
            (
                new SqlMetaData("Word", SqlDbType.NVarChar, 512)
            );
            SqlContext.Pipe.SendResultsStart(dr);
            foreach (DictionaryEntry de in Dictionary)
            {
                dr.SetValue(0, de.Key);
                SqlContext.Pipe.SendResultsRow(dr);
            }
            SqlContext.Pipe.SendResultsEnd();
        }
    };
}