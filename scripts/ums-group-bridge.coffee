require "./ums-commands"
UMS = require "./ums-bridge"

module.exports = class UMSGroupBridge extends UMS
    groups: (success, error) ->
        @get 'groups', success, error

    group: (item_id, success, error) ->
        @get 'groups/'+item_id, success, error

    users: (item_id, success, error) ->
        @get 'groups/'+item_id+'/users', success, error

    update: (item_id, item, success, error) ->
        @put item, 'groups/'+item_id, success, error