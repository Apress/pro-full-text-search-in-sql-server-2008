using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

// Damerau-Levenshtein Edit Distance

namespace Apress.Examples
{
    public partial class Phonetics
    {
        // The Damerau-Levenshtein edit distance function exposed to the database
        [Microsoft.SqlServer.Server.SqlFunction]
        public static SqlInt32 DamLev(SqlString string1, SqlString string2)
        {
            return CalculateDamLev(string1, string2);
        }

        // This function is also exposed to the database.  It accepts two names,
        // performs a Damerau-Levenshtein edit distance calculation on them and
        // calculates a similarity score
        [Microsoft.SqlServer.Server.SqlFunction]
        [return: Microsoft.SqlServer.Server.SqlFacet(Precision = 5, Scale = 4)]
        public static SqlDecimal ScoreDamLev(SqlString string1, SqlString string2)
        {
            SqlDecimal result;
            // Special case:  Either string is NULL, result is NULL
            if (string1 == SqlString.Null || string2 == SqlString.Null)
                result = SqlDecimal.Null;
            else
            {
                // Special case:  Either string is empty string, result is 0.0
                int strlen1 = string1.Value.Length;
                int strlen2 = string2.Value.Length;
                if (strlen1 == 0 || strlen2 == 0)
                    return new SqlDecimal(0.0);
                SqlInt32 distance = CalculateDamLev(string1, string2);
                result = new SqlDecimal(1.0 - (double)distance / Math.Max(strlen1, strlen2));
            }
            return result;
        }

        // Accepts 3 numbers, returns the minimum
        private static int Min3(int a, int b, int c)
        {
            return Math.Min(a, Math.Min(b, c));
        }

        // This private function calculates the Damerau-Levenshtein edit distance
        private static SqlInt32 CalculateDamLev(SqlString string1, SqlString string2)
        {
            SqlInt32 result;
            // Special case:  If either string is NULL, the result is NULL
            if (string1 == SqlString.Null || string2 == SqlString.Null)
                result = SqlInt32.Null;
            {
                // Special case:  If either string is length 0, the result is the
                // length of the other string
                int strlen1 = string1.Value.Length;
                int strlen2 = string2.Value.Length;
                if (strlen1 == 0 || strlen2 == 0)
                    result = new SqlInt32(Math.Max(strlen1, strlen2));
                else
                {
                    // d is a table with lenStr1+1 rows and lenStr2+1 columns
                    int[,] calarray = new int[strlen1 + 1, strlen2 + 1];

                    // initialize the array
                    for (int i = 0; i < strlen1; i++)
                        calarray[i, 0] = i;
                    for (int i = 0; i < strlen2; i++)
                        calarray[0, i] = i;

                    // loop through the array
                    for (int i = 1; i <= strlen1; i++)
                        for (int j = 1; j <= strlen2; j++)
                        {
                            int cost = 0;
                            cost = (char.ToUpper(string1.Value[i - 1]) == char.ToUpper(string2.Value[j - 1])) ? 0 : 1;
                            calarray[i, j] = Min3(
                                    calarray[i - 1, j] + 1,     // deletion
                                    calarray[i, j - 1] + 1,     // insertion
                                    calarray[i - 1, j - 1] + cost   // substitution
                                );
                            if (i > 1
                                && j > 1
                                && char.ToUpper(string1.Value[i - 1]) == char.ToUpper(string2.Value[j - 2])
                                && char.ToUpper(string1.Value[i - 2]) == char.ToUpper(string2.Value[j - 1]))
                                calarray[i, j] = Math.Min(
                                        calarray[i, j],
                                        calarray[i - 2, j - 2] + cost   // transposition
                                     );
                        }
                    result = new SqlInt32(calarray[strlen1, strlen2]);
                }
            }
            return result;
        }
    }
}

