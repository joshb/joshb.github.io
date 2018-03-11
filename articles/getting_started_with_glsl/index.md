---
layout: post
title: Tutorial - Getting Started with the OpenGL Shading Language (GLSL)
date: 2010-12-30
---

This article provides an introduction to the OpenGL Shading Language (GLSL). It contains sample C and GLSL code, and is accompanied by a diffuse/specular lighting demo with full source code. The code is available under an open source, BSD-style <a href="license.txt">license</a> and was designed to be as simple as possible, so that it can easily be used in other projects.

    <h2>Overview of GLSL</h2>

If you're not familiar with shaders, they are small programs that are executed on a per-vertex or per-pixel basis during drawing operations (there are also geometry shaders, which operate on geometric primitives, but they will not be covered in this tutorial).

Although there were various other extensions for using shaders with OpenGL in the past, the OpenGL Shading Language (or GLSL for short) has been an official part of the OpenGL standard since version 2.0 and is now the preferred language for implementing shaders in OpenGL. Shaders give programmers much greater control over rendering than OpenGL's fixed function pipeline, much of which has been deprecated in recent versions of OpenGL; OpenGL ES 2.0, for embedded systems, has even dropped the fixed function pipeline in favor of a shader-based approach. GLSL is therefore an important part of modern OpenGL development.

    <h2>Shader and Program Objects</h2>

In order to use GLSL shaders in OpenGL, we first need to know about shader and program objects, which will allow us to compile and link GLSL shaders so that they can then be used during drawing operations. Data may be passed from one shader stage to another (for example, vertex shaders often generate information that is passed to fragment shaders), and thus this mechanism for linking multiple shaders into one program object is necessary.

A shader object represents a single shader of a certain type (for example, a vertex shader or a fragment shader). Typically, you will create a shader object, pass it the shader source code as a string, and then compile it. The demo accompanying this article contains a C source file called shader.c that contains a function to easily compile a GLSL shader contained in a file:

```c++
/*
 * Returns a shader object containing a shader
 * compiled from the given GLSL shader file.
 */
static GLuint
shaderCompileFromFile(GLenum type, const char *filePath)
{
    char *source;
    GLuint shader;
    GLint length, result;

    /* get shader source */
    source = shaderLoadSource(filePath);
    if(!source)
        return 0;

    /* create shader object, set the source, and compile */
    shader = glCreateShader(type);
    length = strlen(source);
    glShaderSource(shader, 1, (const char **)&source, &length);
    glCompileShader(shader);
    free(source);

    /* make sure the compilation was successful */
    glGetShaderiv(shader, GL_COMPILE_STATUS, &result);
    if(result == GL_FALSE) {
        char *log;

        /* get the shader info log */
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &length);
        log = malloc(length);
        glGetShaderInfoLog(shader, length, &result, log);

        /* print an error message and the info log */
        fprintf(stderr, "shaderCompileFromFile(): Unable to compile %s: %s\n", filePath, log);
        free(log);

        glDeleteShader(shader);
        return 0;
    }

    return shader;
}
```

The above function first calls <strong>shaderLoadSource</strong>, another function defined in the shader.c file which simply returns a string containing the contents of the file with the given file path. Next, it creates a shader object using the OpenGL <strong>glCreateShader</strong> function and sets the shader's source by using the <strong>glShaderSource</strong> function. Finally, the shader is compiled with the <strong>glCompileShader</strong> function, the memory containing the shader source string is freed, and error checking is performed. The function returns a GLuint value that can be used to refer to the shader object.

Once a shader has been compiled, it should then be attached to a program object. A program object can be created with the <strong>glCreateProgram</strong> function. The shader.c file of the demo contains a function to easily compile a shader and attach it to a program object:

```c++
/*
 * Compiles and attaches a shader of the
 * given type to the given program object.
 */
void
shaderAttachFromFile(GLuint program, GLenum type, const char *filePath)
{
    /* compile the shader */
    GLuint shader = shaderCompileFromFile(type, filePath);
    if(shader != 0) {
        /* attach the shader to the program */
        glAttachShader(program, shader);

        /* delete the shader - it won't actually be
         * destroyed until the program that it's attached
         * to has been destroyed */
        glDeleteShader(shader);
    }
}
```

