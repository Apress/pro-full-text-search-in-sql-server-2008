using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

// LCS (Longest Common Subsequence) function algorithm

namespace Apress.Examples
{
    public partial class Phonetics
    {
        // This function returns the LCS for two strings
        [Microsoft.SqlServer.Server.SqlFunction]
        public static SqlString LCS(SqlString string1, SqlString string2)
        {
            // Put your code here
            return CalculateLCS(string1, string2);
        }

        // This calculates the LCS Score by dividing the LCS length by the maximum
        // length of the two strings
        [Microsoft.SqlServer.Server.SqlFunction]
        [return: Microsoft.SqlServer.Server.SqlFacet(Precision = 5, Scale = 4)]
        public static SqlDecimal ScoreLCS(SqlString string1, SqlString string2)
        {
            SqlDecimal result;
            // Special case:  If either is NULL, the result is NULL

            if (string1 == SqlString.Null || string2 == SqlString.Null)
                result = SqlDecimal.Null;
            else if (string1.Value.Length == 0 || string2.Value.Length == 0) // Special case:  If either is length 0, the result is 0.0
                result = new SqlDecimal(0.0);
            else
            {
                // Otherwise we calculate the LCS, and divide the length of the result
                // by the length of the longer string passed in
                SqlString s3 = CalculateLCS(string1, string2);
                result = new SqlDecimal((Decimal)s3.Value.Length / Math.Max(string1.Value.Length, string2.Value.Length));
            }
            return result;
        }

        // Directions for backtracking through the matrix
        private enum Direction
        {
            None,
            North,
            West,
            Northwest
        }

        // This struct holds a matrix that contains the count and direction 
        // for backtracking

        private struct MatrixStruct
        {
            public Direction dir;
            public int val;
        }

        // This routine calculates the LCS

        private static SqlString CalculateLCS(SqlString string1, SqlString string2)
        {
            SqlString result;

            // Special handling, if s1 or s2 is NULL, return NULL

            if (string1 == SqlString.Null || string2 == SqlString.Null)
                result = SqlString.Null;
            else
            {
                // Special case: s1 or s2 is empty string, return other string

                int strlen1 = string1.Value.Length;
                int strlen2 = string2.Value.Length;
                if (strlen1 == 0)
                    result = new SqlString(string2.Value);
                else if (string2.Value.Length == 0)
                    result = new SqlString(string1.Value);
                else
                {
                    // Normal case, let's calculate it

                    MatrixStruct[,] matrix = new MatrixStruct[strlen1 + 1, strlen2 + 1];

                    // Initialize the top row and left-most column to zeroes

                    for (int i = 0; i <= strlen1; i++)
                        matrix[i, 0].val = 0;
                    for (int i = 0; i <= strlen2; i++)
                        matrix[0, i].val = 0;

                    // Loop through and calculate the LCS using dynamic programming

                    for (int i = 1; i <= strlen1; i++)
                    {
                        for (int j = 1; j <= strlen2; j++)
                        {
                            if (char.ToUpper(string1.Value[i - 1]) == char.ToUpper(string2.Value[j - 1]))
                            {
                                matrix[i, j].dir = Direction.Northwest;
                                matrix[i, j].val = matrix[i - 1, j - 1].val + 1;
                            }
                            else if (matrix[i - 1, j].val >= matrix[i, j - 1].val)
                            {
                                matrix[i, j].val = matrix[i - 1, j].val;
                                matrix[i, j].dir = Direction.North;
                            }
                            else
                            {
                                matrix[i, j].val = matrix[i, j - 1].val;
                                matrix[i, j].dir = Direction.West;
                            }
                        }
                    }

                    // Get the length of the result -- it is in the last cell of the matrix

                    int len = matrix[strlen1, strlen2].val;
                    char[] common = new char[len];

                    // Loop until we run out of characters

                    while (len > 0)
                    {

                        // Place the characters in the char array backwards

                        if (matrix[strlen1, strlen2].dir == Direction.Northwest)
                        {
                            common[--len] = string1.Value[strlen1 - 1];
                            strlen1--;
                            strlen2--;
                        }
                        else if (matrix[strlen1, strlen2].dir == Direction.North)
                            strlen1--;
                        else if (matrix[strlen1, strlen2].dir == Direction.West)
                            strlen2--;
                    }
                    result = new SqlString(new string(common));
                }
            }

            // Return the result as a SqlString

            return result;
        }
    }
}