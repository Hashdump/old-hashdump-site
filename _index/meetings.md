---
layout: page
title: Meetings
tagline: "Cale said that we needed more 'content', so here's Kirby: <(^.^<)"
---

| Date | Title | Notes |
| ---- | ----- | ----- |{% for meeting in site.posts %}
| [{{ meeting.date | date: "%-d %B %Y" }}]({{ meeting.url }}) | {{ meeting.title }} | {{ meeting.tagline }} |{% endfor %}