This function takes arguments containing the GLuint that represents the program object to attach the shader to, the type of the shader (such as <strong>GL_VERTEX_SHADER</strong> or <strong>GL_FRAGMENT_SHADER</strong>), and the path to the file containing the shader. It first calls the <strong>shaderCompileFromFile</strong> function that was described above in order to compile the shader; if the compilation is successful, it then attaches it to the program using the <strong>glAttachShader</strong> function and deletes the shader using the <strong>glDeleteShader</strong> function (as mentioned in a comment in the source code, the shader won't actually be destroyed until the program that it's attached to has been destroyed).

Once shaders have been attached to the program object, the program object can be linked using the <strong>glLinkProgram</strong> function. The <strong>sceneInit</strong> function in the demo contains the following code for creating a program object, attaching shaders, and linking the program:

```c++
void
sceneInit(void)
{
    GLint result;

    /* create program object and attach shaders */
    g_program = glCreateProgram();
    shaderAttachFromFile(g_program, GL_VERTEX_SHADER, "data/shader.vp");
    shaderAttachFromFile(g_program, GL_FRAGMENT_SHADER, "data/shader.fp");

    /* link the program and make sure that there were no errors */
    glLinkProgram(g_program);
    glGetProgramiv(g_program, GL_LINK_STATUS, &result);
    if(result == GL_FALSE) {
        GLint length;
        char *log;

        /* get the program info log */
        glGetProgramiv(g_program, GL_INFO_LOG_LENGTH, &length);
        log = malloc(length);
        glGetProgramInfoLog(g_program, length, &result, log);

        /* print an error message and the info log */
        fprintf(stderr, "sceneInit(): Program linking failed: %s\n", log);
        free(log);

        /* delete the program */
        glDeleteProgram(g_program);
        g_program = 0;
    }
```

After the program has been linked, the <strong>glGetUniformLocation</strong> function is used to retrieve the locations of some uniform variables that are defined in the shaders:

```c++
​    /* get uniform locations */
    g_programCameraPositionLocation = glGetUniformLocation(g_program, "cameraPosition");
    g_programLightPositionLocation = glGetUniformLocation(g_program, "lightPosition");
    g_programLightColorLocation = glGetUniformLocation(g_program, "lightColor");

    /* set up red/green/blue lights */
    g_lightColor[0] = 1.0f; g_lightColor[1] = 0.0f; g_lightColor[2] = 0.0f;
    g_lightColor[3] = 0.0f; g_lightColor[4] = 1.0f; g_lightColor[5] = 0.0f;
    g_lightColor[6] = 0.0f; g_lightColor[7] = 0.0f; g_lightColor[8] = 1.0f;

    ...
}
```

As we will see later, these uniform variable locations will allow us to pass information to the shaders - namely the camera position and the position/color information of three lights. <strong>g_lightColor</strong> is a float array, the contents of which will be passed to the program object when we use it later. The <strong>sceneInit</strong> function then performs some other initialization tasks that are not important to our discussion of shaders.

    <h2>Vertex Shader</h2>

Now that we know how to compile shaders and link them using program objects, let's take a look at some shaders, beginning with <strong>shader.vp</strong>, the vertex shader that is included with the demo accompanying this article. GLSL has a C-like syntax that you should find familiar. The vertex shader begins with the following lines:

```c++
const int NUM_LIGHTS = 3;

uniform vec3 cameraPosition;
uniform vec3 lightPosition[NUM_LIGHTS];

varying vec3 fragmentNormal;
varying vec3 cameraVector;
varying vec3 lightVector[NUM_LIGHTS];
```

<strong>NUM_LIGHTS</strong> is simply a constant indicating the number of lights that will be used in the demo; this constant will make it easy to change the number of lights, if necessary.

