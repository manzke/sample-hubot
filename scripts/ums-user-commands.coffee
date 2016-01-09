# Description:
#   interact with the user management service
#
# Commands:
#   hubot ums users - list all user in tenant
#   hubot ums user <id> - return id, name, ...
#   hubot ums user:info <id> lock - return complete info
#   hubot ums user:update <id> <field> <value> - updates a field value
#   hubot ums user:password <id> <password>

UMS = require "./ums-user-bridge"

module.exports = (robot) ->
    robot.respond /ums user (\w+)$/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        id = msg.match[1]
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return

        success = (user) ->
            msg.send "user ##{user.id} - #{user.displayName} (#{user.email}) in tenant #{user.tenantId}"
            return

        bridge.user(id, success, error)
        return
       
    robot.respond /ums user:info (\w+)/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        id = msg.match[1]
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return

        success = (user) ->
            msg.send "user "+JSON.stringify(user)
            return

        bridge.user(id, success, error)
        return
        
    robot.respond /ums user:password ([^\s-]+) ([^\s-]+)$/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        id = msg.match[1]
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return
        send = () ->
            msg.send "updated password for user ##{id}"
            return

        success = (user) ->
            bridge.password(id, msg.match[2], send, error)
            return

        bridge.user(id, success, error)
        return

    robot.respond /ums user:update (\w+) ([^\s-]+) (.+)/i, (msg) ->
        msg.send 'starting'
        id = msg.match[1]
        jid = msg.message.user.jid
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return

        send = (user) ->
            msg.send "updated user successfully: "+JSON.stringify(user)
            return

        success = (user) ->
            field = msg.match[2]
            value = msg.match[3]
            eval("user.#{field} = value")

            msg.send 'trying to update user '+JSON.stringify(user)
            bridge.update(id, user, send, error)
            return

        bridge.user(id, success, error)
        return


    robot.respond /ums users:find ([^\s-]+) (.+)/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        field = msg.match[1]
        value = msg.match[2]
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return

        success = (users) ->
            msg.send 'filtering users: '+users.length
            filtered_users = users.filter (user) ->
                eval("fieldValue = user.#{field}")
                eval("compareValue = value")
                eval("result = ((user.#{field}.indexOf(value, 0)) > -1)")
                return result
            count = filtered_users.length
            msg.send "user ##{user.id} - #{user.displayName} (#{user.email}) in tenant #{user.tenantId}" for user in filtered_users
            msg.send "user count: #{count}"
            return

        bridge.users(success, error)
        return

    robot.respond /ums users$/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options
        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return

        success = (users) ->
            console.log 'listing users count: '+users.length
            msg.send "user ##{user.id} - #{user.displayName} (#{user.email}) in tenant #{user.tenantId}" for user in users
            return

        bridge.users(success, error)
        return

