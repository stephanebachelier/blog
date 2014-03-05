fs = require 'fs'

module.exports = (env, callback) ->
  class DraftablePage extends env.plugins.MarkdownPage

    isDraft: -> @metadata.draft is true

    getView: ->
      return 'none' if @isDraft()
      return super()

  env.registerContentPlugin 'pages', '**/*.*(markdown|mkd|md)', DraftablePage

  callback()
