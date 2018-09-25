---
layout: page
title: About
---
{% assign d = site.data.officers %}

### Who We Are
Hashdump is the computer security club at Colorado State University. We participate in and put on numerous security competitions every year, and attempt to facilitate a better understanding of security as a whole. All majors are welcome to join and participate.

### Constitution
You can read our organization's constitution [here](constitution.html)

### Contact Us
We meet every Tuesday at 6:30 PM in the Computer Science Building 130.
You can contact all current officers at `{{ d.emails["Officers"] }}`

### Officers

| Title | Email | Name |
| ----- | ----- | ---- |{% for o in d.years[d.currentYear] %}
| {{ o[0] }} | `{{ d.emails | map: o[0] }}` | {{ o[1] }} |{% endfor %}
