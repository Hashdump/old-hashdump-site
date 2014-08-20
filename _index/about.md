---
title: About
---
{% assign ofc = site.data.officers %}

### Who We Are
Hashdump is the computer security club at Colorado State University. We participate in and put on numerous security competitions every year, and attempt to facilitate a better understanding of security as a whole. All majors are welcome to join and participate.

### Constitution
You can read our organization's constitution [here](constitution.html)

### Contact Us
We meet every Tuesday at 5:00 PM in the Computer Science Building 315.
You can contact all current officers at `{{ ofc.emails | map: "Officers" }}`

### Officers
{% for y in ofc.years %}
#### {{ y.year }}

| Title |{% if ofc.currentYear == y.year %} Email |{% endif %} Name |
| ----- |{% if ofc.currentYear == y.year %} ----- |{% endif %} ---- |
{% for officer in y.officers[0] %}| {{ officer[0] }} | {% if ofc.currentYear == y.year %}`{{ ofc.emails | map: officer[0] }}` |{% endif %} {{ officer[1] }} |
{% endfor %}

<hr/>
{% endfor %}
