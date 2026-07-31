# Null、undefined、void 类型三者完整区别（TS/JS）

## 一、基础定义总览

1. **undefined**：变量已声明，但**未赋值**；函数无返回值默认返回它；访问对象不存在属性得到它

2. **null**：**主动手动赋值**，代表 “空值、不存在对象”，人为清空变量使用

3. **void**：**操作符 / 类型关键字**，不是具体值，作用是**丢弃表达式返回值**，固定产生 `undefined`

## 二、JS 运行时层面（值层面）

### 1\. undefined

- 类型：`undefined`（原始类型）

- 值唯一：`undefined`

- 产生场景：

  ```js
  let a; // a = undefined
  function fn(){}; fn(); // 返回 undefined
  const obj = {}; obj.xxx // undefined
  ```

- 判断：`typeof undefined === 'undefined'`

### 2\. null

- 类型：`null`（原始类型，历史 bug `typeof null === 'object'`）

- 值唯一：`null`

- 产生场景：手动置空

  ```js
  let b = null; // 主动表示空对象
  ```

- 语义：**对象为空**，常用于释放引用

### 3\. void 操作符（JS）

`void 任意表达式` 执行表达式，**强制返回 undefined**

```js
void 0 // 等价 undefined（早期用来替代undefined，防止被覆盖）
const res = void (1+2); // res = undefined
// 常用场景：a标签阻止跳转
<a href="javascript:void(0)">点击</a>
```

`void` 本身**不是值**，是运算符，不会产生 null。

## 三、TypeScript 类型层面（核心区分）

### 1\. `undefined` 类型

- 对应值：`undefined`

- 含义：变量存在，但没有值

```ts
let u: undefined;
u = undefined; // 合法
u = null; // 严格模式下报错
```

### 2\. `null` 类型

- 对应值：`null`

- 含义：变量显式为空对象

```ts
let n: null;
n = null; // 合法
n = undefined; // 严格模式报错
```

> tsconfig 开启 `strictNullChecks: true`（现代项目默认）后，`null`/`undefined` 不能赋值给普通类型，需要联合类型：`string | null | undefined`
>
> 

### 3\. `void` 类型（TS 专属类型）

`void` 描述**函数无有效返回值**，只能接收 `undefined`，**不能接收 null**

1. 函数返回 void：代表忽略返回值，不建议读取返回结果

```ts
// 无返回
function log(): void {
  console.log('hello');
}
const v = log(); // v 的类型是 void，实际值 undefined
```

2. 不能给 void 变量赋值 null

```ts
let v: void;
v = undefined; // 允许
v = null; // 报错
```

3. 和 `undefined` 类型差异：

- `type T1 = undefined`：变量**只能存 undefined**，可以正常使用该值

- `type T2 = void`：仅用于返回值，表示**不关心返回值**，变量极少用

## 四、核心对比表格

| 维度             | undefined                          | null                                | void                              |
| ---------------- | ---------------------------------- | ----------------------------------- | --------------------------------- |
| 本质             | 原始值 / 类型                      | 原始值 / 类型                       | 运算符（JS）/ 返回值类型（TS）    |
| 实际取值         | 仅有 `undefined`                   | 仅有 `null`                         | 无自身值，运算后得到 `undefined`  |
| 语义             | 未定义、缺少赋值                   | 人为空对象、主动清空                | 舍弃返回结果，无有效返回          |
| typeof 判断      | `typeof x === 'undefined'`         | `typeof x === 'object'`（历史 bug） | 无 typeof，是操作符，不是值       |
| TS 中能否存 null | strict 开启后不可                  | 只能存 null                         | 完全不能存 null                   |
| 使用场景         | 变量未赋值、缺属性、无 return 函数 | 手动清空对象、初始化空引用          | void \(0\)、无返回回调 / 函数声明 |

## 五、相等性判断（JS）

```js
null == undefined  // true 宽松相等，语义都代表“空”
null === undefined // false 严格不等，类型不同

void 0 === undefined // true
void 0 === null      // false
```

## 六、高频易错点

1. **void ≠ undefined**
   `void` 是工具，`undefined` 是具体值；`void` 永远产出 `undefined`，但二者不是同一概念。

2. null 不能自动产生，必须手动赋值；undefined 程序会自动生成。

3. TS 函数返回 `void` 不代表函数一定没有 return，只是**不允许外部使用返回值**：

```ts
function fn(): void {
  return 123; // 语法允许，但调用者不能拿返回值使用
}
```

4. 用途区分口诀：

- 自动空、未赋值 → undefined

- 手动清空对象 → null

- 丢弃返回、阻止跳转 → void

> （注：部分内容可能由 AI 生成）