---
title: Testing window.location with SinonJS
author: stephane-bachelier
date: 2014-05-09
tags: sinon,javascript,test,stub
comments: true
template: article.jade
---

This is a simple solution to test code using `window.location.href` or any other function that can change the page URL and thus, trigger a change in the page content, which is not wanted while doing HTML-based tests.

---

## Our problem

I have a login form on my home page and I want the user being redirected to its profile page which is available on a distinct url.

The choice is to use `window.location.href` property, which trigger an immediate change of the browser URL and a request.

I may have used any other function provided by `window.location`, which are :
 * window.location.assign
 * window.locaiton.reload
 * window.location.replace

Also setting a value to `window.location` is equivalent to `window.location.assign`.

## Setup

Test will be made by using `mocha`, `should.js` and `sinon` for the fake part.

## The solution


### First, wrap it

To be able to test code which trigger a change in URL, the code must be wrapped in a function, as presented below:

```
redirect: function (url) {
  if (url) {
    window.location.href = url;
  }
}
```

### Then stub it!

The magic happens with `sinon.stub`

From the [Stub API doc](http://sinonjs.org/docs/#stubs):

> Test stubs are functions (spies) with pre-programmed behavior. They support the full test spy API in addition to methods which can be used to alter the stub’s behavior.
>
> As spies, stubs can be either anonymous, or wrap existing functions. When wrapping an existing function with a stub, the original function is not called.

So by stubbing the original function, the redirection won't happen without breaking the code under test.

Enough talk, code in action. Imagine my `redirect` function is available in a `helper` object, 

```
// code to test
var helper = {
  // [...]
  
  redirect: function (url) {
    if (url) {
      window.location.href = url;
    } 
  },
  // [...]
};
```

And the test is as easy as:
```
// test suite
decribe('a test suite', function () {

  // redirection test
  it('should redirect to a page', function () {
    var sandbox = sinon.sandbox.create();

    // stub helper.redirect method
    sinon.stub(helper, 'redirect');
    // now helper.redirect function is wrapped by a sinon.stub

    // call code to fake a successful login response
    login_successful_response_handler(/* with fake data */);

    // check assertion are right
    helper.redirect.should.have.been.calledOnce;

    // restore original function
    sandbox.restore();
   
  });
});

```


## Conclusion

I hope you will find this post to be useful. Just remember to develop your code in small testable units. Better, if you can, do TDD (or Test Driven Development).

And remember nothing is untestable :)

I only can encourage you to take a look at [Sinon Stub API](http://sinonjs.org/docs/#stubs). It is really really powerful, as you can program a whole stub about how it must react depending on its inputs. 

As an example you can read a blog post from @elijahmanor [Unit Test like a Secret Agent with Sinon.js](http://www.elijahmanor.com/unit-test-like-a-secret-agent-with-sinon-js/)