Next, we see some of the uniform variables that were mentioned earlier. These variables contain information passed from the OpenGL application to the shaders - in this case, the camera (or eye) position of the viewer and an array containing the position of each light. Uniform variables should be set by the OpenGL application before it starts drawing with the program object enabled - we will see how to do this towards the end of the article. Note the <strong>vec3</strong> variable type, which is used to define a three component vector.

The next three lines define some <strong>varying</strong> values. These are variables that are set by the vertex shader and can then be accessed by the fragment shader; the values are interpolated across the surface being rendered, similarly to how colors and texture coordinates are interpolated across surfaces in OpenGL. These values will be used by the fragment shader to perform lighting calculations.

The <strong>main</strong> function of the shader, which contains the actual shader code that is executed for each vertex, is shown below:

```c++
void
main()
{
    // set the normal for the fragment shader and
    // the vector from the vertex to the camera
    fragmentNormal = gl_Normal;
    cameraVector = cameraPosition - gl_Vertex.xyz;

    // set the vectors from the vertex to each light
    for(int i = 0; i < NUM_LIGHTS; ++i)
        lightVector[i] = lightPosition[i] - gl_Vertex.xyz;

    // output the transformed vertex
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
```

The first thing the shader does is pass the vertex normal to the fragment shader through the <strong>fragmentNormal</strong> variable; because this variable was defined as a varying value, its value will be interpolated across the surface being rendered. The built-in <strong>gl_Normal</strong> variable can be used in vertex shaders to access the normal of the vertex (the demo uses the <strong>glNormalPointer</strong> function to supply normal data).

Next, the <strong>cameraVector</strong> variable is set to contain a vector pointing to the camera position from the current vertex. A similar operation is done to fill the <strong>lightVector</strong> array with vectors pointing to each light from the current vertex. The built-in <strong>gl_Vertex</strong> variable contains the non-transformed position of the current vertex (the demo uses the <strong>glVertexPointer</strong> function to supply the vertex position data).

Finally, we set the built-in <strong>gl_Position</strong> variable, which contains the final transformed position of the vertex that should be drawn. We transform the <strong>gl_Vertex</strong> vector by the built-in <strong>gl_ModelViewProjectionMatrix</strong> matrix (which is simply the product of the current projection and model view matrices) to get this value.

    <h2>Fragment Shader</h2>

Let's now move on to <strong>shader.fp</strong>, the fragment shader included with the demo. This shader's job is to calculate diffuse and specular lighting values for each fragment (or pixel) that is drawn while the program object is enabled. This shader begins by defining several constants:

```c++
const int NUM_LIGHTS = 3;
const vec3 AMBIENT = vec3(0.1, 0.1, 0.1);
const float MAX_DIST = 2.5;
const float MAX_DIST_SQUARED = MAX_DIST * MAX_DIST;
```

<strong>NUM_LIGHTS</strong> is once again simply the number of lights that we have. <strong>AMBIENT</strong> defines the ambient lighting value, which is the color of a fragment that has no diffuse or specular lighting contribution from any of the three lights. <strong>MAX_DIST</strong> and <strong>MAX_DIST_SQUARED</strong> are used to attenuate the lighting for fragments as their distances from the lights increase.

Next, we have a uniform and some varyings:

```c++
uniform vec3 lightColor[NUM_LIGHTS];

varying vec3 fragmentNormal;
varying vec3 cameraVector;
varying vec3 lightVector[NUM_LIGHTS];
```

<strong>lightColor</strong> contains the light color values passed in by the demo application; the X, Y, and Z components of these <strong>vec3</strong> values correspond to the red, green, and blue components of the light colors, respectively. The varyings were set in the vertex shader and their values have been interpolated across the surface being rendered so that they can be used in the fragment shader; <strong>fragmentNormal</strong> is now the normal of the current fragment, <strong>cameraVector</strong> is a vector pointing to the camera from the current fragment, and the <strong>lightVector</strong> array contains vectors pointing in the direction of each light from the current fragment.

The <strong>main</strong> function, which is executed for each fragment drawn, begins with the following lines of code:

