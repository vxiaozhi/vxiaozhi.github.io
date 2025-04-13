---
layout:     post
title:      "Js 协程简介"
subtitle:   "Js 协程简介"
date:       2025-04-13
author:     "vxiaozhi"
catalog: true
tags:
    - js
    - coroutine
---

这篇文章 [JavaScript Promise，async/await](https://zh.javascript.info/async) 是对 async/await 最详细的介绍，而且 文章开源：

- [现代 JavaScript 教程中文版](https://github.com/javascript-tutorial/zh.javascript.info)

## callback(回调)

回调地狱：

```
loadScript('1.js', function(error, script) {

  if (error) {
    handleError(error);
  } else {
    // ...
    loadScript('2.js', function(error, script) {
      if (error) {
        handleError(error);
      } else {
        // ...
        loadScript('3.js', function(error, script) {
          if (error) {
            handleError(error);
          } else {
            // ...加载完所有脚本后继续 (*)
          }
        });

      }
    });
  }
});
```

嵌套调用的“金字塔”随着每个异步行为会向右增长。很快它就失控了。

所以这种编码方式不是很好。

我们可以通过使每个行为都成为一个独立的函数来尝试减轻这种问题，如下所示：

```
loadScript('1.js', step1);

function step1(error, script) {
  if (error) {
    handleError(error);
  } else {
    // ...
    loadScript('2.js', step2);
  }
}

function step2(error, script) {
  if (error) {
    handleError(error);
  } else {
    // ...
    loadScript('3.js', step3);
  }
}

function step3(error, script) {
  if (error) {
    handleError(error);
  } else {
    // ...加载完所有脚本后继续 (*)
  }
}

```

看到了吗？它的作用相同，但是没有深层的嵌套了，因为我们将每个行为都编写成了一个独立的顶层函数。

它可以工作，但是代码看起来就像是一个被撕裂的表格。你可能已经注意到了，它的可读性很差，在阅读时你需要在各个代码块之间跳转。这很不方便，特别是如果读者对代码不熟悉，他们甚至不知道应该跳转到什么地方。

此外，名为 step* 的函数都是一次性使用的，创建它们就是为了避免“厄运金字塔”。没有人会在行为链之外重用它们。因此，这里的命名空间有点混乱。

我们希望还有更好的方法。

幸运的是，有其他方法可以避免此类金字塔。最好的方法之一就是 “promise”.

## Promise

让我们看一下关于 promise 如何帮助我们编写异步代码的更多实际示例。

我们从上一章获得了用于加载脚本的 loadScript 函数。

这是基于回调函数的变体，记住它：

```
function loadScript(src, callback) {
  let script = document.createElement('script');
  script.src = src;

  script.onload = () => callback(null, script);
  script.onerror = () => callback(new Error(`Script load error for ${src}`));

  document.head.append(script);
}
```

让我们用 promise 重写它。

新函数 loadScript 将不需要回调。取而代之的是，它将创建并返回一个在加载完成时 resolve 的 promise 对象。外部代码可以使用 .then 向其添加处理程序（订阅函数）：

```
function loadScript(src) {
  return new Promise(function(resolve, reject) {
    let script = document.createElement('script');
    script.src = src;

    script.onload = () => resolve(script);
    script.onerror = () => reject(new Error(`Script load error for ${src}`));

    document.head.append(script);
  });
}
```

用法：

```
let promise = loadScript("https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.11/lodash.js");

promise.then(
  script => alert(`${script.src} is loaded!`),
  error => alert(`Error: ${error.message}`)
);

promise.then(script => alert('Another handler...'));
```

我们立刻就能发现 promise 相较于基于回调的模式的一些好处：

- promise 允许我们按照自然顺序进行编码。首先，我们运行 loadScript，之后，用 .then 来处理结果。 callback:在调用 loadScript(script, callback) 时，我们必须有一个 callback 函数可供使用。换句话说，在调用 loadScript 之前，我们必须知道如何处理结果。
- promise:我们可以根据需要，在 promise 上多次调用 .then。每次调用，我们都会在“订阅列表”中添加一个新的“粉丝”，一个新的订阅函数。callback: 只能有一个回调。

因此，promise 为我们提供了更好的代码流和灵活性。

## Promise 链

我们有一系列的异步任务要一个接一个地执行 —— 例如，加载脚本。我们如何写出更好的代码呢？

Promise 提供了一些方案来做到这一点。

在本章中，我们将一起学习 promise 链。

它看起来就像这样：

```
new Promise(function(resolve, reject) {

  setTimeout(() => resolve(1), 1000); // (*)

}).then(function(result) { // (**)

  alert(result); // 1
  return result * 2;

}).then(function(result) { // (***)

  alert(result); // 2
  return result * 2;

}).then(function(result) {

  alert(result); // 4
  return result * 2;

});
```

它的想法是通过 .then 处理程序（handler）链进行传递 result。

运行流程如下：

- 初始 promise 在 1 秒后 resolve (*)，
- 然后 .then 处理程序被调用 (**)，它又创建了一个新的 promise（以 2 作为值 resolve）。
- 下一个 then (***) 得到了前一个 then 的值，对该值进行处理（*2）并将其传递给下一个处理程序。
- ……依此类推。
  
**更复杂的示例：fetch**

在前端编程中，promise 通常被用于网络请求。那么，让我们一起来看一个相关的扩展示例吧。

我们将使用 fetch 方法从远程服务器加载用户信息。它有很多可选的参数，我们在 单独的一章 中对其进行了详细介绍，但基本语法很简单：

```
let promise = fetch(url);
```

执行这条语句，向 url 发出网络请求并返回一个 promise。当远程服务器返回 header（是在 全部响应加载完成前）时，该 promise 使用一个 response 对象来进行 resolve。

为了读取完整的响应，我们应该调用 response.text() 方法：当全部文字内容从远程服务器下载完成后，它会返回一个 promise，该 promise 以刚刚下载完成的这个文本作为 result 进行 resolve。

下面这段代码向 user.json 发送请求，并从服务器加载该文本：

```
fetch('/article/promise-chaining/user.json')
  // 当远程服务器响应时，下面的 .then 开始执行
  .then(function(response) {
    // 当 user.json 加载完成时，response.text() 会返回一个新的 promise
    // 该 promise 以加载的 user.json 为 result 进行 resolve
    return response.text();
  })
  .then(function(text) {
    // ……这是远程文件的内容
    alert(text); // {"name": "iliakan", "isAdmin": true}
  });
```

从 fetch 返回的 response 对象还包含 response.json() 方法，该方法可以读取远程数据并将其解析为 JSON。在我们的例子中，这更加方便，所以我们用这个方法吧。

为了简洁，我们还将使用箭头函数：

```
// 同上，但使用 response.json() 将远程内容解析为 JSON
fetch('/article/promise-chaining/user.json')
  .then(response => response.json())
  .then(user => alert(user.name)); // iliakan，获取到了用户名
```

现在，让我们用加载好的用户信息搞点事情。

例如，我们可以再向 GitHub 发送一个请求，加载用户个人资料并显示头像：

```
// 发送一个对 user.json 的请求
fetch('/article/promise-chaining/user.json')
  // 将其加载为 JSON
  .then(response => response.json())
  // 发送一个到 GitHub 的请求
  .then(user => fetch(`https://api.github.com/users/${user.name}`))
  // 将响应加载为 JSON
  .then(response => response.json())
  // 显示头像图片（githubUser.avatar_url）3 秒（也可以加上动画效果）
  .then(githubUser => {
    let img = document.createElement('img');
    img.src = githubUser.avatar_url;
    img.className = "promise-avatar-example";
    document.body.append(img);

    setTimeout(() => img.remove(), 3000); // (*)
  });

```

这段代码可以工作，具体细节请看注释。但是，这有一个潜在的问题，一个新手使用 promise 时的典型问题。

请看 (*) 行：我们如何能在头像显示结束并被移除 之后 做点什么？例如，我们想显示一个用于编辑该用户或者其他内容的表单。就目前而言，是做不到的。

为了使链可扩展，我们需要返回一个在头像显示结束时进行 resolve 的 promise。

就像这样：

```
fetch('/article/promise-chaining/user.json')
  .then(response => response.json())
  .then(user => fetch(`https://api.github.com/users/${user.name}`))
  .then(response => response.json())
  .then(githubUser => new Promise(function(resolve, reject) { // (*)
    let img = document.createElement('img');
    img.src = githubUser.avatar_url;
    img.className = "promise-avatar-example";
    document.body.append(img);

    setTimeout(() => {
      img.remove();
      resolve(githubUser); // (**)
    }, 3000);
  }))
  // 3 秒后触发
  .then(githubUser => alert(`Finished showing ${githubUser.name}`));
```

也就是说，第 (*) 行的 .then 处理程序现在返回一个 new Promise，只有在 setTimeout 中的 resolve(githubUser) (**) 被调用后才会变为 settled。链中的下一个 .then 将一直等待这一时刻的到来。

作为一个好的做法，异步行为应该始终返回一个 promise。这样就可以使得之后我们计划后续的行为成为可能。即使我们现在不打算对链进行扩展，但我们之后可能会需要。

最后，我们可以将代码拆分为可重用的函数：

```
function loadJson(url) {
  return fetch(url)
    .then(response => response.json());
}

function loadGithubUser(name) {
  return loadJson(`https://api.github.com/users/${name}`);
}

function showAvatar(githubUser) {
  return new Promise(function(resolve, reject) {
    let img = document.createElement('img');
    img.src = githubUser.avatar_url;
    img.className = "promise-avatar-example";
    document.body.append(img);

    setTimeout(() => {
      img.remove();
      resolve(githubUser);
    }, 3000);
  });
}

// 使用它们：
loadJson('/article/promise-chaining/user.json')
  .then(user => loadGithubUser(user.name))
  .then(showAvatar)
  .then(githubUser => alert(`Finished showing ${githubUser.name}`));
  // ...
```

**总结**

如果 .then（或 catch/finally 都可以）处理程序返回一个 promise，那么链的其余部分将会等待，直到它状态变为 settled。当它被 settled 后，其 result（或 error）将被进一步传递下去。

## 使用 promise 进行错误处理

todo

**总结**

- .catch 处理 promise 中的各种 error：在 reject() 调用中的，或者在处理程序中抛出的 error。
- 如果给定 .then 的第二个参数（即 error 处理程序），那么 .then 也会以相同的方式捕获 error。
- 我们应该将 .catch 准确地放到我们想要处理 error，并知道如何处理这些 error 的地方。处理程序应该分析 error（可以自定义 error 类来帮助分析）并再次抛出未知的 error（它们可能是编程错误）。
- 如果没有办法从 error 中恢复，不使用 .catch 也可以。
- 在任何情况下我们都应该有 unhandledrejection 事件处理程序（用于浏览器，以及其他环境的模拟），以跟踪未处理的 error 并告知用户（可能还有我们的服务器）有关信息，以使我们的应用程序永远不会“死掉”。

## Promise API

Promise 类有 6 种静态方法：

- Promise.all  并行执行多个 promise，并等待所有 promise 都准备就绪。
- Promise.allSettled Promise.allSettled 等待所有的 promise 都被 settle，无论结果如何。
- Promise.race 与 Promise.all 类似，但只等待第一个 settled 的 promise 并获取其结果（或 error）。
- Promise.any 与 Promise.race 类似，区别在于 Promise.any 只等待第一个 fulfilled 的 promise，并将这个 fulfilled 的 promise 返回。如果给出的 promise 都 rejected，那么返回的 promise 会带有 AggregateError —— 一个特殊的 error 对象，在其 errors 属性中存储着所有 promise error。
- Promise.resolve/reject 现代的代码中，很少需要使用 Promise.resolve 和 Promise.reject 方法，因为 async/await 语法（我们会在 稍后 讲到）使它们变得有些过时了。

## Promisification

对于一个简单的转换来说 “Promisification” 是一个长单词。它指将一个接受回调的函数转换为一个返回 promise 的函数。

由于许多函数和库都是基于回调的，因此，在实际开发中经常会需要进行这种转换。因为使用 promise 更加方便，所以将基于回调的函数和库 promise 化是有意义的。

为了更好地理解，让我们来看一个例子。

例如，在 简介：回调 一章中我们有 loadScript(src, callback)。

```
function loadScript(src, callback) {
  let script = document.createElement('script');
  script.src = src;

  script.onload = () => callback(null, script);
  script.onerror = () => callback(new Error(`Script load error for ${src}`));

  document.head.append(script);
}

// 用法：
// loadScript('path/script.js', (err, script) => {...})
```

现在，让我们将其 promise 化吧。

我们将创建一个新的函数 loadScriptPromise(src)，与上面的函数作用相同（加载脚本），只是我们创建的这个函数会返回一个 promise 而不是使用回调。

换句话说，我们仅向它传入 src（没有 callback）并通过该函数的 return 获得一个 promise，当脚本加载成功时，该 promise 将以 script 为结果 resolve，否则将以出现的 error 为结果 reject。

代码实现如下：

```
let loadScriptPromise = function(src) {
  return new Promise((resolve, reject) => {
    loadScript(src, (err, script) => {
      if (err) reject(err);
      else resolve(script);
    });
  });
};

// 用法：
// loadScriptPromise('path/script.js').then(...)
```

在实际开发中，我们可能需要 promise 化很多函数，所以使用一个 helper（辅助函数）很有意义。

我们将其称为 promisify(f)：它接受一个需要被 promise 化的函数 f，并返回一个包装（wrapper）函数。

```
function promisify(f) {
  return function (...args) { // 返回一个包装函数（wrapper-function） (*)
    return new Promise((resolve, reject) => {
      function callback(err, result) { // 我们对 f 的自定义的回调 (**)
        if (err) {
          reject(err);
        } else {
          resolve(result);
        }
      }

      args.push(callback); // 将我们的自定义的回调附加到 f 参数（arguments）的末尾

      f.call(this, ...args); // 调用原始的函数
    });
  };
}

// 用法：
let loadScriptPromise = promisify(loadScript);
loadScriptPromise(...).then(...);
```

但是如果原始的 f 期望一个带有更多参数的回调 callback(err, res1, res2, ...)，该怎么办呢？

我们可以继续改进我们的辅助函数。让我们写一个更高阶版本的 promisify。

- 当它被以 promisify(f) 的形式调用时，它应该以与上面那个版本的实现的工作方式类似。
- 当它被以 promisify(f, true) 的形式调用时，它应该返回以回调函数数组为结果 resolve 的 promise。这就是具有很多个参数的回调的结果。

```
// promisify(f, true) 来获取结果数组
function promisify(f, manyArgs = false) {
  return function (...args) {
    return new Promise((resolve, reject) => {
      function callback(err, ...results) { // 我们自定义的 f 的回调
        if (err) {
          reject(err);
        } else {
          // 如果 manyArgs 被指定，则使用所有回调的结果 resolve
          resolve(manyArgs ? results : results[0]);
        }
      }

      args.push(callback);

      f.call(this, ...args);
    });
  };
}

// 用法：
f = promisify(f, true);
f(...).then(arrayOfResults => ..., err => ...);
```

正如你所看到的，它与上面那个实现基本相同，只是根据 manyArgs 是否为真来决定仅使用一个还是所有参数调用 resolve。

对于一些更奇特的回调格式，例如根本没有 err 的格式：callback(result)，我们可以手动 promise 化这样的函数，而不使用 helper。

也有一些具有更灵活一点的 promisification 函数的模块（module），例如 es6-promisify。在 Node.js 中，有一个内建的 promise 化函数 util.promisify。

## 微任务（Microtask）

promise 的处理程序 .then、.catch 和 .finally 都是异步的。

即便一个 promise 立即被 resolve，.then、.catch 和 .finally 下面 的代码也会在这些处理程序之前被执行。

示例代码如下：

```
let promise = Promise.resolve();

promise.then(() => alert("promise done!"));

alert("code finished"); // 这个 alert 先显示
```

如果你运行它，你会首先看到 code finished，然后才是 promise done。

这很奇怪，因为这个 promise 肯定是一开始就完成的。

为什么 .then 会在之后才被触发？这是怎么回事？

**微任务队列（Microtask queue）**

异步任务需要适当的管理。为此，ECMA 标准规定了一个内部队列 PromiseJobs，通常被称为“微任务队列（microtask queue）”（V8 术语）。

如 规范 中所述：

队列（queue）是先进先出的：首先进入队列的任务会首先运行。
只有在 JavaScript 引擎中没有其它任务在运行时，才开始执行任务队列中的任务。
或者，简单地说，当一个 promise 准备就绪时，它的 .then/catch/finally 处理程序就会被放入队列中：但是它们不会立即被执行。当 JavaScript 引擎执行完当前的代码，它会从队列中获取任务并执行它。

这就是为什么在上面那个示例中 “code finished” 会先显示。

promise 的处理程序总是会经过这个内部队列。

如果有一个包含多个 .then/catch/finally 的链，那么它们中的每一个都是异步执行的。也就是说，它会首先进入队列，然后在当前代码执行完成并且先前排队的处理程序都完成时才会被执行。

**如果执行顺序对我们很重要该怎么办？我们怎么才能让 code finished 在 promise done 之后出现呢？**

很简单，只需要像下面这样使用 .then 将其放入队列：

```
Promise.resolve()
  .then(() => alert("promise done!"))
  .then(() => alert("code finished"));
```

现在代码就是按照预期执行的.

## async/await

async/await 是以更舒适的方式使用 promise 的一种特殊语法，同时它也非常易于理解和使用。

### async function

让我们以 `async` 这个关键字开始。它可以被放置在一个函数前面，如下所示：

```js
async function f() {
  return 1;
}
```

在函数前面的 "async" 这个单词表达了一个简单的事情：即这个函数总是返回一个 promise。其他值将自动被包装在一个 resolved 的 promise 中。

例如，下面这个函数返回一个结果为 `1` 的 resolved promise，让我们测试一下：

```js run
async function f() {
  return 1;
}

f().then(alert); // 1
```

……我们也可以显式地返回一个 promise，结果是一样的：

```js run
async function f() {
  return Promise.resolve(1);
}

f().then(alert); // 1
```

所以说，`async` 确保了函数返回一个 promise，也会将非 promise 的值包装进去。很简单，对吧？但不仅仅这些。还有另外一个叫 `await` 的关键词，它只在 `async` 函数内工作，也非常酷。

### await

语法如下：

```js
// 只在 async 函数内工作
let value = await promise;
```

关键字 `await` 让 JavaScript 引擎等待直到 promise 完成（settle）并返回结果。

这里的例子就是一个 1 秒后 resolve 的 promise：
```js run
async function f() {

  let promise = new Promise((resolve, reject) => {
    setTimeout(() => resolve("done!"), 1000)
  });

*!*
  let result = await promise; // 等待，直到 promise resolve (*)
*/!*

  alert(result); // "done!"
}

f();
```

这个函数在执行的时候，“暂停”在了 `(*)` 那一行，并在 promise settle 时，拿到 `result` 作为结果继续往下执行。所以上面这段代码在一秒后显示 "done!"。

让我们强调一下：`await` 实际上会暂停函数的执行，直到 promise 状态变为 settled，然后以 promise 的结果继续执行。这个行为不会耗费任何 CPU 资源，因为 JavaScript 引擎可以同时处理其他任务：执行其他脚本，处理事件等。

相比于 `promise.then`，它只是获取 promise 的结果的一个更优雅的语法。并且也更易于读写。

````warn header="不能在普通函数中使用 `await`"
如果我们尝试在非 async 函数中使用 `await`，则会报语法错误：

```js run
function f() {
  let promise = Promise.resolve(1);
*!*
  let result = await promise; // Syntax error
*/!*
}
```

如果我们忘记在函数前面写 `async` 关键字，我们可能会得到一个这个错误。就像前面说的，`await` 只在 `async` 函数中有效。
````

让我们拿 <info:promise-chaining> 那一章的 `showAvatar()` 例子，并将其改写成 `async/await` 的形式：

1. 我们需要用 `await` 替换掉 `.then` 的调用。
2. 另外，我们需要在函数前面加上 `async` 关键字，以使它们能工作。

```js run
async function showAvatar() {

  // 读取我们的 JSON
  let response = await fetch('/article/promise-chaining/user.json');
  let user = await response.json();

  // 读取 github 用户信息
  let githubResponse = await fetch(`https://api.github.com/users/${user.name}`);
  let githubUser = await githubResponse.json();

  // 显示头像
  let img = document.createElement('img');
  img.src = githubUser.avatar_url;
  img.className = "promise-avatar-example";
  document.body.append(img);

  // 等待 3 秒
  await new Promise((resolve, reject) => setTimeout(resolve, 3000));

  img.remove();

  return githubUser;
}

showAvatar();
```

简洁明了，是吧？比之前可强多了。

````smart header="现代浏览器在 modules 里允许顶层的 `await`"
在现代浏览器中，当我们处于一个 module 中时，那么在顶层使用 `await` 也是被允许的。我们将在 <info:modules-intro> 中详细学习 modules。

例如：

```js run module
// 我们假设此代码在 module 中的顶层运行
let response = await fetch('/article/promise-chaining/user.json');
let user = await response.json();

console.log(user);
```

如果我们没有使用 modules，或者必须兼容 [旧版本浏览器](https://caniuse.com/mdn-javascript_operators_await_top_level) ，那么这儿还有一个通用的方法：包装到匿名的异步函数中。

像这样：

```js
(async () => {
  let response = await fetch('/article/promise-chaining/user.json');
  let user = await response.json();
  ...
})();
```
````

````smart header="`await` 接受 \"thenables\""
像 `promise.then` 那样，`await` 允许我们使用 thenable 对象（那些具有可调用的 `then` 方法的对象）。这里的想法是，第三方对象可能不是一个 promise，但却是 promise 兼容的：如果这些对象支持 `.then`，那么就可以对它们使用 `await`。

这有一个用于演示的 `Thenable` 类，下面的 `await` 接受了该类的实例：

```js run
class Thenable {
  constructor(num) {
    this.num = num;
  }
  then(resolve, reject) {
    alert(resolve);
    // 1000ms 后使用 this.num*2 进行 resolve
    setTimeout(() => resolve(this.num * 2), 1000); // (*)
  }
}

async function f() {
  // 等待 1 秒，之后 result 变为 2
  let result = await new Thenable(1);
  alert(result);
}

f();
```

如果 `await` 接收了一个非 promise 的但是提供了 `.then` 方法的对象，它就会调用这个 `.then` 方法，并将内建的函数 `resolve` 和 `reject` 作为参数传入（就像它对待一个常规的 `Promise` executor 时一样）。然后 `await` 等待直到这两个函数中的某个被调用（在上面这个例子中发生在 `(*)` 行），然后使用得到的结果继续执行后续任务。
````

````smart header="Class 中的 async 方法"
要声明一个 class 中的 async 方法，只需在对应方法前面加上 `async` 即可：

```js run
class Waiter {
*!*
  async wait() {
*/!*
    return await Promise.resolve(1);
  }
}

new Waiter()
  .wait()
  .then(alert); // 1（alert 等同于 result => alert(result)）
```
这里的含义是一样的：它确保了方法的返回值是一个 promise 并且可以在方法中使用 `await`。

````
### Error 处理

如果一个 promise 正常 resolve，`await promise` 返回的就是其结果。但是如果 promise 被 reject，它将 throw 这个 error，就像在这一行有一个 `throw` 语句那样。

这个代码：

```js
async function f() {
*!*
  await Promise.reject(new Error("Whoops!"));
*/!*
}
```

……和下面是一样的：

```js
async function f() {
*!*
  throw new Error("Whoops!");
*/!*
}
```

在真实开发中，promise 可能需要一点时间后才 reject。在这种情况下，在 `await` 抛出（throw）一个 error 之前会有一个延时。

我们可以用 `try..catch` 来捕获上面提到的那个 error，与常规的 `throw` 使用的是一样的方式：

```js run
async function f() {

  try {
    let response = await fetch('http://no-such-url');
  } catch(err) {
*!*
    alert(err); // TypeError: failed to fetch
*/!*
  }
}

f();
```

如果有 error 发生，执行控制权马上就会被移交至 `catch` 块。我们也可以用 `try` 包装多行 `await` 代码：

```js run
async function f() {

  try {
    let response = await fetch('/no-user-here');
    let user = await response.json();
  } catch(err) {
    // 捕获到 fetch 和 response.json 中的错误
    alert(err);
  }
}

f();
```

如果我们没有 `try..catch`，那么由异步函数 `f()` 的调用生成的 promise 将变为 rejected。我们可以在函数调用后面添加 `.catch` 来处理这个 error：

```js run
async function f() {
  let response = await fetch('http://no-such-url');
}

// f() 变成了一个 rejected 的 promise
*!*
f().catch(alert); // TypeError: failed to fetch // (*)
*/!*
```

如果我们忘了在这添加 `.catch`，那么我们就会得到一个未处理的 promise error（可以在控制台中查看）。我们可以使用在 <info:promise-error-handling> 一章中所讲的全局事件处理程序 `unhandledrejection` 来捕获这类 error。


```smart header="`async/await` 和 `promise.then/catch`"
当我们使用 `async/await` 时，几乎就不会用到 `.then` 了，因为 `await` 为我们处理了等待。并且我们使用常规的 `try..catch` 而不是 `.catch`。这通常（但不总是）更加方便。

但是当我们在代码的顶层时，也就是在所有 `async` 函数之外，我们在语法上就不能使用 `await` 了，所以这时候通常的做法是添加 `.then/catch` 来处理最终的结果（result）或掉出来的（falling-through）error，例如像上面那个例子中的 `(*)` 行那样。
```

````smart header="`async/await` 可以和 `Promise.all` 一起使用"
当我们需要同时等待多个 promise 时，我们可以用 `Promise.all` 把它们包装起来，然后使用 `await`：

```js
// 等待结果数组
let results = await Promise.all([
  fetch(url1),
  fetch(url2),
  ...
]);
```

如果出现 error，也会正常传递，从失败了的 promise 传到 `Promise.all`，然后变成我们能通过使用 `try..catch` 在调用周围捕获到的异常（exception）。

````

### 总结

函数前面的关键字 `async` 有两个作用：

1. 让这个函数总是返回一个 promise。
2. 允许在该函数内使用 `await`。

Promise 前的关键字 `await` 使 JavaScript 引擎等待该 promise settle，然后：

1. 如果有 error，就会抛出异常 —— 就像那里调用了 `throw error` 一样。
2. 否则，就返回结果。

这两个关键字一起提供了一个很好的用来编写异步代码的框架，这种代码易于阅读也易于编写。

有了 `async/await` 之后，我们就几乎不需要使用 `promise.then/catch`，但是不要忘了它们是基于 promise 的，因为有些时候（例如在最外层作用域）我们不得不使用这些方法。并且，当我们需要同时等待需要任务时，`Promise.all` 是很好用的。
