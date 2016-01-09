# Description:
#   interact with the user management service
#
# Commands:
#   hubot ums login <username> <password> - stores the credentials for the calling user
#   hubot ums logout - removes the credentials for the calling user

UMS = require "./ums-bridge"

module.exports = (robot) ->
    robot.respond /(ums) login (.+) (.+)/i, (msg) ->
        jid = msg.message.user.jid
        username = msg.match[2]
        password = msg.match[3]
        if username == null
            msg.send 'username is missing'
            return
        if password == null
            msg.send 'password is missing'
            return
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return
        
        success = () ->
            msg.send 'stored credentials'
            return
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name

        bridge = new UMS jid, robot, options
        bridge.login(username, password, success, error)

    robot.respond /(ums) logout/i, (msg) ->
        jid = msg.message.user.jid
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name

        bridge = new UMS jid, robot
        bridge.logout()
        msg.send 'logged out successfully'

# TODO: add call to check which modules are installed
#    robot.respond /(ums) modules/i, (msg) ->
#        robot.http("https://54.186.169.148/ums-service/api/1/apps").get()
#        https://54.186.169.148/ums-service/api/1/apps