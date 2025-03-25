package = "lua-euler"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
}
dependencies = {
    "lua >= 5.4",
    "lbc >= 20180729-1",
    "scribe >= 1.0.0-1"
}
build = {
   type = "builtin",
   modules = {
      main = "src/main.lua"
   }
}