```c++
void
main()
{
    // initialize diffuse/specular lighting
    vec3 diffuse = vec3(0.0, 0.0, 0.0);
    vec3 specular = vec3(0.0, 0.0, 0.0);

    // normalize the fragment normal and camera direction
    vec3 normal = normalize(fragmentNormal);
    vec3 cameraDir = normalize(cameraVector);
```

We first initialize the overall diffuse/specular values for the current fragment; the diffuse/specular values that we calculate for each individual light will be added to these vectors. Next, we normalize the normal that was passed in from the vertex shader using the built-in <strong>normalize</strong> function; this is done because <strong>fragmentNormal</strong> has been interpolated and is thus not an accurate normal. We also normalize <strong>cameraVector</strong> to get a unit direction vector pointing to the camera.

We then start calculating the lighting contribution from each light:

```c++
​    // loop through each light
    for(int i = 0; i < NUM_LIGHTS; ++i) {
        // calculate distance between 0.0 and 1.0
        float dist = min(dot(lightVector[i], lightVector[i]), MAX_DIST_SQUARED) / MAX_DIST_SQUARED;
        float distFactor = 1.0 - dist;
```

The <strong>MAX_DIST_SQUARED</strong> constant contains the squared maximum distance that a fragment can be from a light in order to be affected by it. We see two built-in GLSL functions here: <strong>dot</strong> returns the dot product of the given vectors, and <strong>min</strong> returns the minimum value passed to it. <strong>dist</strong> will end up being a value from 0.0 to 1.0 and <strong>distFactor</strong> will be the inverse. If the distance between the current fragment and the light is small, <strong>distFactor</strong> will be close to 1.0 (full lighting contribution); if the distance between the current fragment and the light is greater than or equal to <strong>MAX_DIST_SQUARED</strong>, <strong>distFactor</strong> will be 0.0 (no lighting contribution).

Next, we calculate the diffuse lighting contribution from the current light:

```c++
​        // diffuse
        vec3 lightDir = normalize(lightVector[i]);
        float diffuseDot = dot(normal, lightDir);
        diffuse += lightColor[i] * clamp(diffuseDot, 0.0, 1.0) * distFactor;
```

The vector to the current light from the current fragment is normalized and stored in <strong>lightDir</strong> to give us a normalized direction vector to the light. The dot product between the fragment normal and <strong>lightDir</strong> is then calculated and stored in the <strong>diffuseDot</strong> variable. If the two vectors are pointing in exactly the same direction, the dot product will be 1.0, giving the full diffuse lighting value; as the angle between the vectors increases, the dot product decreases, and if they're facing opposite directions, the dot product will be negative (in this case, the current fragment is not lit by the current light). Once we have the dot product, we use it to compute the diffuse contribution from the light and add it to the overall <strong>diffuse</strong> vector; note that we use the built-in <strong>clamp</strong> function to make sure that we don't subtract from the diffuse vector when the dot product is negative.

We then calculate the specular lighting contribution from the current light, which will give objects drawn a shiny appearance:

```c++
​        // specular
        vec3 halfAngle = normalize(cameraDir + lightDir);
        vec3 specularColor = min(lightColor[i] + 0.5, 1.0);
        float specularDot = dot(normal, halfAngle);
        specular += specularColor * pow(clamp(specularDot, 0.0, 1.0), 16.0) * distFactor;
    }
```

<strong>halfAngle</strong> contains the normalized direction vector that is halfway between the direction to the camera and the direction to the current light. The specular lighting contribution is calculated similarly to how the diffuse lighting was, but we will compare the fragment normal to <strong>halfAngle</strong> instead of to the direction vector to the light itself. To visualize how this works, look at the figure below:

    <img src="figure1.png" alt="Figure 1" />

The red sphere represents an object being lit by a single light, and the point where the red, green, and blue lines meet represents a single fragment. The red line represents the normalized direction vector to the light and the blue line represents the normalized direction vector to the camera. If these two vectors are added together, the result is the green line that reaches to the top right of the box with the gray outline; if this vector is then normalized, the result is the half-angle vector. In the figure, this half-angle vector is also exactly the same as the fragment normal, so full specular lighting would be applied to the fragment. This makes sense, as the light and camera direction vectors are at a 90 degree angle to eachother and the fragment normal appears to be at a 45 degree angle.

