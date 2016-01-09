module.exports = class Bridge
    constructor: (@jid, @hubot, @appName, @baseURL) ->
        console.log 'instance was created '+baseURL+' - '+appName

    login: (username, password, success, error) ->
        _name = @appName
        _bot = @hubot
        _url = @baseURL
        _jid = @jid
        
        console.log _jid

        console.log "#{_name}: #{_url} authenticate"
        auth = 'Basic ' + new Buffer(username + ':' + password).toString('base64');

        try
            _bot.http(_url+'token/basic')
                .header('Accept', 'application/json')
                .header('Authorization', auth)
                .get() (err, res, body)->
                    console.log "auth request for #{username} returned with #{res.statusCode}"
                    switch res.statusCode
                        when 200
                            model = JSON.parse(body)
                            sect = 'Sect ' + new Buffer(username + ':' + model.token).toString('base64');
                            console.log "#{_name}-#{_jid}-sect"
                            _bot.brain.set "#{_name}-#{_jid}-sect", sect
                            _bot.brain.emit 'save'

                            console.log 'authenticated'
                            success()
                        else
                            error err, res, body
                    return
        catch e
            error e

    logout: () ->
        _name = @appName
        _bot = @hubot
        _url = @baseURL
        _jid = @jid

        console.log "removing credentials for #{_name}-#{_jid}-sect"
        _bot.brain.set "#{_name}-#{_jid}-sect", null
        _bot.brain.emit 'save'

    get: (resource, success, error) ->
        _name = @appName
        _bot = @hubot
        _url = @baseURL
        _jid = @jid

        console.log 'base: '+_url+' get '+resource
        _sect = _bot.brain.get "#{_name}-#{_jid}-sect"
        console.log 'sect: '+_sect
        if !(_sect?)
            error 'instance not logged in'
            return
        console.log 'call'
        _bot.http(_url+resource)
            .header('Accept', 'application/json')
            .header('Authorization', _sect)
            .get() (err, res, body) ->
                console.log 'return '+res.statusCode
                switch res.statusCode
                    when 200
                        length = res.headers['content-length']
                        type = res.headers['content-type']
                        if(type.indexOf('application/json', 0) > -1 && (length == undefined || length > 0))
                            success JSON.parse(body)
                        else success body
                    when 204
                        success 'no content'
                    when 401
                        error err, res, body
                    else
                        error err, res, body
                return
        console.log 'fired'

    delete: (resource, success, error) ->
        _name = @appName
        _bot = @hubot
        _url = @baseURL
        _jid = @jid

        console.log 'base: '+_url+' get '+resource
        _sect = _bot.brain.get "#{_name}-#{_jid}-sect"
        console.log 'sect: '+_sect
        if !(_sect?)
            error 'instance not logged in'
            return
        console.log 'call'
        _bot.http(_url+resource)
        .header('Accept', 'application/json')
        .header('Authorization', _sect)
        .delete() (err, res, body) ->
            console.log 'return '+res.statusCode
            switch res.statusCode
                when 200
                    length = res.headers['content-length']
                    type = res.headers['content-type']
                    if(type.indexOf('application/json', 0) > -1 && (length == undefined || length > 0))
                        success JSON.parse(body)
                    else success body
                when 204
                    success 'no content'
                when 401
                    error err, res, body
                else
                    error err, res, body
        return
        console.log 'fired'

    post: (item, resource, success, error) ->
        _name = @appName
        _bot = @hubot
        _url = @baseURL
        _jid = @jid

        console.log 'base: '+_url+' post '+resource
        _sect = _bot.brain.get "#{_name}-#{_jid}-sect"
        if !(_sect?)
            error 'instance not logged in'
            return
        _bot.http(_url+resource)
            .header('Accept', 'application/json')
            .header('Content-Type', 'application/json')
            .header('Authorization', _sect)
            .post(JSON.stringify(item)) (err, res, body) ->
                console.log 'return '+res.statusCode
                switch res.statusCode
                    when 200, 201
                        length = res.headers['content-length']
                        type = res.headers['content-type']
                        if(type.indexOf('application/json', 0) > -1 && length > 0)
                            success JSON.parse(body)
                        else success body
                    when 401
                        error err, res, body
                    else
                        error err, res, body
                return

    put: (item, resource, success, error) ->
        _name = @appName
        _bot = @hubot
        _url = @baseURL
        _jid = @jid

        console.log 'base: '+_url+' put '+resource
        _sect = _bot.brain.get "#{_name}-#{_jid}-sect"
        if !(_sect?)
            error 'instance not logged in'
            return

        _bot.http(_url+resource)
            .header('Accept', 'application/json')
            .header('Content-Type', 'application/json')
            .header('Authorization', _sect)
            .put(JSON.stringify(item)) (err, res, body) ->
                console.log 'return '+res.statusCode
                switch res.statusCode
                    when 200, 201
                        length = res.headers['content-length']
                        type = res.headers['content-type']
                        if(type.indexOf('application/json', 0) > -1 && length > 0)
                            success JSON.parse(body)
                        else success body
                    when 401
                        error err, res, body
                    else
                        error err, res, body
                return
