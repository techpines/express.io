# express.io
realtime-web framework for node.js

```coffeescript
express.io = express + socket.io
```

## Simple App Setup

Here is the canonical express.io example.

```javascript
app = require('express.io')()
app.http().io()

//build your realtime-web app

app.listen(7076)
```

## Upgrade your existing Express apps

First install:

```bash
npm install express.io
```

Then, simply replace this line of code

```javascript
require('express')
```

with this line of code

```javascript
require('express.io')
```

Your app should run just the same as before.  Express.io is a superset of express and socket.io!


## Examples

[Tons of Working Examples](somewhere)

## API Reference

[API Reference](ref)

## FAQ

Have frequent questions, we have frequent answers.

[Bring me FAQ](toad)

## Contrib Shout Out

Hey this thing is open source, so give a contrib shout out.

[Fork]() this bad boy, edit the `CONTRIB` file with your github handle and a short message, then make a pull request.

```twitter
@techpines - woot!
+ @saladfingers - i like express.io bro
```

## License
It's free! Party with the MIT!

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
