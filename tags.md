---
layout: page
title: Tags
description: "An archive of posts sorted by tag."
---

{% capture tagordinal_tagslug_tagcount %}
  {% for tag in site.tags %}
    {{ tag[1].size | plus: 1000 }}#{{ tag[0] }}#{{ tag[1].size }}
  {% endfor %}
{% endcapture %}
{% assign sorted_tags = tagordinal_tagslug_tagcount | split: ' ' | sort %}

<div id="tags">
  <ul class="tag-box inline">
  {% for tag in sorted_tags reversed %}
    {% assign tagordinal_tagslug_tagcount = tag | split: '#' %}
    {% assign slug_tag = tagordinal_tagslug_tagcount[1] %}
    {% assign tag_count = tagordinal_tagslug_tagcount[2] %}
    {% include find_tag.html tag_to_find_as_slug=slug_tag %}
    <li><a href="#{{ slug_tag | cgi_escape }}">{{ data_tag.name }} <span>{{ site.tags[slug_tag] | size }}</span></a></li>
  {% endfor %}
  </ul>

  {% for tag in sorted_tags reversed %}
    {% assign tagordinal_tagslug_tagcount = tag | split: '#' %}
    {% assign slug_tag = tagordinal_tagslug_tagcount[1] %}
    {% assign tag_count = tagordinal_tagslug_tagcount[2] %}
    {% include find_tag.html tag_to_find_as_slug=slug_tag %}
    <h2 id="{{ slug_tag | cgi_escape }}">{{ data_tag.name }}</h2>
    <ul class="posts">
    {% for post in site.tags[slug_tag] %}
      {% if post.title != null %}
        <li itemscope><span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}" itemprop="datePublished">{{ post.date | date_to_string }}</time></span> &raquo; {% if post.category == "speaking" %}<i class="fa fa-microphone"></i> {% endif %}<a href="{{ post.url }}">{{ post.title }}</a></li>
      {% endif %}
    {% endfor %}
    </ul>
  {% endfor %}
</div>
