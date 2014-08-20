---
---

window.onload = ->
  [].forEach.call document.querySelectorAll(".highlight"), (el) ->
    el.ondblclick = (e) ->
      (window.getSelection()).removeAllRanges() if window.getSelection
      el.classList.toggle "hidelinenos"
    el.innerHTML = el.innerHTML.replace(/<span class="lineno">(\s*\d+)<\/span> /gm, '<span class="lineno">$1 </span>');
