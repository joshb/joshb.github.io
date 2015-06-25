---
layout: post
title: Using Swift for OpenGL development on OS X
---
I've been working with [Swift](https://developer.apple.com/swift/) lately and enjoying it quite a bit. Having done a lot of OpenGL development in my spare time in the past, I decided to try my hand at writing some OpenGL code in Swift.

I used a simple OpenGL demo application that I had previously written in Objective-C as the basis of a new Swift version, and the results can be found [on GitHub](https://github.com/joshb/CocoaOpenGL-Swift). It's a Cocoa-based OS X application.

Swift has pretty good facilities for working with C APIs, so using it for OpenGL development isn't too much trouble, although there are some minor annoyances. For example, the parameters to a number of OpenGL functions are GLenums or GLbooleans, but the constants used as arguments are usually defined as GLints, so you have to cast things frequently:

{% highlight swift %}
glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIds[1])
glBufferData(GLenum(GL_ARRAY_BUFFER), sizeof(Float) * tcSize, tc, GLenum(GL_STATIC_DRAW))
{% endhighlight %}

Similarly, there are signed/unsigned inconsistencies; the signed result of one function may need to be passed in as an unsigned argument to another. For example, glGetAttribLocation returns a GLint, but glVertexAttribPointer expects to receive the location as a GLuint. With C/C++/Objective-C, the conversions would be performed implicitly, but Swift makes you convert them explicitly (and that's a good thing, in my opinion).

Aside from those minor issues, OpenGL development with Swift appears to be fairly painless.
