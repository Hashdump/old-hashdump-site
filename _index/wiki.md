---
layout: page
title: Wiki
tagline: A source of information on various security/technology topics
---
The Hashdump wiki aims to provide information on security/technology topics that both interest our members and are controversial in our fields of study.

<div id="columns">
  {% for cat in site.data.wiki %}
  <div class="column">
    <h2>{{ cat.title }}</h2>
    <ul>{% for w in site.collections.wiki.docs %}{% assign url_pieces = w.url | split: '/' %}{% if url_pieces[2] == cat.url and url_pieces[3] != 'index.html' %}
      <li><a href="{{ site.baseurl }}{{ w.url }}">{{ w.title }}</a></li>
    {% endif %}{% endfor %}</ul>
  </div>
  {% endfor %}
</div>
