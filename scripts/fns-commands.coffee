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

    robot.respond /(filenshare|fns) login (.+) (.+)/i, (msg) ->
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
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return
        
        success = () ->
            msg.send 'stored credentials'
            return
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.login(username, password, success, error)

    robot.respond /(filenshare|fns) logout/i, (msg) ->
        jid = msg.message.user.jid
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.logout()
        msg.send 'logged out successfully'

    robot.respond /(filenshare|fns) me/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return
        
        success = (m) ->
            console.log 'success'
            msg.send 'success: '+JSON.stringify(m)
            return

        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.me(success, error)

    robot.respond /(filenshare|fns) account/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return

        success = (m) ->
            console.log 'success'
            msg.send 'success: '+JSON.stringify(m)
            return

        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.account(success, error)

    robot.respond /(filenshare|fns) user:info (.+)/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        id = msg.match[2]
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return

        success = (m) ->
            console.log 'success'
            msg.send 'success: '+JSON.stringify(m)
            return

        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.user(id, success, error)

    robot.respond /(filenshare|fns) user:delete (.+) (.+)/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        item_id = msg.match[2]
        recipient_id = msg.match[3]
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return

        success = (m) ->
            console.log 'success'
            msg.send 'success: '+m
            return

        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.user_delete(item_id, recipient_id, success, error)

    robot.respond /(filenshare|fns) users/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return

        success = (m) ->
            console.log 'success'
            msg.send 'success: '+JSON.stringify(m)
            return

        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.users(success, error)

    robot.respond /(filenshare|fns) invite (.+) (.+) (.+)/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid

        first_name = msg.match[2]
        last_name = msg.match[3]
        email = msg.match[4]

        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return
        
        success = (m) ->
            msg.send 'success: '+JSON.stringify(m)
            return

        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        msg.send 'inviting '+email+' into your account'
        bridge.invite first_name, last_name, email, success, error


    robot.respond /(filenshare|fns) version/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            else msg.send 'request returned with an unknown error'
            if !!body
                msg.send 'body: '+body
            else msg.send 'request returned with an unknown error'
            return

        success = (m) ->
            console.log 'success'
            msg.send 'success: '+JSON.stringify(m)
            return

        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new FNS jid, robot, options
        bridge.version(success, error)