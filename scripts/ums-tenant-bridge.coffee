require "./ums-commands"
UMS = require "./ums-bridge"

module.exports = class UMSTenantBridge extends UMS
    tenants: (success, error) ->
        @get 'tenants', success, error

    tenant: (item_id, success, error) ->
        @get "tenants/#{item_id}", success, error

    groups: (item_id, success, error) ->
        @get "tenants/#{item_id}/groups", success, error

    users: (item_id, success, error) ->
        @get "tenants/#{item_id}/users", success, error

    update: (item_id, item, success, error) ->
        @put item, "tenants/#{item_id}", success, error