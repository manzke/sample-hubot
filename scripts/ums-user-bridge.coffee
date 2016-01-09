require "./ums-commands"
UMS = require "./ums-bridge"
crypto = require "crypto"

module.exports = class UMSUserBridge extends UMS
    users: (success, error) ->
        @get 'users', success, error

    user: (item_id, success, error) ->
        @get 'users/'+item_id, success, error

    groups: (item_id, success, error) ->
        @get 'users/'+item_id+'/groups', success, error

    password: (item_id, new_password, success, error) ->
        hash = crypto.createHash('md5').update(new_password).digest("hex")
        password = {
            'type':'PASSWORD'
            'password':new_password,
            'passwordMD5':hash,
        }
        @put password, 'users/'+item_id+'/password', success, error

    update: (item_id, item, success, error) ->
        @put item, 'users/'+item_id, success, error