structure SD = DictFn(structure Key = StringKey)

val esperanto = SD.bind("frog", "ranoj", SD.empty)
val esperanto2 = SD.bind("help", "helpo", esperanto)

val _ = app print [SD.find("help", esperanto2),
                   "\n",
                   SD.find("frog", esperanto2),
                   "\n"]
