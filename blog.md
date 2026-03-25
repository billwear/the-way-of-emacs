---
layout: default
title: tutorials
permalink: /blog/
---
# tutorials

practical guides for using emacs in the real world.
no magic. no handwaving. just the actual steps.

<ul class="post-list">
{% for post in site.posts %}
  <li>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <time datetime="{{ post.date | date_to_xmlschema }}">
      {{ post.date | date: "%b %-d, %Y" }}
    </time>
  </li>
{% endfor %}
</ul>