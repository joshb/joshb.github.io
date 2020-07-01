---
layout: post
title: Customizing Social Media Previews for Web Pages
date: 2020-07-01
description: How to use the Open Graph protocol to customize social media previews for web pages.
---
I recently wanted to customize the preview that would be shown when sharing an article from my website through social media, and found that this can be accomplished by utilizing the [Open Graph protocol](https://ogp.me). This is a standard that was created by Facebook and is also supported by other platforms, such as Twitter.

The Open Graph protocol defines `meta` tags that can be added to HTML documents to define attributes such as the title, a short description, and an image to appear as part of a preview. For example, here are the tags from my [Triangle Rasterization](/articles/triangle_rasterization) article:

```html
<meta property="og:type" content="website"/>
<meta property="og:url" content="https://joshbeam.com/articles/triangle_rasterization/"/>
<meta property="og:title" content="Triangle Rasterization"/>
<meta property="og:description" content="This article presents an algorithm for triangle rasterization, a fundamental graphics rendering technique used in game development. It contains sample C++ code."/>
<meta property="og:image" content="https://joshbeam.com/articles/triangle_rasterization/trianglerast.png"/>
```

In the case of my website, I use the [Jekyll](https://jekyllrb.com) static site generator, so I have a layout defined that allows me to easily set these tags for each page, while using sensible defaults for pages that I didn’t specify custom values for:

```html
<meta property="og:type" content="website" />
<meta property="og:url" content="{{ site.url | append: page.url }}" />
{% if page.title %}
<title>{{ page.title }} - Josh Beam's Website</title>
<meta property="og:title" content="{{ page.title }}" />
{% else %}
<title>Josh Beam's Website</title>
<meta property="og:title" content="Josh Beam's Website" />
{% endif %}
{% if page.description %}
<meta property="og:description" content="{{ page.description | strip_html | escape }}" />
{% endif %}
{% if page.image %}
<meta property="og:image" content="{{ site.url | append: page.url | append: page.image }}" />
{% else %}
<meta property="og:image" content="{{ site.url | append: '/files/photo.jpg' }}" />
{% endif %}
```

To see how previews would appear for your web pages, you can use [Facebook's Sharing Debugger](https://developers.facebook.com/tools/debug/) or [Twitter’s card validator](https://cards-dev.twitter.com/validator).