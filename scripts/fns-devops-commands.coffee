# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot fns login <username> <password> - stores the credentials for the calling user
#   hubot fns logout - removes the credentials for the calling user
#   hubot fns invite <first_name> <last_name> <user_email>
#   hubot fns me - returns the information about your actual user
#   hubot fns version
#   hubot fns account
#   hubot fns users
#   hubot fns user <id>

FNS = require "./fns-bridge"

module.exports = (robot) ->
    process.on 'uncaughtException', (error)->
        console.error "CAUGHT uncaughtException", error

#https only check
#http forward check
#config.json check
#desktop.json check
#config handler check
#desktop client available check
#login check -> can login
#security check
#   -> cookies secure and httpOnly
#   -> listing for apache is disabled
#   -> error pages don't contain stacktrace or server information
#performance check
#   -> how long does a search take
#   -> how long does a login take
#version check  -> can login and retrieve infos
#localization check -> is available
#new project check
#new folder check
#upload check
#download check
#render check
#recycle check
#delete check
