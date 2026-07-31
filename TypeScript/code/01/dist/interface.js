"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const person = {
    a: "213"
};
var x = { name: 'xx', age: 20 };
let obj = {
    age: 18,
    name: "string"
};
const person1 = {
    a1: "213"
};
const person2 = {
    a2: "213",
    c2: "123"
};
const person3 = {
    a3: "213",
    c3: "123"
};
person3.a3 = 123;
const person4 = {
    a4: "213",
    c4: "123",
    // 重写cb方法
    cb: () => {
        console.log(123);
    }
};
person4.cb();
