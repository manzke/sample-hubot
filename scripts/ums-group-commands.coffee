# Description:
#   interact with the user management service
#
# Commands:
#   hubot ums group <id> - return id, name, ...
#   hubot ums group:info <id> lock - return complete info
#   hubot ums group:update <id> <field> <value> - updates a field value
#   hubot ums groups - list all groups in tenant

UMS = require "./ums-group-bridge"

module.exports = (robot) ->
    robot.respond /ums group (\w+)/i, (msg) ->
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

        list_item = (group) ->
            msg.send "group ##{group.id} - #{group.name} in tenant #{group.tenantId}"
            return

        bridge.group(id, list_item, error)
        return

    robot.respond /ums group:info (\w+)/i, (msg) ->
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

        success = () ->
            msg.send 'retrieving group for id '+id

            list_item = (group) ->
                msg.send "group ##{group.id}"+JSON.stringify(group)
                return

            bridge.group(id, list_item, error)
            return

        bridge.authenticate(username, password, success, error)
        return

    robot.respond /ums group:update (\w+) ([^\s-]+) (.+)/i, (msg) ->
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

        success = (group) ->
            field = msg.match[2]
            value = msg.match[3]
            eval("group.#{field} = value")

            msg.send 'trying to update group'+JSON.stringify(group)
            bridge.update(id, group, send, error)
            return

        bridge.group(id, success, error)
        return

    robot.respond /ums groups/i, (msg) ->
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

        list_items = (groups) ->
            console.log 'listing groups'
            msg.send "group ##{group.id} - #{group.name} in tenant #{group.tenantId}" for group in groups
            return

        bridge.groups(list_items, error)
        return
