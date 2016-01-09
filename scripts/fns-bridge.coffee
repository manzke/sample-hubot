Bridge = require "./abstract-bridge"
module.exports = class FNS extends Bridge
    @DEFAULT_NAME: 'fns'

    constructor: (jid, robot, options) ->
        protocol = 'https'
        host = 'sample.com'
        service = 'service'
        api_version = 1
        if options?
            if options.protocol?
                protocol = options.protocol
            if options.host?
                host = options.host
            if options.service?
                service = options.service
            if options.api_version?
                api_version = options.api_version

        url = "#{protocol}://#{host}/#{service}/api/#{api_version}/"
        super(jid, robot, FNS.DEFAULT_NAME, url)

    user_settings: (success, error) ->
        @get 'users/settings', success, error

    user_delete: (item_id, recipient_id, success, error) ->
        console.log 'delete_user'
        @delete "users/#{item_id}?recipientId=#{recipient_id}", success, error

    users: (success, error) ->
        @get 'users', success, error

    user: (item_id, success, error) ->
        @get 'users/'+item_id, success, error

    me: (success, error) ->
        @get 'users/current', success, error

    account: (success, error) ->
        @get 'accounts', success, error

    account_settings: (success, error) ->
        @get 'accounts/settings', success, error

    invite: (first_name, last_name, email, success, error) ->
        #create user
        user = {
            'type':'user',
            'firstname':first_name,
            'lastname':last_name,
            'email':email,
            'rights':['SHARE']
        }
        @post user, 'users', success, error

    projects: (success, error) ->
        @get 'spaces', success, error
        
    project: (item_id, success, error) ->
        @get 'spaces/'+item_id, success, error
        
    folder: (item_id, success, error) ->
        @get 'folders/'+item_id, success, error

    document: (item_id, success, error) ->
        @get 'documents/'+item_id, success, error

    version: (success, error) ->
        @get 'system', success, error

