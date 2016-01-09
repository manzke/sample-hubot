# Description:
#   manage server
#
# Commands:
#   hubot server:add name http|https ip
#   hubot server:remove name
#   hubot server:activate name
#   hubot server:deactivate
#   hubot server:info - returns the info of the activated server
#   hubot server:info <name>
#   hubot server:list

module.exports = (robot) ->
    robot.respond /server:add ([^\s-]+) (http|https) ([^\s-]+)/i, (msg) ->
        name = msg.match[1].toString()
        options = {
            'protocol' : msg.match[2],
            'host' : msg.match[3]
        }

        msg.send "adding server #{name} - #{JSON.stringify(options)}"
        robot.brain.set name, options
        server_list = robot.brain.get 'server-list'
        if server_list?
            server_list.push [name]
        else server_list = [name]
        robot.brain.set 'server-list', server_list

    robot.respond /server:list/i, (msg) ->
        server_list = robot.brain.get 'server-list'
        if server_list?
            msg.send 'server_list: '+server_list.toString()
        else msg.send 'sorry nobody registered a server yet'

    robot.respond /server:clear/i, (msg) ->
        robot.brain.set 'server-list', null
        msg.send 'server list was cleared'

    robot.respond /server:remove ([^\s-]+)/i, (msg) ->
        name = msg.match[1].toString()

        msg.send "removing server #{name}"
        robot.brain.set name, null
        server_list = robot.brain.get 'server-list'

        if server_list?
            new_list = server_list.filter (server_name) ->
                return server_name.toString() isnt name
            msg.send 'new_list: '+new_list.toString()
            robot.brain.set 'server-list', new_list

    robot.respond /server:info ([^\s-]+)/i, (msg) ->
        name = msg.match[1]
        options = robot.brain.get name
        if options?
            msg.send "server info for #{name} - #{JSON.stringify(options)}"
        else msg.send "server for name #{name} not found"

    robot.respond /server:info$/i, (msg) ->
        jid = msg.message.user.jid
        name = robot.brain.get "#{jid}-server"
        if name?
            options = robot.brain.get name
            if options?
                msg.send "info for your activated server #{name} - #{JSON.stringify(options)}"
            else msg.send "server for name #{name} not found"
        else msg.send "you don't have an activated server. hubot is falling back to default."

    robot.respond /server:activate ([^\s-]+)/i, (msg) ->
        jid = msg.message.user.jid
        name = msg.match[1]
        options = robot.brain.get name
        if options?
            msg.send "activating server #{name} - #{JSON.stringify(options)}"
            robot.brain.set "#{jid}-server", name
        else msg.send "server for name #{name} not found"

    robot.respond /server:deactivate/i, (msg) ->
        jid = msg.message.user.jid
        msg.send "deactivating server"
        robot.brain.set "#{jid}-server", null