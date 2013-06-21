
_ = require 'underscore'

regex =
    single: /\/([^\/]+)\/?/
    doubleOptional: /\/([^\/]+)(?:\/([^\/]+)\/?)?/
    double: /\/([^\/]+)\/([^\/]+)\/?/

configs =
    backbone:
        create:
            method: 'post'
            regex: regex.single
        read:
            method: 'get'
            regex: regex.doubleOptional
            variables: ['id']
        update:
            method: 'put'
            regex: regex.double
            variables: ['id']
        delete:
            method: 'delete'
            regex: regex.double
            variables: ['id']
    angular:
        list:
            method: 'get'
            regex: regex.single
        create:
            method: 'post'
            regex: regex.single
        read:
            method: 'get'
            regex: regex.double
            variables: ['id']
        update:
            method: 'put'
            regex: regex.double
            variables: ['id']
        delete:
            method: 'delete'
            regex: regex.double
            variables: ['id']

configs.backbonjs = configs.backbone
configs.angularjs = configs.angular

exports.routeForward = (options) ->
    unless _.isObject options.config
        options.type = options.config
        options.config = configs[options.type]
        unless options.config?
            throw new Error("RouteForwardError: No config for #{options.type}")
    (request, response, next) ->
        for route, meta of options.config
            if meta.method is request.method.toLowerCase()
                match = meta.regex.exec request.url
                if match?
                    meta.variables ?= []
                    request.params ?= {}
                    for index, variable of meta.variables
                        request.params[variable] = match[2 + parseInt(index)]
                    return request.io.route("#{match[1]}:#{route}")
        next()
        

