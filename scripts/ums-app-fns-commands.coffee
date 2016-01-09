# Description:
#   interact with the user management service
#
# Commands:
#   hubot apps:fns tenant <id> - return id, name, ...
#   hubot apps:fns tenant:info <id> lock - return complete info
#   hubot apps:fns tenant:find <field> <value>
#   hubot apps:fns tenant:enable <company> <first_name> <last_name> <email>
#   hubot apps:fns tenant:quota <id> <storageLimitMB> <userLimit> <guestLimit> <uploadLimitMB>
#   hubot apps:fns tenants (all|free|occupied|terminated) - list tenants

UMS = require "./ums-app-fns-bridge"
util = require 'util'

module.exports = (robot) ->
    robot.respond /apps:fns tenants (all|free|occupied|terminated)/i, (msg) ->
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
        state = undefined
        switch option
            when 'all'
                state = undefined
            when 'free'
                state = 'PREPARED'
            when 'occupied'
                state = 'INUSE'
            when 'terminated'
                state = option
            else
                msg.send 'unknown state: '+option
                state = undefined

        success = (tenants) ->
            msg.send 'filtering tenants'
            console.log 'filtering tenants'
            count = tenants.length
            msg.send "tenant ##{tenant.id} - #{tenant.name} #{tenant.description}" for tenant in tenants
            msg.send option+' tenant count: '+count
            return
        msg.send 'using state: '+state
        bridge.tenants(state, success, error)
        return

    robot.respond /apps:fns tenant (\w+)$/i, (msg) ->
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

    robot.respond /apps:fns tenant:info (\w+)/i, (msg) ->
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

    robot.respond /apps:fns tenant:find ([^\s-]+) (.+)/i, (msg) ->
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

        success = (tenants) ->
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

        bridge.tenants(success, error)
        return

    robot.hear /apps:fns tenant:quota ([^\s-]+) (\w+) (\w+) (\w+) (\w+)/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options

        id = msg.match[1]

        tenant = {
            'type':'TENANT',
            'storageLimitMB': msg.match[2],
            'userLimit': msg.match[3],
            'guestLimit': msg.match[4],
            'uploadLimitMB': msg.match[5],
        }

        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return

        send = (user) ->
            msg.send "updated user successfully: "+JSON.stringify(user)
            return

        msg.send 'trying to enable tenant'+JSON.stringify(tenant)
        bridge.quota(id, tenant, send, error)
        return

    robot.hear /apps:fns tenant:enable ([^\s-]+) (\w+) (\w+) (.+)/i, (msg) ->
        msg.send 'starting'
        jid = msg.message.user.jid
        name = robot.brain.get "#{jid}-server"
        options = undefined
        if name?
            options = robot.brain.get name
        bridge = new UMS jid, robot, options

        company_name = msg.match[1]
        first_name = msg.match[2]
        last_name = msg.match[3]
        email = msg.match[4]

        tenant = {
            'type':'TENANT',
            'name':company_name,
            'storageLimitMB':'100',
            'userLimit':'1',
            'guestLimit':'1',
            'uploadLimitMB':'1',
            'properties' : {
                'user-firstname':first_name,
                'user-lastname':last_name,
                'user-email':email
            }
        }

        error = (err, res, body) ->
            if !!err
                msg.send 'error: '+err
            if !!body
                msg.send 'body: '+body
            return

        send = (user) ->
            msg.send "updated user successfully: "+JSON.stringify(user)
            return

        msg.send 'trying to enable tenant'+JSON.stringify(tenant)
        bridge.enable(tenant, send, error)
        return
