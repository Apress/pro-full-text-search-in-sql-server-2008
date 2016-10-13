using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Irony.Compiler;
using System.Data.SqlClient;
using System.Data;

namespace Apress.Examples
{
    public class SearchGrammar : Grammar
    {
        public SearchGrammar()
        {
            // Terminals
            var Term = new IdentifierTerminal("Term", "!@#$%^*_'.?", "!@#$%^*_'.?0123456789");
            // The following is not very imporant, but makes scanner recognize "or" and "and" as operators, not Terms
            // The "or" and "and" operator symbols found in grammar get higher priority in scanning and are checked
            // first, before the Term terminal, so Scanner produces operator token, not Term. For our purposes it does
            // not matter, we get around without it. 
            var Phrase = new StringLiteral("Phrase");

            // NonTerminals
            var OrExpression = new NonTerminal("OrExpression");
            var OrOperator = new NonTerminal("OrOperator");
            var AndExpression = new NonTerminal("AndExpression");
            var AndOperator = new NonTerminal("AndOperator");
            var ExcludeOperator = new NonTerminal("ExcludeOperator");
            var PrimaryExpression = new NonTerminal("PrimaryExpression");
            var ThesaurusExpression = new NonTerminal("ThesaurusExpression");
            var ThesaurusOperator = new NonTerminal("ThesaurusOperator");
            var ExactOperator = new NonTerminal("ExactOperator");
            var ExactExpression = new NonTerminal("ExactExpression");
            var ParenthesizedExpression = new NonTerminal("ParenthesizedExpression");
            var ProximityExpression = new NonTerminal("ProximityExpression");
            var ProximityList = new NonTerminal("ProximityList");

            this.Root = OrExpression;
            OrExpression.Rule = AndExpression 
                              | OrExpression + OrOperator + AndExpression;
            OrOperator.Rule = Symbol("or") | "|";
            AndExpression.Rule = PrimaryExpression 
                               | AndExpression + AndOperator + PrimaryExpression;
            AndOperator.Rule = Empty 
                             | "and" 
                             | "&" 
                             | ExcludeOperator;
            ExcludeOperator.Rule = Symbol("-");
            PrimaryExpression.Rule = Term 
                                   | ThesaurusExpression 
                                   | ExactExpression 
                                   | ParenthesizedExpression 
                                   | Phrase 
                                   | ProximityExpression;
            ThesaurusExpression.Rule = ThesaurusOperator + Term;
            ThesaurusOperator.Rule = Symbol("~");
            ExactExpression.Rule = ExactOperator + Term 
                                 | ExactOperator + Phrase;
            ExactOperator.Rule = Symbol("+");
            ParenthesizedExpression.Rule = "(" + OrExpression + ")";
            ProximityExpression.Rule = "<" + ProximityList + ">";
            MakePlusRule(ProximityList, Term);

            RegisterPunctuation("<", ">", "(", ")");

        }

        private static string connectionString = "DATA SOURCE=SQL2008;INITIAL CATALOG=iFTS_Books;INTEGRATED SECURITY=SSPI;";

        public static DataTable ExecuteQuery(string ftsQuery)
        {
            SqlDataAdapter da = null;
            DataTable dt = null;
            try
            {
                dt = new DataTable();
                da = new SqlDataAdapter
                    (
                        "SELECT ct.[RANK] AS Rank, " +
                        "   t.Title, " +
                        "   b.Book_ID " +
                        "FROM CONTAINSTABLE " +
                        "( " +
                        "   dbo.Book, " +
                        "   *, " +
                        "   @ftsQuery " +
                        ") AS ct " +
                        "INNER JOIN dbo.Book b " +
                        "   ON ct.[KEY] = b.[Book_ID] " +
                        "INNER JOIN dbo.Book_Title bt " +
                        "   ON b.Book_ID = bt.Book_ID " +
                        "INNER JOIN dbo.Title t " +
                        "   ON bt.Title_ID = t.Title_ID " +
                        "WHERE t.Is_Primary_Title = 1 " +
                        "   AND ct.[RANK] > 0 " +
                        ";",
                        connectionString
                    );
                da.SelectCommand.Parameters.Add("@ftsQuery", SqlDbType.NVarChar, 4000).Value = ftsQuery;
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                if (da != null)
                    da.Dispose();
                if (dt != null)
                    dt.Dispose();
                throw (ex);
            }
            return dt;
        }

        public enum TermType
        {
            Inflectional = 1,
            Thesaurus = 2,
            Exact = 3
        }

        public static string ConvertQuery(AstNode node, TermType type)
        {
            string result = "";
            // Note that some NonTerminals don't actually get into the AST tree, 
            // because of some Irony's optimizations - punctuation stripping and 
            // node bubbling. For example, ParenthesizedExpression - parentheses 
            // symbols get stripped off as punctuation, and child expression node 
            // (parenthesized content) replaces the parent ParExpr node (the 
            // child is "bubbled up").
            switch (node.Term.Name)
            {
                case "OrExpression":
                    result = "(" + ConvertQuery(node.ChildNodes[0], type) + " OR " + 
                        ConvertQuery(node.ChildNodes[2], type) + ")";
                    break;

                case "AndExpression":
                    AstNode tmp2 = node.ChildNodes[1];
                    string opName = tmp2.Term.Name;
                    string andop = "";

                    if (opName == "-")
                    {
                        andop += " AND NOT ";
                    }
                    else
                    {
                        andop = " AND ";
                        type = TermType.Inflectional;
                    }
                    result = "(" + ConvertQuery(node.ChildNodes[0], type) + andop + 
                        ConvertQuery(node.ChildNodes[2], type) + ")";
                    type = TermType.Inflectional;
                    break;

                case "PrimaryExpression":
                    result = "(" + ConvertQuery(node.ChildNodes[0], type) + ")";
                    break;

                case "ProximityList":
                    string[] tmp = new string[node.ChildNodes.Count];
                    type = TermType.Exact;
                    for (int i = 0; i < node.ChildNodes.Count; i++)
                    {
                        tmp[i] = ConvertQuery(node.ChildNodes[i], type);
                    }
                    result = "(" + string.Join(" NEAR ", tmp) + ")";
                    type = TermType.Inflectional;
                    break;

                case "Phrase":
                    result = '"' + ((Token)node).ValueString + '"';
                    break;

                case "ThesaurusExpression":
                    result = " FORMSOF (THESAURUS, " + 
                        ((Token)node.ChildNodes[1]).ValueString + ") ";
                    break;

                case "ExactExpression":
                    result = " \"" + ((Token)node.ChildNodes[1]).ValueString + "\" ";
                    break;

                case "Term":
                    switch (type)
                    {
                        case TermType.Inflectional:
                            result = ((Token)node).ValueString;
                            if (result.EndsWith("*"))
                                result = "\"" + result + "\"";
                            else
                                result = " FORMSOF (INFLECTIONAL, " +  result + ") ";
                            break;
                        case TermType.Exact:
                            result = ((Token)node).ValueString;

                            break;
                    }
                    break;
                
                // This should never happen, even if input string is garbage
                default: 
                    throw new ApplicationException("Converter failed: unexpected term: " + 
                        node.Term.Name + ". Please investigate.");

            }
            return result;
        }

    }

}
