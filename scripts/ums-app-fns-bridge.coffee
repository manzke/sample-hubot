require "./ums-commands"
UMS = require "./ums-bridge"

module.exports = class UMSTenantBridge extends UMS
    tenants: (success, error) ->
        tenants undefined, success, error

    tenants: (state, success, error) ->
        resource = 'apps/fns/tenants'
        if state?
            resource = resource + "?state=#{state}"
        @get resource, success, error

    tenant: (item_id, success, error) ->
        @get "apps/fns/tenants/#{item_id}", success, error

    enable: (item, success, error) ->
        @post item, 'apps/fns/tenants', success, error

    quota: (item_id, item, success, error) ->
        @put item, "apps/fns/tenants/#{item_id}", success, error