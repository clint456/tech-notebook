"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
//unknown 可以定义任何类型的值
let value;
value = true; // OK
value = 42; // OK
value = "Hello World"; // OK
value = []; // OK
value = {}; // OK
value = null; // OK
value = undefined; // OK
value = Symbol("type"); // OK
//这样写会报错unknow类型不能作为子类型只能作为父类型 any可以作为父类型和子类型
//unknown类型不能赋值给其他类型
let names1 = '123';
let names2 = names1;
//这样就没问题 any类型是可以的
let names3 = '123';
let names4 = names3;
//unknown可赋值对象只有unknown 和 any
let bbb = '123';
let aaa = '456';
aaa = bbb;
// 如果是any类型在对象没有这个属性的时候还在获取是不会报错的
let obj1 = { b: 1 };
obj1.a;
// 如果是unknow 是不能调用属性和方法
let obj2 = { b: 1, ccc: () => 213 };
obj2.b;
obj2.ccc();