After calculating the half-angle vector, we add 0.5 to each component of the light's color to make the specular lighting appear brighter. Note that we can add the scalar 0.5 to the vector using the standard addition operator; the result is the vector with 0.5 added to each component. We also use the <strong>min</strong> function to make sure that no color component is above 1.0 after the addition.

We calculate the specular lighting contribution of the light and add it to the overall <strong>specular</strong> value in a manner similar to how we did the diffuse lighting, but the clamped <strong>specularDot</strong> value is raised to a certain power, in this case 16.0. A higher exponent will give the specular lighting a narrower, more focused appearance.

Finally, we output the final fragment color:

```c++
​    vec4 sample = vec4(1.0, 1.0, 1.0, 1.0);
    gl_FragColor = vec4(clamp(sample.rgb * (diffuse + AMBIENT) + specular, 0.0, 1.0), sample.a);
}
```

<strong>sample</strong> is a <strong>vec4</strong> variable representing the natural color of the fragment, which is white in this case (the fourth component of the vector represents the alpha value). We combine <strong>sample</strong>, <strong>diffuse</strong>, <strong>AMBIENT</strong>, and <strong>specular</strong> to generate our final fragment color, which we assign to the built-in <strong>gl_FragColor</strong> variable, and the fragment shader is complete.

    <h2>Using the Shaders</h2>

Now that we have vertex/fragment shaders and know how to compile/link them, we can use them when rendering objects. Rendering is done by the <strong>sceneRender</strong> function in the demo:

```c++
void
sceneRender(void)
{
    int i;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    /* enable program and set uniform variables */
    glUseProgram(g_program);
    glUniform3fvARB(g_programCameraPositionLocation, 1, g_cameraPosition);
    glUniform3fvARB(g_programLightPositionLocation, NUM_LIGHTS, g_lightPosition);
    glUniform3fvARB(g_programLightColorLocation, NUM_LIGHTS, g_lightColor);

    /* render the cylinder */
    glDrawArrays(GL_TRIANGLE_STRIP, 0, g_cylinderNumVertices);

    /* disable program */
    glUseProgram(0);
```

After clearing the color and depth buffers, we call <strong>glUseProgram</strong> to use the program object that our shaders are attached to. We then set some uniform variables in the shaders using the <strong>glUniform3fv</strong> function, which allows us to set <strong>vec3</strong> uniforms. For each uniform, we pass in the location of the uniform (which we obtained after linking the program object), the number of vectors at that location (which will be greater than 1 for arrays), and a pointer to an array of floats containing the vector data. The <strong>g_cameraPosition</strong> and <strong>g_lightColor</strong> values were initialized in the <strong>sceneInit</strong> function, while the <strong>g_lightPosition</strong> values are changed continuously by the <strong>sceneCycle</strong> function contained in the demo.

Once the program has been enabled and its uniforms have been set, the <strong>glDrawArrays</strong> function is called to render a cylinder using vertex/normal data that was generated during scene initialization. The program is then disabled by passing a value of 0 to the <strong>glUseProgram</strong> function.

Finally, we just render some spheres to represent the lights, call <strong>glutSwapBuffers</strong>, and we're done:

```c++
​    /* render each light */
    for(i = 0; i < NUM_LIGHTS; ++i) {
        /* render sphere with the light's color/position */
        glPushMatrix();
        glTranslatef(g_lightPosition[i * 3 + 0], g_lightPosition[i * 3 + 1], g_lightPosition[i * 3 + 2]);
        glColor3fv(g_lightColor + (i * 3));
        glutSolidSphere(0.04, 36, 36);
        glPopMatrix();
    }

    glutSwapBuffers();
}
```

A screenshot of the demo program can be seen below:

    <img src="glsl_lighting.png" alt="Demo Screenshot" />

The full C source code for the demo can be found <a href="https://github.com/joshb/glsl_lighting">on GitHub</a>. It requires GLUT in addition to an OpenGL implementation with GLSL support. The source code is provided under a BSD-style license, so feel free to use any portions of it in your own projects.
