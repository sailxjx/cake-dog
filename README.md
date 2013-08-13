# Cake Dog

A little dog help you to watch, compile your coffee files

# Install

```
npm install cake-dog
```

# Usage

npm will automatically prepend one line in your [`Cakefile`](http://coffeescript.org/documentation/docs/cake.html)

```
require("cake-dog")
```

Now use `cake` command to see new tasks

```
$ cake
Cakefile defines the following tasks:

cake watch                # real-time compile coffee scripts to javascript files
cake stop                 # stop compile coffee scripts to javascript files
cake generate             # once compile coffee scripts to javascript files

```

# Uninstall

```
npm rm cake-dog
```

Done!

# LICENSE

Copyright © 2013 Tristan Xu, http://sailxjx.github.io <sailxjx@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
