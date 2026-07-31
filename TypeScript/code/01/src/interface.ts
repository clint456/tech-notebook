//这样写是会报错的 因为我们在person定义了a，b但是对象里面缺少b属性
//使用接口约束的时候不能多一个属性也不能少一个属性
//必须与接口保持一致
interface Person {
    b:string,
    a:string
}
 
const person:Person  = {
    a:"213"
}

// 合并
interface A1{name:string}
interface A1{age:number}


var x:A1={name:'xx',age:20}

// 继承
interface A2{
    name:string
}

interface B1 extends A2{
    age:number
}
 
let obj:B1 = {
    age:18,
    name:"string"
}

// 可选属性
// 含义是该属性可以不存在
// 所以说这样写也是没问题的
interface Person1 {
    b1?:string,
    a1:string
}
 
const person1:Person1  = {
    a1:"213"
}

//在这个例子当中我们看到接口中并没有定义C但是并没有报错
//应为我们定义了[propName: string]: any;
//允许添加新的任意属性
interface Person2 {
    b2?:string,
    a2:string,
    [propName: string]: any;
}
 
const person2:Person2  = {
    a2:"213",
    c2:"123"
}

//这样写是会报错的
//应为a是只读的不允许重新赋值
interface Person3 {
    b3?: string,
    readonly a3: string,
    [propName: string]: any;
}
 
const person3: Person3 = {
    a3: "213",
    c3: "123"
}
 
person3.a3 = 123

// 添加方法属性
interface Person4 {
    b4?: string,
    readonly a4: string,
    [propName: string]: any;
    cb:()=>void
}
 
const person4: Person4 = {
    a4: "213",
    c4: "123",
    // 重写cb方法
    cb:()=>{
        console.log(123)
    }
}

person4.cb()