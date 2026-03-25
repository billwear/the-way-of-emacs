---
layout: default
title: tutorials
permalink: /blog/
---
# Tutorial blogs

Practical guides for using Emacs in the real world.
No magic. No handwaving. Just the facts as I know them..

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