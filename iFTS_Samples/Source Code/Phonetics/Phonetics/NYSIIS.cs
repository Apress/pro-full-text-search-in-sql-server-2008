using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Collections;
using System.Text;

namespace Apress.Examples
{
    public partial class Phonetics
    {

        // The BeginsWith() private function is a simple function to determine if a
        // StringBuilder object begins with a specified string

        private static bool BeginsWith(StringBuilder string1, string string2)
        {
            // We start off assuming it's a match

            bool result = true;

            // If the StringBuilder is shorter than the string, we know it's not a
            // match

            if (string1.Length < string2.Length)
            {
                result = false;
            }
            else
            {
                // We loop through each character of the string comparing.  If one 
                // doesn't match, we know it's not a match

                for (int i = 0; i <= string2.Length - 1 && result; i++)
                {
                    if (string1[i] != string2[i])
                    {
                        result = false;
                    }
                }
            }
            return result;
        }

        // The EndsWith() private function is a simple function to determine if a
        // StringBuilder object ends with a specified string

        private static bool EndsWith(StringBuilder string1, String string2)
        {
            // We start off assuming it's a match

            bool result = true;

            // If the StringBuilder obejct is shorter than the string, we know its
            // not a match

            if (string1.Length < string2.Length)
            {
                result = false;
            }
            else
            {
                // We loop through each character of the string comparing.  If one 
                // doesn't match, we know it's not a match

                for (int i = string2.Length - 1; i >= 0 && result; i--)
                {
                    if (string1[string1.Length + (i - string2.Length)] != string2[i])
                    {
                        result = false;
                    }
                }
            }
            return result;
        }


        // The Encode() public method encodes a string as NYSIIS

