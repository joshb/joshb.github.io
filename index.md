---
layout: post
title: Home
---
<div class="photo"><img src="files/photo.jpg" alt=""></div>

Welcome to my website. I'm a software engineer whose interests include web development, 3D graphics programming, open source software, Linux, and Apple's platforms.

I have extensive experience developing software for professional and educational purposes, as well as developing open source software in my spare time. I have Bachelor of Science in Computer Science and Master of Software Engineering degrees from [Auburn University](http://www.auburn.edu/). More information about my education and professional experience can be found on [my LinkedIn profile](https://www.linkedin.com/in/joshbeam).

I have written some [articles](articles/) over the years, primarily related to OpenGL and graphics programming. I have also written some [open source software](software/) that you may find interesting (see [my GitHub profile](https://github.com/joshb) for more).

I can be contacted by email at [josh@joshbeam.com](mailto:josh@joshbeam.com).

<hr>

{% for post in site.posts limit: 10 %}
## [{{ post.title }}]({{ post.url }})
### {{ post.date | date: "%B %-d, %Y" }}

{{ post.content }}

{% endfor %}
