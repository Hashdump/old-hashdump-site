---
tagline: CSU Security Club
overview: true
---
## Colorado State University's computer security club.

This is all the Coffeescript we use on our site...
Just double click on `code blocks` to toggle line numbers on/off

~~~ coffeescript
window.onload = ->
  [].forEach.call document.querySelectorAll(".highlight"), (el) ->
    el.ondblclick = (e) ->
      (window.getSelection()).removeAllRanges() if window.getSelection
      el.classList.toggle 'hidelinenos'
    el.innerHTML = el.innerHTML.replace(/<span class="lineno">(\s*\d+)<\/span> /gm, '<span class="lineno">$1 </span>');
~~~