        private static string Encode(string string1)
        {
            // Uppercase and remove all extraneous (non-alphabetic) characters

            string1 = string1.ToUpper();

            // Our Encoded Name StringBuilder; populate it with only good alphabetic
            // uppercase characters in the Name string

            StringBuilder encoding = new StringBuilder(32);
            for (int i = 0; i <= string1.Length - 1; i++)
            {
                char c = char.ToUpper(string1[i]);
                if (char.IsLetter(c))
                {
                    encoding.Append(c);
                }
            }

            if (encoding.Length > 0)
            {
                // These are the prefixes and the strings to replace them with

                string[] prefixes = { "MAC", "SCH", "PH", "KN", "PF", "K" };
                string[] prefix_replace = { "MCC", "SSS", "FF", "NN", "FF", "C" };

                // We loop through the prefixes and check if our name begins with one
                // If we find a match, we replace the prefix with the appropriate
                // replacement characters

                int i = 0;
                while (i < prefixes.Length)
                {
                    if (BeginsWith(encoding, prefixes[i]))
                    {
                        for (int j = 0; j <= prefixes[i].Length - 1; j++)
                        {
                            encoding[j] = prefix_replace[i][j];
                        }
                        i = prefixes.Length + 1;
                    }
                    i++;
                }

                // Suffixes to check for and characters to replace them with

                string[] suffixes = { "EE", "IE", "DT", "RT", "RD", "NT", "ND" };
                string[] suffix_replace = { "Y ", "Y ", "D ", "D ", "D ", "D ", "D " };

                // Loop through our suffixes and see if our name ends with one
                // If it does, we repace the suffix with the replacement characters
                i = 0;
                while (i < suffixes.Length)
                {
                    if (EndsWith(encoding, suffixes[i]))
                    {
                        for (int j = suffixes[i].Length - 1; j >= 0; j--)
                        {
                            encoding[encoding.Length + (j - suffixes[i].Length)] = suffix_replace[i][j];
                        }
                        i += suffixes.Length + 1;
                    }
                    i++;
                }

                // Loop through the characters and encode them as appropriate

                i = 1;
                while (i < encoding.Length)
                {
                    // Grab the current character

                    char current_char = encoding[i];

                    // Grab the next character.  If we're at the end, we set it to $

                    char next_char;
                    if (i < encoding.Length - 1)
                    {
                        next_char = encoding[i + 1];
                    }
                    else
                    {
                        next_char = '$';
                    };

                    switch (current_char)
                    {
                        case 'E':
                            // "EV" ==> "AF"
                            if (next_char == 'V')
                            {
                                encoding[i] = 'A';
                                encoding[i + 1] = 'F';
                                i += 2;
                            }
                            else
                            {
                                // "E" ==> "A"
                                encoding[i] = 'A';
                                i++;
                            };
                            break;
                        case 'A':
                        case 'I':
                        case 'O':
                        case 'U':
                            encoding[i] = 'A';
                            i++;
                            break;
                        case 'Q':
                            // "Q" ==> "G"
                            encoding[i] = 'G';
                            i++;
                            break;
                        case 'Z':
                            // "Z" ==> "S"
                            encoding[i] = 'S';
                            i++;
                            break;
                        case 'M':
                            // "M" ==> "N"
                            encoding[i] = 'N';
                            i++;
                            break;
                        case 'K':
                            // "KN" ==> "NN"
                            if (next_char == 'N')
                            {
                                encoding[i] = 'N';
                                i += 2;
                            }
                            else
                            {
                                // "K" ==> "C"
                                encoding[i] = 'C';
                                i++;
                            };
                            break;
                        case 'S':
                            // Grab the next, next character.  If we're within the
                            // last two characters, we return a "$"
                            char next_next_char = '$';
                            if (i < encoding.Length - 2)
                            {
                                next_next_char = encoding[i + 2];
                            }
                            // "SCH" ==> "SSS"
                            if (next_char == 'C' && next_next_char == 'H')
                            {
                                encoding[i + 1] = 'S';
                                encoding[i + 2] = 'S';
                                i += 3;
                            }
                            else
                            {
                                // "S" ==> "S"
                                encoding[i] = 'S';
                                i++;
                            };
                            break;
                        case 'P':
                            // "PH" ==> "FF"
                            if (next_char == 'H')
                            {
                                encoding[i] = 'F';
                                encoding[i + 1] = 'F';
                                i += 2;
                            }
                            else
                            {
                                // "P" ==> "P"
                                encoding[i] = 'P';
                                i++;
                            };
                            break;
                        case 'H':
                            // Get last character
                            char last_char = encoding[i - 1];
                            // if "H" is preceded or followed by vowel, previous (vowel)
                            if ("AEIOU".IndexOf(last_char) > -1 || "AEIOU".IndexOf(next_char) > -1)
                            {
                                // If previous is a vowel, then set to "A" (vowel)
                                if ("AEIOU".IndexOf(last_char) > -1)
                                {
                                    encoding[i] = 'A';
                                }
                                else
                                {
                                    // otherwise we set it to exact previous character
                                    encoding[i] = last_char;
                                }
                                i++;
                            }
                            else
                            {
                                // "H" ==> "H"
                                i++;
                            }
                            break;
                        case 'W':
                            // Get last character
                            last_char = encoding[i - 1];
                            // If last character is a vowel, then previous (vowel = "A")
                            if ("AEIOU".IndexOf(last_char) > -1)
                            {
                                encoding[i] = 'A';
                                i++;
                            }
                            else
                            {
                                // otherwise "W" ==> "W"
                                encoding[i] = 'W';
                                i++;
                            }
                            break;
                        default:
                            // Any other case, current = current
                            i++;
                            break;
                    }
                }
            }

            // Grab the first character to the result

            StringBuilder result = new StringBuilder(32);
            if (encoding.Length > 0)
            {
                result.Append(encoding[0]);
            }

            // Eliminate double-letters

            for (int j = 1; j < encoding.Length && result.Length <= 6; j++)
            {
                char Last_Char = encoding[j - 1];
                char Current_Char = encoding[j];
                if (Current_Char != Last_Char)
                {
                    result.Append(Current_Char);
                }
            }

            // If encoded name ends with "S" (and length > 1) drop the "S"

            if (result.Length > 1 && result[result.Length - 1] == 'S')
            {
                result.Remove(result.Length - 1, 1);
            }

            // If encoded name ends with "AY" (and length > 1) turn it into "Y"

            if (result.Length > 2 && result[result.Length - 2] == 'A' && result[result.Length - 1] == 'Y')
            {
                result.Remove(result.Length - 1, 1);
                result[result.Length - 1] = 'Y';
            }

            // If encoded name ends with "A" (and length > 1) drop it

            if (result.Length > 1 && result[result.Length - 1] == 'A')
            {
                result.Remove(result.Length - 1, 1);
            }

            // Append six spaces to the end of result

            result.Append(' ', 6);

            // Return the first six characters of the result

            return result.ToString().Substring(0, 6);
        }

        [Microsoft.SqlServer.Server.SqlFunction]
        public static SqlString NYSIIS(SqlString string1)
        {
            // Return NULL on NULL input

            if (string1.IsNull)
                return SqlString.Null;
            return new SqlString(Encode(string1.Value));
        }
    }
}