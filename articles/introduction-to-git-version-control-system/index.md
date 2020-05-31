---
layout: post
title: Introduction to the Git Version Control System
date: 2020-05-30
---

This article provides an introduction to the [Git](https://git-scm.com/) version control system, guiding you through the process of creating a new Git repository and making commits. Basic version control concepts and terminology are explained along the way.

In order to make the best use of this article, make sure that you already have Git installed. If you're using a Mac, Git comes with [Xcode](https://developer.apple.com/xcode/). If you need to install Git on another platform, visit the [official Git website](https://git-scm.com/).

## Git Overview

Git is a free and open source *Version Control System* (or VCS). Version control systems are frequently used in the software development industry in order to track changes to code and improve collaboration between developers.

Git is currently the most widely used version control system. It is available on all major development platforms (including Windows, macOS, and Linux), and is integrated into development tools from major software vendors such as Microsoft and Apple. While you can access Git functionality in development environments like Visual Studio and Xcode, it is more powerful when used from the command line, as we will be doing in this article.

## Creating a Repository

The first thing that we're going to do is create a new directory and initialize an empty Git repository inside of it. You can think of a repository as a directory for which Git will track changes to the files inside of it; the terms "repository" and "project" are sometimes used interchangeably, since software developers will typically include all source files and related assets to a project in a repository.

We're going to be working from the command line, so open up your terminal application of choice and enter the following commands (note that the `$` symbol represents the command prompt and does not need to be typed, while the lines that do not begin with `$` symbols represent the output of commands):

```
$ mkdir git-intro
$ cd git-intro
$ git init
Initialized empty Git repository in /Users/jab/git-intro/.git/
```

A command that you're going to want to use frequently when working with Git is `git status`. This will show you information about uncommitted changes that are present, such as files that have been created, deleted, or modified. If you run `git status` at this point, you should see that there is nothing to commit, because you have not created any files in the directory yet.

## Making Your First Commit

You can think of a *commit* as a snapshot of the files in your repository at a point in time. You can refer back to previous commits and compare them in order to track changes that have been made to your project, or get things back to a working state when you accidentally delete or break something.

Before we commit anything, some configuration may be necessary if you haven't used Git on your current system yet. Enter the following commands to set the name and email address that Git should attach to your commits (replace `<your name>` and `<your email>` with your actual name and email address):

```
$ git config --global user.name "<your name>"
$ git config --global user.email "<your email>"
```

The `--global` option in the above commands means that the settings will apply to all Git repositories that you work with.

Now let's create a simple HTML file to add to the repository. Add the following to a new file in your text editor of choice, and save it to your `git-intro` directory as `index.html`:

```html
<!DOCTYPE html>
<html>
<body>

Hello, world!

</body>
</html>
```

Run `git status` and it should tell you that there is a new untracked file (meaning that the repository has no record of it yet). Now use the `git add` command to tell Git to add the file to the repository and track it:

```
$ git add index.html
```

`git status` will now show that you have changes to be committed. We can use the `git commit` command to create the initial commit (the `-m` option allows a short message describing the commit to be given on the command line):

```
$ git commit -m "Initial commit"
[master (root-commit) a2af454] Initial commit
 1 file changed, 7 insertions(+)
 create mode 100644 index.html
```

The `git log` command can be used to see a listing of commits that have been made:

```
$ git log
commit a2af454d421d6d226533f0e84ecb702767bf2af1 (HEAD -> master)
Author: Josh Beam <josh@joshbeam.com>
Date:   Sat May 30 00:25:20 2020 -0400

    Initial commit
```

The long hexadecimal string that you see above is the *commit hash*, which is a SHA-1 checksum based on the repository's content at the time of the commit. If you don't know what that means, don't worry about it - just think of the commit hash as a unique identifier for the commit.

## Creating a New Branch

One of the most powerful features of Git is its *branching* capability. A Git repository's commit history can be thought of as a tree data structure where each node represents a commit. The first commit is the root node in the tree, and each subsequent commit has at least one parent commit (typically the previous commit that you made). With branches, you can have multiple parallel commit histories that do not affect each other. Branches can be merged together, in which case Git will make a best attempt at combining the edits made in each branch into a *merge commit* that has the latest commit from each branch as parents.

When you create a new Git repository, the initial branch is called `master`. Typically, the master branch is used to contain the latest stable, mainline version of a project, and new features or bug fixes are implemented in *topic branches*, with names that describe the features that will be implemented or the bugs that will be fixed.

The `git checkout` command is used to *check out* (or switch to) another branch. The `-b` option will create a new branch if one with the given name doesn't exist yet. Let's say that we want to add a stylesheet and include it in our HTML file; enter the following command to create a new branch called `add-stylesheet`:

```
$ git checkout -b add-stylesheet
Switched to a new branch 'add-stylesheet'
```

Open your text editor, create a new file with the following CSS definitions, and save it to your `git-intro` directory as `stylesheet.css`:

```css
body {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10pt;
}
```

Now open your `index.html` file and add the following `<head>` section after the opening `<html>` tag:

```html
<head>
    <link rel="stylesheet" href="stylesheet.css">
</head>
```

Let's add the updated files and commit them:

```
$ git add index.html stylesheet.css
$ git commit -m "Add stylesheet."
[add-stylesheet e397766] Add stylesheet.
 2 files changed, 7 insertions(+)
 create mode 100644 stylesheet.css
```

Another useful command that you'll want to use frequently is `git diff`, which shows the differences in your repository's files between two commits (or between the last commit and the current uncommitted changes, if no commits are specified). Enter the following command to see the difference between the previous commit and the latest one (`HEAD` refers to the latest commit of the current branch, and `HEAD^` refers to the previous commit):

```diff
$ git diff HEAD^ HEAD
diff --git a/index.html b/index.html
index cd7399e..2ce7fba 100644
--- a/index.html
+++ b/index.html
@@ -1,5 +1,8 @@
 <!DOCTYPE html>
 <html>
+<head>
+    <link rel="stylesheet" href="stylesheet.css">
+</head>
 <body>
 
 <p>Hello, world!</p>
diff --git a/stylesheet.css b/stylesheet.css
new file mode 100644
index 0000000..c846e64
--- /dev/null
+++ b/stylesheet.css
@@ -0,0 +1,4 @@
+body {
+    font-family: Arial, Helvetica, sans-serif;
+    font-size: 10pt;
+}
```

The above diff shows the new lines that were added to `index.html`, and the entire contents of the new `stylesheet.css` file.

## Merging Branches

Let's now switch back to the master branch and take a look at the directory's contents:

```
$ git checkout master
Switched to branch 'master'
$ ls
index.html
$ cat index.html
<!DOCTYPE html>
<html>
<body>

Hello, world!

</body>
</html>
```

If this isn't what you were expecting to see, don't be alarmed - your latest changes are still contained in the `add-stylesheet` branch. They just aren't in the `master` branch yet, so you don't see them now that you've switched back to `master`.

Let's make another quick change to the `index.html` file - add a `<p>` tag to the "Hello, world!" line so that it looks like this:

```html
<p>Hello, world!</p>
```

Commit the change (the `-a` option enables us to quickly commit changes to a file that was previously added to the repository without having to explicitly use `git add` again):

```
$ git commit -am "Add p tag."
[master aceb638] Add p tag.
 1 file changed, 1 insertion(+), 1 deletion(-)
```

Now let's merge in the changes from the `add-stylesheet` branch using the `git merge` command:

```
$ git merge add-stylesheet
Merge made by the 'recursive' strategy.
 index.html     | 3 +++
 stylesheet.css | 4 ++++
 2 files changed, 7 insertions(+)
 create mode 100644 stylesheet.css
```

You may see your default text editor appear with a pre-populated commit message for the merge commit. You can change the commit message if you want, or you can just exit out of the editor without making any changes.

Let's take a look again at the directory's contents:

```
$ ls
index.html     stylesheet.css
$ cat index.html
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="stylesheet.css">
</head>
<body>

<p>Hello, world!</p>

</body>
</html>
```

It should be noted that, before now, there was no version of your `index.html` file that looked exactly like the one above. In the `master` branch, it previously had the `<p>` tag, but no reference to the stylesheet. In the `add-stylesheet` branch, it had the stylesheet, but no `<p>` tag. Because the changes in the `add-stylesheet` branch affected different lines of the file than the latest commit in the `master` branch, Git was able to merge each version of the file into a new one that incorporates all changes that were made.

Finally, run `git log` to see details about the merged commit history. The first commit listed will be the merge commit:

```
$ git log
commit 7ce3e3267d96861451abdbf0527e5d4694bb438f (HEAD -> master)
Merge: aceb638 e397766
Author: Josh Beam <josh@joshbeam.com>
Date:   Sat May 30 17:23:40 2020 -0400

    Merge branch 'add-stylesheet'

...
```

Notice the `Merge: aceb638 e397766` line above, which includes shortened versions of the hashes identifying the commits that were merged together. These are the two parent commits of the merge commit.

## Further Reading

I hope that this article has helped you get started using Git. If you want to learn more about Git, there is plenty of documentation available online, including on the [Git website](https://git-scm.com/doc). If you have any questions or feedback, feel free to [email me](mailto:josh@joshbeam.com).
