---
title: Wintersmith page draft
author: stephane-bachelier
date: 2014-3-5
template: article.jade
draft: false
---

This post cover the solution I've chosen to implement to support writing draft for wintersmith static generator.

---

## Why ?

The idea is to add a metadata `draft` in the article header which prevents an article from being published.

This article has the following headers:
```markdown
---
title: Wintersmith page draft
author: stephane-bachelier
date: 2014-3-5
template: article.jade

---
```

If I want to set is as a draft I want to be as easy as setting the `draft` property.
```markdown
---
title: Wintersmith page draft
author: stephane-bachelier
date: 2014-3-5
template: article.jade
draft: true

---
```

## How ?

I've create a new plugin `draftable_page` which extends `markdown` plugin. It simply exclude a page from displaying when the metadata `draft` is present and set to `true`. In only 12 lines. Really great!.

```coffeescript
module.exports = (env, callback) ->
  class DraftablePage extends env.plugins.MarkdownPage

    isDraft: -> @metadata.draft is true

    getView: ->
      return 'none' if @isDraft()
      return super()

  env.registerContentPlugin 'pages', '**/*.*(markdown|mkd|md)', DraftablePage

  callback()
```

To exclude the page from the paginator, I filter the article where the `draft` metadata is set. I've overwritten the `paginator` plugin and add this line:

```coffeescript
  getArticles = (contents) ->
    # ...
    articles = articles.filter (article) ->
      return false if article.metadata.draft is true
      article
    # ...
```


## Extending

This solution is really simple but it will prevent you from previewing your blog post while editing it. IMHO it's not a problem as markdown is made to be easy to read. And if you want a preview, it's easy to turning draft to false or remove the line. 

If you use [wintersmith-livereload](https://github.com/jnordberg/wintersmith-livereload), it will be definitely not a problem. By the time you have save the article, the web page will be reload :P

## Code

See this [gist](https://gist.github.com/stephanebachelier/2afc4c29c2e9a30b6e9d).

## References

[stackoverflow post: how to filter out content nodes with wintersmith static site generator?](http://stackoverflow.com/questions/19033010/how-to-filter-out-content-nodes-with-wintersmith-static-site-generator?rq=1)

