# Description:
#   interact with the user management service
#
# Commands:
#   hubot ums tenant <id> - return id, name, ...
#   hubot ums tenant:info <id> lock - return complete info
#   hubot ums tenant:update <id> <field> <value> - updates a field value
#   hubot ums tenant:groups <id> - list groups for specific tenant
#   hubot ums tenant:users <id> - list users for specific tenant
#   hubot ums tenant:find <field> <value>
#   hubot ums tenants (all|free|occupied|terminated) - list tenants

UMS = require "./ums-tenant-bridge"
util = require 'util'

ALL = []

PREPARED = {
    "TGR_PREPARED" : "true",
    "TGR_INUSE" : "false",
    "TGR_TERMINATED" : "false"
}

OCCUPIED = {
    "TGR_PREPARED" : "false",
    "TGR_INUSE" : "true",
    "TGR_TERMINATED" : "false"
}

TERMINATED = {
    "TGR_PREPARED" : "false",
    "TGR_INUSE" : "false",
    "TGR_TERMINATED" : "true"
}

tenant_states = {
    "all" : ALL
    "free" : PREPARED
    "occupied" : OCCUPIED
    "terminated" : TERMINATED
}

module.exports = (robot) ->
    robot.respond /ums tenants (all|free|occupied|terminated)?/i, (msg) ->
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

        option = msg.match[1]
        states = undefined
        switch option
            when 'all'
              states = tenant_states[option]
            when 'free'
              states = tenant_states[option]
            when 'occupied'
              states = tenant_states[option]
            when 'terminated'
              states = tenant_states[option]
            else
              error 'option '+option+' is unknown'
              return

        success = (tenants) ->
            msg.send 'filtering tenants'
            filtered_tenants = tenants.filter (tenant) ->
                if(states.length == 0)
                    return true
                prepared = tenant.properties['TGR_PREPARED']
                inuse = tenant.properties['TGR_INUSE']
                terminated = tenant.properties['TGR_TERMINATED']
                if((states['TGR_PREPARED'] == prepared) && (states['TGR_INUSE'] == inuse) && (states['TGR_TERMINATED'] == terminated))
                    return true
                return false
            console.log 'listing tenants'
            count = filtered_tenants.length
            msg.send "tenant ##{tenant.id} - #{tenant.name} #{tenant.description}" for tenant in filtered_tenants
            msg.send option+' tenant count: '+count
            return

        bridge.tenants(success, error)
        return

    robot.respond /ums tenant (\w+)$/i, (msg) ->
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

        list_item = (tenant) ->
            msg.send "tenant ##{tenant.id} - #{tenant.name} #{tenant.description}"
            return

        bridge.tenant(id, list_item, error)
        return

    robot.respond /ums tenant:info (\w+)/i, (msg) ->
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

        list_item = (tenant) ->
            msg.send "tenant "+JSON.stringify(tenant)
            return

        bridge.tenant(id, list_item, error)
        return

    robot.respond /ums tenant:find ([^\s-]+) (.+)/i, (msg) ->
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

        list_tenants = (tenants) ->
            msg.send 'filtering tenants: '+tenants.length
            filtered_tenants = tenants.filter (tenant) ->
                eval("fieldValue = tenant.#{field}")
                eval("compareValue = value")
                eval("result = ((tenant.#{field}.indexOf(value, 0)) > -1)")
                return result
            count = filtered_tenants.length
            msg.send "tenant ##{tenant.id} - #{tenant.name} #{tenant.description}" for tenant in filtered_tenants
            msg.send "tenant count: #{count}"
            return

        bridge.tenants(list_tenants, error)
        return

    robot.respond /ums tenant:update (\w+) ([^\s-]+) (.+)/i, (msg) ->
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

        success = (tenant) ->
            field = msg.match[2]
            value = msg.match[3]
            eval("tenant.#{field} = value")

            msg.send 'trying to update tenant'+JSON.stringify(tenant)
            bridge.update(id, tenant, send, error)
            return

        bridge.tenant(id, success, error)
        return

    robot.respond /ums tenant:groups (\w+)/i, (msg) ->
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

        list_item = (groups) ->
            msg.send "group ##{group.id} - #{group.name} in tenant #{group.tenantId}" for group in groups
            return

        bridge.groups(id, list_item, error)
        return

    robot.respond /ums tenant:users (\w+)/i, (msg) ->
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

        success = (users) ->
            msg.send "user ##{user.id} - #{user.displayName} (#{user.email}) in tenant #{user.tenantId}" for user in users
            return

        bridge.users(id, success, error)
        return
