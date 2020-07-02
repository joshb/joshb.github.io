---
title: Customizing Social Media Previews for Web Pages
description: How to use the Open Graph protocol to customize social media previews for web pages.
---
I recently wanted to customize the preview that would be shown when sharing an article from my website through social media, and found that this can be accomplished by utilizing the [Open Graph protocol](https://ogp.me). This is a standard that was created by Facebook and is also supported by other platforms, such as Twitter.

The Open Graph protocol defines `meta` tags that can be added to HTML documents to define attributes such as the title, a short description, and an image to appear as part of a preview. For example, here are the tags from my [Triangle Rasterization](/articles/triangle_rasterization) article:

```html
<meta property="og:type" content="website"/>
<meta property="og:url" content="https://joshbeam.com/articles/triangle_rasterization/"/>
<meta property="og:title" content="Triangle Rasterization"/>
<meta property="og:description" content="This article presents an algorithm for triangle rasterization,
a fundamental graphics rendering technique used in game development. It contains sample C++ code."/>
<meta property="og:image" content="https://joshbeam.com/articles/triangle_rasterization/trianglerast.png"/>
```

To see how previews would appear for your web pages, you can use [Facebook's Sharing Debugger](https://developers.facebook.com/tools/debug/) or [Twitter’s card validator](https://cards-dev.twitter.com/validator).