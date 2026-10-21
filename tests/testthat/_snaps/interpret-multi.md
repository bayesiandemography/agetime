# default interpret_multi gives a message for ranges of width 4, 9, 14, ...

    Code
      ans <- cohort_width(c("1990-1994", "1995-1999"))
    Message
      Interpreting "1990-1994" as [1990, 1994), which has width 4.
      i If "1990-1994" should instead be interpreted as [1990, 1995), set `interpret_multi` to "below_upper".
      i Supplying a value for `interpret_multi` silences this message.

