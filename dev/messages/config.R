## agetime settings for the message inventory (dev/messages/inventory.R).

## x_label_fail() stores message text in parsed labels, to be signalled
## later by the function that called the parser.
SIGNALS <- rbind(SIGNALS,
                 data.frame(fun = "x_label_fail", signal = "stored", arg = "msg"))
