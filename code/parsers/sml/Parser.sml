(* TODO: empty productions mess with the position information. Fix that. *)
structure Parser =
struct
structure SMLLrVals = SMLLrValsFun
                        (structure Token = LrParser.Token)
structure SMLLex    = SMLLexFun
                        (structure Tokens = SMLLrVals.Tokens)
structure SMLParser = JoinWithArg
                        (structure ParserData = SMLLrVals.ParserData
structure Lex = SMLLex
structure LrParser = LrParser)

exception Parse of Report.t

fun fromSourceText st =
    let
      val file = SourceText.getFile st
      fun context r = Report.++ (r, Report.text ("while parsing " ^ Path.path file))
      fun fail r = raise Parse (context r)
    in
      let
        val source = Source.fromSourceText st
        val reader = Source.makeReader source

        (* The parser parses until EOF so the rest of the stream is always empty *)
        val ((topdecs, comments), _) =
            SMLParser.parse (Constants.PARSE_LOOKAHEAD,
                             SMLParser.makeLexer reader source,
                          fn (s, l, r) => Source.error source l s,
                             source)
      in
        {topdecs = topdecs, comments = comments}
      end handle LexError r => fail r
               | Path.Path r => fail r
               | IO.Io {name, cause = OS.SysErr (err, se), ...} =>
                 fail (Report.text (
                       (case se of
                          NONE    => err
                        | SOME m  => OS.errorMsg m
                       ) ^ ": " ^ name)
                      )
               | IO.Io {name, ...} =>
                 fail (Report.text ("Failed to read file: " ^ name))
    end

val fromFile = fromSourceText o SourceText.fromFile
end
