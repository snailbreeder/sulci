(*
 * (c) 2004-2008 Anastasia Gornostaeva. <ermine@ermine.pp.ru>
 *)

open Common
open Math

let pcalc text event from xml lang out =
  if text <> "" then
    let reply = 
      try
        let lexbuf = Lexing.from_string text in
          Pcalc.line Pcalc_lexer.token lexbuf
      with 
        | MathNumberTooBig ->
            Lang.get_msg lang "plugin_calc_number_too_big" []
        | MathCannotFloatFact ->
            Lang.get_msg lang "plugin_calc_cannot_float_fact" []
        | MathNegNumber ->
            Lang.get_msg lang "plugin_calc_negative_number" []
        | _ ->
            Lang.get_msg lang "plugin_calc_not_parsed" []
    in
      make_msg out xml reply
  else
    make_msg out xml (Lang.get_msg lang "plugin_calc_empty_command" [])
      
let icalc text event from xml lang out =
  if text <> "" then
    let reply = 
      try
        let lexbuf = Ulexing.from_utf8_string text in
          Icalc.line (fun _ -> Icalc_ulex.token lexbuf) 
            (Lexing.from_string "dummy")
            (*
              let lexbuf = Lexing.from_string text in
              Icalc.line Icalc_lexer.token lexbuf
            *)
      with 
        | MathNumberTooBig ->
            Lang.get_msg lang "plugin_calc_number_too_big" []
        | MathCannotFloatFact ->
            Lang.get_msg lang "plugin_calc_cannot_float_fact" []
        | MathNegNumber ->
            Lang.get_msg lang "plugin_calc_negative_number" []
        | Failure err ->
            Lang.get_msg lang "plugin_calc_divide_by_zero" []
        | exn ->
            Lang.get_msg lang "plugin_calc_not_parsed" []
    in
      make_msg out xml reply
  else
    make_msg out xml (Lang.get_msg lang "plugin_calc_empty_command" [])
      
let _ =
  Hooks.register_handle (Hooks.Command ("rpn", pcalc));
  Hooks.register_handle (Hooks.Command ("calc", icalc))
